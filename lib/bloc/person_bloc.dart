import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:expensetracker/domain/model/debt.dart';
import 'package:expensetracker/domain/model/person.dart';

import 'package:expensetracker/domain/cache.dart';
import 'package:expensetracker/domain/event_bus/event.dart';
import 'package:expensetracker/domain/event_bus/events/person_event.dart'
    as domain_events;

import 'package:expensetracker/utils/list_utils.dart';

import 'package:expensetracker/domain/usecase/person/getters/get_all_people_usecase.dart';
import 'package:expensetracker/domain/usecase/person/getters/get_page_people_usecase.dart';
import 'package:expensetracker/domain/usecase/person/getters/get_person_by_id_usecase.dart';

import 'package:expensetracker/domain/usecase/person/mutations/create_person_usecase.dart';
import 'package:expensetracker/domain/usecase/person/mutations/delete_person_usecase.dart';
import 'package:expensetracker/domain/usecase/person/mutations/update_person_usecase.dart';

import 'package:expensetracker/domain/usecase/debt/getters/get_debts_by_creditor_id_usecase.dart';
import 'package:expensetracker/domain/usecase/debt/getters/get_debts_by_debtor_id_usecase.dart';

part 'person_event.dart';
part 'person_state.dart';

// TODO: check for improvements for PersonLoading event, i.e. where it can be added etc.
class PersonBloc extends Bloc<PersonEvent, PersonState> {
  final GetAllPeopleUseCase _getAllPeopleUseCase;
  final GetPagePeopleUseCase _getPagePeopleUseCase;
  final GetPersonByIdUseCase _getPersonByIdUseCase;

  final CreatePersonUseCase _createPersonUseCase;
  final UpdatePersonUseCase _updatePersonUseCase;
  final DeletePersonUseCase _deletePersonUseCase;

  final GetDebtsByCreditorIdUseCase _getDebtsByCreditorIdUseCase;
  final GetDebtsByDebtorIdUseCase _getDebtsByDebtorIdUseCase;

  final Cache cache;
  final EventBus _eventBus;

  late StreamSubscription _personUpdatedSubscription;
  late StreamSubscription _personAddedSubscription;
  late StreamSubscription _updatePersonSubscription;
  late StreamSubscription _deletePersonSubscription;
  late StreamSubscription _personDeletedSubscription;
  late StreamSubscription _unloadPersonSubscription;

  PersonBloc(
    this._getAllPeopleUseCase,
    this._getPagePeopleUseCase,
    this._getPersonByIdUseCase,
    this._createPersonUseCase,
    this._updatePersonUseCase,
    this._deletePersonUseCase,
    this._getDebtsByCreditorIdUseCase,
    this._getDebtsByDebtorIdUseCase,
    this.cache,
    this._eventBus,
  ) : super(PersonInitial()) {
    on<LoadAllPeopleEvent>(_onLoadAllPeople);
    on<GetPagePeopleEvent>(_onGetPagePeople);
    on<GetPersonDebtsOwedEvent>(_onGetDebtsOwed);
    on<GetPersonDebtsReceivableEvent>(_onGetDebtsReceivable);
    on<UnloadPersonEvent>(_onUnloadPerson);
    on<UnloadPeopleEvent>(_onUnloadPeople);

    on<CreatePersonEvent>(_onCreatePerson);
    on<UpdatePersonEvent>(_onUpdatePerson);
    on<DeletePersonEvent>(_onDeletePerson);

    on<PersonCreatedEvent>(_onPersonCreated);
    on<PersonUpdatedEvent>(_onPersonUpdated);
    on<PersonDeletedEvent>(_onPersonDeleted);
    on<GetPersonByIdEvent>(_onGetPersonById);

    _personUpdatedSubscription = _eventBus
        .on<domain_events.PersonUpdatedEvent>()
        .listen((event) {
          add(PersonUpdatedEvent(event.person));
        });

    _personAddedSubscription = _eventBus
        .on<domain_events.PersonCreatedEvent>()
        .listen((event) {
          add(PersonCreatedEvent(event.person));
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

    _personDeletedSubscription = _eventBus
        .on<domain_events.PersonDeletedEvent>()
        .listen((event) {
          add(PersonDeletedEvent(event.personId));
        });

    _unloadPersonSubscription = _eventBus
        .on<domain_events.UnloadPersonEvent>()
        .listen((event) {
          final person = cache.get<Person>(event.personId);
          if (person != null) {
            add(UnloadPersonEvent(person));
          }
        });
  }

  @override
  Future<void> close() {
    _personUpdatedSubscription.cancel();
    _personAddedSubscription.cancel();
    _updatePersonSubscription.cancel();
    _deletePersonSubscription.cancel();
    _personDeletedSubscription.cancel();
    _unloadPersonSubscription.cancel();
    return super.close();
  }

  // void _emitLoadedPeople(
  //   Emitter<PersonState> emit, {
  //   int currentPage = 0,
  //   PersonActionType? lastActionType,
  //   int? lastActionPersonId,
  // }) {
  //   emit(
  //     PersonLoaded(
  //       cache.getAll<Person>(),
  //       currentPage: currentPage,
  //       lastActionType: lastActionType,
  //       lastActionPersonId: lastActionPersonId,
  //     ),
  //   );
  // }

  Future<void> _onPersonUpdated(
    PersonUpdatedEvent event,
    Emitter<PersonState> emit,
  ) async {
    cache.update(event.person);
    emit(PersonUpdated(event.person));
  }

  Future<void> _onLoadAllPeople(
    LoadAllPeopleEvent event,
    Emitter<PersonState> emit,
  ) async {
    emit(PersonLoading());
    try {
      final List<Person> all = await _getAllPeopleUseCase.call();
      all.forEach(cache.addStrong);
      emit(
        PersonLoaded(
          cache.getAll<Person>(),
        ),
      );
    } catch (e) {
      emit(PersonError("$e\nFailed to load"));
    }
  }

  Future<void> _onUnloadPerson(
    UnloadPersonEvent event,
    Emitter<PersonState> emit,
  ) async {
    cache.releaseStrong<Person>(event.person);
    emit(
      PersonLoaded(
        cache.getAll<Person>(),
      ),
    );
  }

  Future<void> _onUnloadPeople(
    UnloadPeopleEvent event,
    Emitter<PersonState> emit,
  ) async {
    event.people.forEach(cache.releaseStrong<Person>);
    // for (var person in event.people) {
    //   cache.releaseStrong<Person>(person);
    // }
    emit(
      PersonLoaded(
        cache.getAll<Person>(),
      ),
    );
  }

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

  Future<void> _onPersonDeleted(
    PersonDeletedEvent event,
    Emitter<PersonState> emit,
  ) async {
    cache.remove<Person>(event.personId);
    emit(PersonDeleted(event.personId));
  }

  Future<void> _onPersonCreated(
    PersonCreatedEvent event,
    Emitter<PersonState> emit,
  ) async {}

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
      emit(
        PersonLoaded(
          cache.getAll<Person>(),
        ),
      );
    } catch (e) {
      emit(PersonError("$e\nFailed to fetch Person for page: ${event.page}"));
    }
  }

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

      final List<int> updatedDebtsOwedIds = _processDebtIds(
        event.replace,
        fetchedDebts,
        person.debtsOwedIds,
      );

      cache.update(person.copyWith(debtsOwedIds: updatedDebtsOwedIds));
      emit(
        DebtsOwedLoaded(
          person,
          fetchedDebts,
        ),
      );
    } catch (e) {
      emit(PersonError("$e\nFailed to fetch debts owed for Person"));
    }
  }

  Future<void> _onGetDebtsReceivable(
    GetPersonDebtsReceivableEvent event,
    Emitter<PersonState> emit,
  ) async {
    emit(PersonLoading());
    try {
      final List<Debt> fetchedDebts = await _getDebtsByDebtorIdUseCase.call(
        event.person.id,
        event.page,
        event.limit,
      );

      Person? person = cache.get<Person>(event.person.id);
      if (person == null) {
        emit(
          PersonError(
            'Person with id ${event.person.id} is not loaded. Debts cannot be fetched.',
          ),
        );
        return;
      }

      fetchedDebts.forEach(cache.addStrong);

      final List<int> updatedDebtsReceivableIds = _processDebtIds(
        event.replace,
        fetchedDebts,
        person.debtsReceivableIds,
      );

      cache.update(person.copyWith(debtsReceivableIds: updatedDebtsReceivableIds));
      emit(
        DebtsReceivableLoaded(
          person,
          fetchedDebts,
        ),
      );
    } catch (e) {
      emit(PersonError("$e\nFailed to fetch debts receivable for Person"));
    }
  }

  List<int> _processDebtIds(
    bool replace,
    List<Debt> newDebts,
    List<int> previousDebtIds,
  ) {
    final debtIds = newDebts.map((e) => e.id).toList(growable: false);
    final mergedList = mergeOrDifferenceLists<int>(
      previousDebtIds,
      debtIds,
      replace,
    );
    if (replace) {
      mergedList.forEach(cache.releaseStrongById<Debt>);
      return debtIds;
    }
    return mergedList;
  }

  Future<List<Person>> getAllLoaded() async {
    return cache.getAll<Person>().values.toList(growable: false);
  }

  Future<void> _onGetPersonById(
    GetPersonByIdEvent event,
    Emitter<PersonState> emit,
  ) async {
    emit(PersonLoading());
    try {
      final person = cache.get<Person>(event.id);
      Person? fetchedPerson;

      if (person != null) {
        cache.addStrong(person);
        fetchedPerson = person;
      } else {
        fetchedPerson = await _getPersonByIdUseCase.call(event.id);
        if (fetchedPerson != null) {
          cache.addStrong(fetchedPerson);
        }
      }

      if (fetchedPerson != null) {
        emit(
          PersonLoaded(
            cache.getAll<Person>(),
          ),
        );
      } else {
        emit(PersonError("Person with ID ${event.id} not found."));
      }
    } catch (e) {
      emit(PersonError("$e\nFailed to get person by ID: ${event.id}"));
    }
  }
}
