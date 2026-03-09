import 'dart:async';

import 'package:equatable/equatable.dart';

import 'package:expensetracker/domain/cache.dart';
import 'package:expensetracker/domain/event_bus/event.dart';
import 'package:expensetracker/domain/event_bus/events/person_event.dart'
    as domain_events;
import 'package:expensetracker/domain/model/debt.dart';
import 'package:expensetracker/domain/model/person.dart';

import 'package:expensetracker/domain/usecase/debt/getters/get_debts_by_creditor_id_usecase.dart';
import 'package:expensetracker/domain/usecase/debt/getters/get_debts_by_debtor_id_usecase.dart';
import 'package:expensetracker/domain/usecase/person/getters/get_all_people_usecase.dart';
import 'package:expensetracker/domain/usecase/person/getters/get_page_people_usecase.dart';
import 'package:expensetracker/domain/usecase/person/getters/get_person_by_id_usecase.dart';

import 'package:expensetracker/domain/usecase/person/mutations/create_person_usecase.dart';
import 'package:expensetracker/domain/usecase/person/mutations/delete_person_usecase.dart';
import 'package:expensetracker/domain/usecase/person/mutations/update_person_usecase.dart';

import 'package:expensetracker/utils/list_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'person_event.dart';
part 'person_state.dart';

// TODO: check for improvements for PersonLoading event, i.e. where it can be added etc.
class PersonBloc extends Bloc<PersonEvent, PersonState> {
  final GetAllPeopleUseCase _getAllPeopleUseCase;
  final CreatePersonUseCase _createPersonUseCase;
  final UpdatePersonUseCase _updatePersonUseCase;
  final DeletePersonUseCase _deletePersonUseCase;
  final GetPagePeopleUseCase _getPagePeopleUseCase;
  final GetPersonByIdUseCase _getPersonByIdUseCase;
  final GetDebtsByCreditorIdUseCase _getDebtsByCreditorIdUseCase;
  final GetDebtsByDebtorIdUseCase _getDebtsByDebtorIdUseCase;

  final Cache cache;
  final EventBus _eventBus;

  late StreamSubscription _personUpdatedSubscription;
  late StreamSubscription _personAddedSubscription;
  late StreamSubscription _updatePersonSubscription;
  late StreamSubscription _deletePersonSubscription;
  late StreamSubscription _removePersonSubscription;
  late StreamSubscription _personDeletedSubscription;
  late StreamSubscription _unloadPersonSubscription;

  /// Constructs a [PersonBloc] instance.
  ///
  /// This constructor initializes the BLoC with various use cases, a cache,
  /// and an event bus. It sets the initial state to `PersonInitial` and
  /// configures event handlers for all defined `PersonEvent`s.
  ///
  /// It also sets up subscriptions to `domain_events` from the `EventBus`
  /// to react to external changes in person data (e.g., updates, additions,
  /// deletions originating from other parts of the application or data layer).
  ///
  /// **Dependencies:**
  /// - `_getAllPeopleUseCase`: For fetching all persons.
  /// - `_createPersonUseCase`: For creating new persons.
  /// - `_updatePersonUseCase`: For updating existing persons.
  /// - `_deletePersonUseCase`: For deleting persons.
  /// - `_getPagePeopleUseCase`: For fetching persons by page.
  /// - `_getPersonByIdUseCase`: For fetching a single person by ID.
  /// - `_getDebtsByCreditorIdUseCase`: For fetching debts where the person is the creditor.
  /// - `_getDebtsByDebtorIdUseCase`: For fetching debts where the person is the debtor.
  /// - `cache`: The application's caching mechanism for Person objects.
  /// - `_eventBus`: The domain event bus for cross-BLoC communication.
  PersonBloc(
    this._getAllPeopleUseCase,
    this._createPersonUseCase,
    this._updatePersonUseCase,
    this._deletePersonUseCase,
    this._getPagePeopleUseCase,
    this._getPersonByIdUseCase,
    this._getDebtsByCreditorIdUseCase,
    this._getDebtsByDebtorIdUseCase,
    this.cache,
    this._eventBus,
  ) : super(PersonInitial()) {
    on<LoadAllPeopleEvent>(_onLoadAllPeople);
    on<GetPagePeopleEvent>(_onGetPagePeople);
    on<GetPersonDebtsOwedEvent>(_onGetDebtsOwed);
    on<GetPersonDebtsReceivableEvent>(_onGetDebtsReceivable);

    on<CreatePersonEvent>(_onCreatePerson);
    on<UpdatePersonEvent>(_onUpdatePerson);
    on<DeletePersonEvent>(_onDeletePerson);

    on<PersonUpdatedEvent>(_onPersonUpdated);
    on<RemovePersonEvent>(_onRemovePerson);
    on<PersonDeletedEvent>(_onPersonDeleted);

    on<UnloadPersonEvent>(_onUnloadPerson);
    on<UnloadPeopleEvent>(_onUnloadPeople);

    _personUpdatedSubscription = _eventBus
        .on<domain_events.PersonUpdatedEvent>()
        .listen((event) {
          add(PersonUpdatedEvent(event.person));
        });

    _personAddedSubscription = _eventBus
        .on<domain_events.PersonCreatedEvent>()
        .listen((event) {
          // Not adding anything as load is supposed to be called when needed
          // not when new item is added. Maybe it can reload the current page
          // instead of adding the person to cache pool.

          // cache.addStrong(event.person);
          // add(LoadAllPeopleEvent());
        });

    _updatePersonSubscription = _eventBus
        .on<domain_events.UpdatePersonEvent>()
        .listen((event) async {
          add(UpdatePersonEvent(event.person));
        });

    _deletePersonSubscription = _eventBus
        .on<domain_events.DeletePersonEvent>()
        .listen((event) {
          add(DeletePersonEvent(event.person));
        });

    _removePersonSubscription = _eventBus
        .on<domain_events.RemovePersonEvent>()
        .listen((event) {
          add(RemovePersonEvent(event.person));
        });

    _personDeletedSubscription = _eventBus
        .on<domain_events.PersonDeletedEvent>()
        .listen((event) {
          add(PersonDeletedEvent(event.personId));
        });

    // TODO: This might not be needed in practice
    _unloadPersonSubscription = _eventBus
        .on<domain_events.UnloadPersonEvent>()
        .listen((event) {
          final person = cache.get<Person>(event.personId);
          if (person != null) {
            add(UnloadPersonEvent(person));
          }
        });
  }

  /// Closes the [PersonBloc] and cancels all active `StreamSubscription`s
  /// to prevent memory leaks and ensure proper resource management.
  ///
  /// This method should be called when the BLoC is no longer needed, typically
  /// in the `dispose()` method of the associated UI widget or when the BLoC's
  /// lifecycle ends.
  ///
  /// It ensures that all listeners to domain events are detached, preventing
  /// the BLoC from reacting to events after it has been disposed.
  @override
  Future<void> close() {
    _personUpdatedSubscription.cancel();
    _personAddedSubscription.cancel();
    _updatePersonSubscription.cancel();
    _deletePersonSubscription.cancel(); // Cancel new subscription
    _removePersonSubscription.cancel(); // Cancel new subscription
    _personDeletedSubscription.cancel();
    _unloadPersonSubscription.cancel(); // Cancel new subscription
    return super.close();
  }

  /// Emits a `PersonLoaded` state containing all [Person] objects currently
  /// present in the BLoC's internal cache.
  ///
  /// This helper method is typically called after any operation that modifies
  /// the collection of persons in the cache (e.g., loading new data, updating
  /// an existing person, or removing a person). It ensures that the UI always
  /// receives the most up-to-date representation of the person list.
  ///
  /// [emit]: The `Emitter<PersonState>` to emit the `PersonLoaded` state.
  void _emitLoadedPeople(Emitter<PersonState> emit) {
    emit(PersonLoaded(cache.getAll<Person>()));
  }

  /// Handles the `PersonUpdatedEvent`, which is a notification that a [Person]
  /// has been updated, either from a domain event or after a successful UI-initiated update.
  ///
  /// This method updates the BLoC's internal cache with the latest version of the
  /// [Person] and then emits a new `PersonLoaded` state to reflect this change
  /// in the UI.
  ///
  /// [event]: The `PersonUpdatedEvent` containing the updated [Person] object.
  /// [emit]: The `Emitter<PersonState>` to emit new states.
  Future<void> _onPersonUpdated(
    PersonUpdatedEvent event,
    Emitter<PersonState> emit,
  ) async {
    cache.update(event.person);
    _emitLoadedPeople(emit);
  }

  /// Handles the `LoadAllPeopleEvent`.
  ///
  /// This method is responsible for initiating the loading of all [Person]
  /// objects from the persistent data source. It uses the `_getAllPeopleUseCase`
  /// to perform this retrieval.
  ///
  /// **Workflow:**
  /// 1. Emits `PersonLoading()` to signal that data fetching is in progress,
  ///    allowing the UI to display a loading indicator.
  /// 2. Executes the `_getAllPeopleUseCase.call()` to retrieve all persons.
  /// 3. For each fetched person, it adds them to the BLoC's internal `cache`
  ///    using `cache.addStrong`, establishing a strong reference.
  /// 4. Calls `_emitLoadedPeople(emit)` to emit a `PersonLoaded` state,
  ///    providing the complete list of persons (from cache) to the UI.
  /// 5. Catches any exceptions during the loading process and emits `PersonError()`
  ///    with a descriptive message.
  ///
  /// **Purpose:** To provide the UI with an initial or refreshed list of all
  /// available `Person` entities, ensuring the internal cache is synchronized
  /// with the latest data from the data source.
  ///
  /// [event]: The `LoadAllPeopleEvent` that triggers this data loading operation.
  /// [emit]: The `Emitter<PersonState>` used to emit `PersonLoading`, `PersonLoaded`,
  ///         or `PersonError` states.
  Future<void> _onLoadAllPeople(
    LoadAllPeopleEvent event,
    Emitter<PersonState> emit,
  ) async {
    emit(PersonLoading());
    try {
      final List<Person> all = await _getAllPeopleUseCase.call();
      all.forEach(cache.addStrong);
      _emitLoadedPeople(emit);
    } catch (e) {
      emit(PersonError("$e\nFailed to load"));
    }
  }

  /// Handles the `UnloadPersonEvent`.
  ///
  /// This method is responsible for releasing a strong reference to a single
  /// [Person] object in the BLoC's internal cache. This typically means the
  /// UI no longer requires this specific person to maintain a strong reference,
  /// allowing it to be potentially garbage collected if no other strong
  /// references exist.
  ///
  /// **Workflow:**
  /// 1. Calls `cache.releaseStrong(event.person)` to decrement the strong
  ///    reference count for the specified person in the cache.
  /// 2. Calls `_emitLoadedPeople(emit)` to emit a `PersonLoaded` state,
  ///    reflecting the potentially changed reference counts or removal if
  ///    references dropped to zero.
  ///
  /// **Purpose:** To manage memory and resource usage by allowing the BLoC to
  /// reduce its strong hold on `Person` objects that are no longer actively
  /// needed by the UI, but without necessarily removing them entirely if weak
  /// references or other strong references still exist.
  ///
  /// [event]: The `UnloadPersonEvent` containing the [Person] to be unloaded.
  /// [emit]: The `Emitter<PersonState>` used to emit the `PersonLoaded` state.
  Future<void> _onUnloadPerson(
    UnloadPersonEvent event,
    Emitter<PersonState> emit,
  ) async {
    cache.releaseStrong<Person>(event.person);
    _emitLoadedPeople(emit);
  }

  /// Handles the `UnloadPeopleEvent`.
  ///
  /// This method is responsible for releasing strong references to a list of
  /// [Person] objects in the BLoC's internal cache. This is useful when a
  /// collection of persons is no longer actively needed by the UI, allowing
  /// the cache to manage their lifecycle more efficiently.
  ///
  /// **Workflow:**
  /// 1. Iterates through each `person` in `event.people`.
  /// 2. For each `person`, it calls `cache.releaseStrong(person)` to decrement
  ///    its strong reference count in the cache.
  /// 3. After processing all persons, it calls `_emitLoadedPeople(emit)` to emit
  ///    a `PersonLoaded` state, updating the UI with the cache's current contents.
  ///
  /// **Purpose:** To manage memory and resource usage by reducing the BLoC's
  /// strong hold on multiple `Person` objects simultaneously. This does not
  /// necessarily remove them from the cache entirely if other references exist.
  ///
  /// [event]: The `UnloadPeopleEvent` containing the list of [Person] objects
  ///          to be unloaded.
  /// [emit]: The `Emitter<PersonState>` used to emit the `PersonLoaded` state.
  Future<void> _onUnloadPeople(
    UnloadPeopleEvent event,
    Emitter<PersonState> emit,
  ) async {
    for (var person in event.people) {
      cache.releaseStrong<Person>(person);
    }
    _emitLoadedPeople(emit);
  }

  /// Handles the `CreatePersonEvent`.
  ///
  /// This method is responsible for creating a new [Person] entity in the
  /// persistent data store. It uses the `_createPersonUseCase` to perform
  /// the creation.
  ///
  /// **Workflow:**
  /// 1. Emits `PersonLoading()` to indicate that a creation operation is in progress.
  /// 2. Calls `_createPersonUseCase.call(event.person)` to save the new person
  ///    to the data source.
  /// 3. If the creation is successful, no further state is explicitly emitted
  ///    here, assuming a subsequent `PersonAddedEvent` from the domain event bus
  ///    will handle cache updates and UI refresh.
  /// 4. Catches any exceptions during the creation process and emits `PersonError()`
  ///    with a descriptive message.
  ///
  /// **Purpose:** To manage the lifecycle of [Person] entities by providing a
  /// mechanism to add new persons to the application's data layer.
  ///
  /// [event]: The `CreatePersonEvent` containing the [Person] object to be created.
  /// [emit]: The `Emitter<PersonState>` used to emit `PersonLoading` or `PersonError` states.
  Future<void> _onCreatePerson(
    CreatePersonEvent event,
    Emitter<PersonState> emit,
  ) async {
    emit(PersonLoading());
    try {
      await _createPersonUseCase.call(event.person);
    } catch (e) {
      emit(PersonError("$e\nFailed to create Person"));
    }
  }

  /// Handles the `DeletePersonEvent`.
  ///
  /// This method is responsible for initiating the deletion of a [Person]
  /// entity from the persistent data store. It uses the `_deletePersonUseCase`
  /// to perform this operation.
  ///
  /// **Workflow:**
  /// 1. Emits `PersonLoading()` to indicate that a deletion operation is in progress.
  /// 2. Calls `_deletePersonUseCase.call(event.person.id)` to remove the person
  ///    from the data source.
  /// 3. If the deletion from the data source is successful, it *does not*
  ///    directly update the cache or emit `PersonLoaded`. Instead, it relies
  ///    on the `RemovePersonEvent` (which is typically dispatched either by
  ///    the domain event bus or explicitly after this method) to handle the
  ///    cache removal and subsequent UI update.
  /// 4. Catches any exceptions during the deletion process and emits `PersonError()`
  ///    with a descriptive message.
  ///
  /// **Purpose:** To manage the lifecycle of [Person] entities by providing a
  /// mechanism to remove persons from the application's data layer.
  ///
  /// [event]: The `DeletePersonEvent` containing the [Person] object to be deleted.
  /// [emit]: The `Emitter<PersonState>` used to emit `PersonLoading` or `PersonError` states.
  Future<void> _onDeletePerson(
    DeletePersonEvent event,
    Emitter<PersonState> emit,
  ) async {
    emit(PersonLoading());
    try {
      await _deletePersonUseCase.call(event.person.id);
    } catch (e) {
      emit(PersonError("$e\nFailed to remove Person"));
    }
  }

  /// Handles the `RemovePersonEvent`.
  ///
  /// This method is a notification handler responsible for updating the BLoC's
  /// internal cache and UI state after a [Person] has been successfully
  /// removed from the persistent data store (or is intended to be removed
  /// from the cache for other reasons).
  ///
  /// **Workflow:**
  /// 1. Calls `cache.remove<Person>(event.person.id)` to explicitly remove the
  ///    specified person from the BLoC's internal cache.
  /// 2. Calls `_emitLoadedPeople(emit)` to emit a `PersonLoaded` state,
  ///    reflecting the updated list of persons (without the removed one) to the UI.
  ///
  /// **Purpose:** To keep the BLoC's local cache and the UI synchronized with
  /// the data layer's state regarding person deletions, ensuring that the
  /// removed person is no longer displayed.
  ///
  /// [event]: The `RemovePersonEvent` containing the [Person] object to be removed from the cache.
  /// [emit]: The `Emitter<PersonState>` used to emit the `PersonLoaded` state.
  Future<void> _onRemovePerson(
    RemovePersonEvent event,
    Emitter<PersonState> emit,
  ) async {
    cache.remove<Person>(event.person.id);
    _emitLoadedPeople(emit);
  }

  /// Handles the `PersonDeletedEvent`.
  ///
  /// This method is a notification handler responsible for updating the BLoC's
  /// internal cache and UI state after a [Person] has been successfully
  /// deleted from the persistent data store (or is intended to be removed
  /// from the cache for other reasons).
  ///
  /// **Workflow:**
  /// 1. Calls `cache.remove<Person>(event.personId)` to explicitly remove the
  ///    specified person from the BLoC's internal cache.
  /// 2. Calls `_emitLoadedPeople(emit)` to emit a `PersonLoaded` state,
  ///    reflecting the updated list of persons (without the removed one) to the UI.
  ///
  /// **Purpose:** To keep the BLoC's local cache and the UI synchronized with
  /// the data layer's state regarding person deletions, ensuring that the
  /// removed person is no longer displayed.
  ///
  /// [event]: The `PersonDeletedEvent` containing the [Person] object to be removed from the cache.
  /// [emit]: The `Emitter<PersonState>` used to emit the `PersonLoaded` state.
  Future<void> _onPersonDeleted(
    PersonDeletedEvent event,
    Emitter<PersonState> emit,
  ) async {
    cache.remove<Person>(event.personId);
    _emitLoadedPeople(emit);
  }

  /// Handles the `UpdatePersonEvent`.
  ///
  /// This method is responsible for initiating the update of an existing
  /// [Person] entity in the persistent data store. It uses the `_updatePersonUseCase`
  /// to perform this operation.
  ///
  /// **Workflow:**
  /// 1. Emits `PersonLoading()` to indicate that an update operation is in progress.
  /// 2. Calls `_updatePersonUseCase.call(event.person)` to save the updated person
  ///    to the data source.
  /// 3. If the update to the data source is successful, it *does not*
  ///    directly update the cache or emit `PersonLoaded`. Instead, it relies
  ///    on the `PersonUpdatedEvent` (which is typically dispatched either by
  ///    the domain event bus or explicitly after this method) to handle the
  ///    cache update and subsequent UI refresh.
  /// 4. Catches any exceptions during the update process and emits `PersonError()`
  ///    with a descriptive message.
  ///
  /// **Purpose:** To manage the lifecycle of [Person] entities by providing a
  /// mechanism to modify existing persons in the application's data layer.
  ///
  /// [event]: The `UpdatePersonEvent` containing the updated [Person] object.
  /// [emit]: The `Emitter<PersonState>` used to emit `PersonLoading` or `PersonError` states.
  Future<void> _onUpdatePerson(
    UpdatePersonEvent event,
    Emitter<PersonState> emit,
  ) async {
    emit(PersonLoading());
    try {
      await _updatePersonUseCase.call(event.person);
    } catch (e) {
      emit(PersonError("$e\nFailed to update Person"));
    }
  }

  /// Handles the `GetPagePeopleEvent`.
  ///
  /// This method is responsible for fetching a specific page of [Person]
  /// objects from the persistent data source, typically used for pagination
  /// or lazy loading. It uses the `_getPagePeopleUseCase` to retrieve the data.
  ///
  /// **Workflow:**
  /// 1. Emits `PersonLoading()` to signal that data fetching for the page is in progress.
  /// 2. Calls `_getPagePeopleUseCase.call(event.page, event.limit)` to retrieve
  ///    the specified page of persons.
  /// 3. For each fetched person in the page, it adds them to the BLoC's internal
  ///    `cache` using `cache.addStrong`, establishing a strong reference.
  /// 4. Calls `_emitLoadedPeople(emit)` to emit a `PersonLoaded` state,
  ///    providing the updated list of persons (from cache) to the UI.
  /// 5. Catches any exceptions during the page fetching process and emits `PersonError()`
  ///    with a descriptive message.
  ///
  /// **Purpose:** To efficiently load and display subsets of [Person] data,
  /// supporting features like infinite scrolling or paginated lists.
  ///
  /// [event]: The `GetPagePeopleEvent` containing the page number and limit for fetching.
  /// [emit]: The `Emitter<PersonState>` used to emit `PersonLoading`, `PersonLoaded`,
  ///         or `PersonError` states.
  Future<void> _onGetPagePeople(
    GetPagePeopleEvent event,
    Emitter<PersonState> emit,
  ) async {
    emit(PersonLoading());
    try {
      final List<Person> pageData = await _getPagePeopleUseCase.call(
        event.page,
        event.limit,
      );
      // TODO: maybe move move this logic to some kind of event handled single item loading mechanism
      pageData.forEach(cache.addStrong);
      _emitLoadedPeople(emit);
    } catch (e) {
      emit(PersonError("$e\nFailed to fetch Person for page: ${event.page}"));
    }
  }

  /// Handles the `GetPersonDebtsOwedEvent`.
  ///
  /// This method is responsible for fetching a partial list of debts owed by a
  /// specific [Person] from the underlying data source via `_getDebtsByCreditorIdUseCase`.
  ///
  /// **Crucially, this method focuses solely on data retrieval and local cache
  /// manipulation; it does NOT persist any changes to the Person object
  /// (e.g., to the database).** Any persistence of the updated Person object,
  /// especially after modifying its debt lists, should be triggered by a
  /// separate event (e.g., `UpdatePersonEvent`) initiated by a user action
  /// if database updates are required.
  ///
  /// The workflow is as follows:
  /// 1. Emits `PersonLoading()` to indicate a loading state.
  /// 2. Retrieves the [Person] from the cache. If not found, emits `PersonError`.
  /// 3. Calls `_getPersonDebtsOwedUseCase` to fetch debts.
  /// 4. Adds fetched debts to the cache using `cache.addWeak` (weak reference).
  /// 5. Updates the [Person] object in the cache with the new `debtsOwed` list
  ///    using `cache.update`. The `event.replace` flag determines if the new
  ///    list completely replaces the old one or is merged.
  /// 6. Emits `PersonLoaded()` to reflect the updated Person data in the UI.
  /// 7. Catches any errors during the process and emits `PersonError()`.
  ///
  /// This method ensures the UI has access to the latest fetched debt data
  /// for a person without implicitly triggering a database save for the person itself.
  ///
  /// [event]: The `GetPersonDebtsOwedEvent` containing the person, page, limit,
  ///          and a flag to replace or merge the debt list.
  /// [emit]: The `Emitter<PersonState>` to emit new states.
  Future<void> _onGetDebtsOwed(
    GetPersonDebtsOwedEvent event,
    Emitter<PersonState> emit,
  ) async {
    emit(PersonLoading());
    try {
      Person? person = cache.get<Person>(event.person.id);
      if (person == null) {
        emit(
          PersonError(
            'Person with id ${event.person.id} is not loaded. Debts cannot be fetched.',
          ),
        );
        return;
      }

      final List<Debt> fetchedDebts = await _getDebtsByCreditorIdUseCase.call(
        event.person.id,
        event.page,
        event.limit,
      );

      fetchedDebts.forEach(cache.addWeak);

      if (event.replace) {
        final List<Debt> debtsToRemove = mergeOrDifferenceLists(
          person.debtsOwed,
          fetchedDebts,
          true,
          growable: false,
        );
        debtsToRemove.forEach(cache.releaseStrong);

        cache.update(person.copyWith(debtsOwed: fetchedDebts));
      } else {
        cache.update(
          person.copyWith(
            debtsOwed: mergeOrDifferenceLists(
              person.debtsOwed,
              fetchedDebts,
              false,
              growable: false,
            ),
          ),
        );
      }
      _emitLoadedPeople(emit);
    } catch (e) {
      emit(PersonError("$e\nFailed to fetch debts owed for Person"));
    }
  }

  /// Handles the `GetPersonDebtsReceivableEvent`.
  ///
  /// This method is responsible for fetching a partial list of debts receivable by a
  /// specific [Person] from the underlying data source via `_getDebtsByDebtorIdUseCase`.
  ///
  /// **Crucially, this method focuses solely on data retrieval and local cache
  /// manipulation; it does NOT persist any changes to the Person object
  /// (e.g., to the database).** Any persistence of the updated Person object,
  /// especially after modifying its debt lists, should be triggered by a
  /// separate event (e.g., `UpdatePersonEvent`) initiated by a user action
  /// if database updates are required.
  ///
  /// The workflow is as follows:
  /// 1. Emits `PersonLoading()` to indicate a loading state.
  /// 2. Retrieves the [Person] from the cache. If not found, emits `PersonError`.
  /// 3. Calls `_getPersonDebtsReceivableUseCase` to fetch debts receivable.
  /// 4. Adds fetched debts to the cache using `cache.addWeak` (weak reference).
  /// 5. Updates the [Person] object in the cache with the new `debtsReceivable` list
  ///    using `cache.update`. The `event.replace` flag determines if the new
  ///    list completely replaces the old one or is merged.
  /// 6. Emits `PersonLoaded()` to reflect the updated Person data in the UI.
  /// 7. Catches any errors during the process and emits `PersonError()`.
  ///
  /// This method ensures the UI has access to the latest fetched debt data
  /// for a person without implicitly triggering a database save for the person itself.
  ///
  /// [event]: The `GetPersonDebtsReceivableEvent` containing the person, page, limit,
  ///          and a flag to replace or merge the debt list.
  /// [emit]: The `Emitter<PersonState>` to emit new states.
  Future<void> _onGetDebtsReceivable(
    GetPersonDebtsReceivableEvent event,
    Emitter<PersonState> emit,
  ) async {
    emit(PersonLoading());
    try {
      // Fetch debts using the use case
      final List<Debt> fetchedDebts = await _getDebtsByDebtorIdUseCase.call(
        event.person.id,
        event.page,
        event.limit,
      );

      // Caching and state emission logic (extracted from _handleDebtFetchingLogic)
      Person? person = cache.get<Person>(event.person.id);
      if (person == null) {
        emit(
          PersonError(
            'Person with id ${event.person.id} is not loaded. Debts cannot be fetched.',
          ),
        );
        return;
      }

      fetchedDebts.forEach(cache.addWeak);

      if (event.replace) {
        final List<Debt> debtsToRemove = mergeOrDifferenceLists(
          person.debtsReceivable,
          fetchedDebts,
          true,
          growable: false,
        );
        debtsToRemove.forEach(cache.releaseStrong);

        cache.update(person.copyWith(debtsReceivable: fetchedDebts));
      } else {
        cache.update(
          person.copyWith(
            debtsReceivable: mergeOrDifferenceLists(
              person.debtsReceivable,
              fetchedDebts,
              false,
              growable: false,
            ),
          ),
        );
      }
      _emitLoadedPeople(emit);
    } catch (e) {
      emit(PersonError("$e\nFailed to fetch debts receivable for Person"));
    }
  }

  /// Retrieves all [Person] objects that are currently loaded and managed
  /// by the BLoC's internal cache.
  ///
  /// This method provides direct access to the BLoC's local state without
  /// triggering any events or state changes. It is useful for components that
  /// need to quickly access the current set of loaded persons.
  ///
  /// Returns a `Future<List<Person>>` containing all persons from the cache.
  Future<List<Person>> getAllLoaded() async {
    return cache.getAll<Person>().values.toList(growable: false);
  }

  /// Retrieves a single [Person] object by its `id` from the BLoC's internal
  /// cache, falling back to the persistent data source if not found in cache.
  ///
  /// This method first checks the local cache for the person. If the person
  /// is found in the cache, it can optionally add a strong reference if `strong`
  /// is true and no strong references exist.
  /// If the person is not in the cache, it attempts to fetch it from the data
  /// source using `_getPersonByIdUseCase`. Upon successful retrieval, the person
  /// is added to the cache with a strong reference if `strong` is true,
  /// otherwise the fetched person is returned without adding a strong reference
  /// to the cache.
  ///
  /// **Parameters:**
  /// - `id`: The unique identifier of the [Person] to retrieve.
  /// - `strong`: Optional. If `true`, ensures a strong reference to the person
  ///   in the cache if it's already there but only has weak references. Defaults to `true`.
  ///
  /// Returns a `Future<Person?>`, which resolves to the [Person] object if found,
  /// or `null` if not found or an error occurs during retrieval.
  Future<Person?> getById(int id, [bool strong = true]) async {
    final person = cache.get<Person>(id);
    if (person != null) {
      if (strong && cache.references(person) <= 0) cache.addStrong(person);
      return person;
    }

    try {
      final fetchedPerson = await _getPersonByIdUseCase.call(id);
      if (fetchedPerson == null) {
        return null;
      }
      if (strong) cache.addStrong(fetchedPerson);
      return fetchedPerson;
    } catch (e) {
      return null;
    }
  }
}
