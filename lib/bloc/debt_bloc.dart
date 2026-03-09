import 'dart:async';
import 'package:expensetracker/domain/model/person.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expensetracker/domain/model/debt.dart';
import 'package:expensetracker/domain/cache.dart';
import 'package:expensetracker/domain/event_bus/event.dart';
import 'package:expensetracker/domain/event_bus/events/debt_event.dart'
    as domain_events;
import 'package:expensetracker/domain/usecase/debt/mutations/delete_debt_usecase.dart';
import 'package:expensetracker/domain/usecase/debt/mutations/create_debt_usecase.dart';
import 'package:expensetracker/domain/usecase/debt/mutations/update_debt_usecase.dart';
import 'package:expensetracker/domain/usecase/debt/getters/get_page_debt_usecase.dart';
import 'package:expensetracker/domain/usecase/debt/getters/get_debts_by_creditor_id_usecase.dart';
import 'package:expensetracker/domain/usecase/debt/getters/get_debts_by_debtor_id_usecase.dart';
import 'package:expensetracker/domain/usecase/debt/getters/get_all_debt_usecase.dart';
import 'package:expensetracker/domain/usecase/debt/getters/get_debt_by_id_usecase.dart';

part 'debt_state.dart';
part 'debt_event.dart';

/// Manages the state and business logic related to [Debt] entities within the application.
///
/// This BLoC handles various debt-related operations such as loading all debts,
/// creating, updating, deleting debts, and fetching debts based on specific criteria
/// (e.g., by creditor ID, by debtor ID, or paginated lists). It interacts with
/// [DebtRepo] for data persistence, [Cache] for efficient data retrieval,
/// and [EventBus] for cross-BLoC communication and reacting to domain events.
///
/// It exposes methods for event handling (`_onLoadAllDebts`, `_onCreateDebt`, etc.)
/// and utility methods for accessing cached data (`getAllLoaded`, `getById`).
class DebtBloc extends Bloc<DebtEvent, DebtState> {
  final EventBus _eventBus;
  final Cache _cache;
  final DeleteDebtUseCase _deleteDebtUseCase;
  final CreateDebtUseCase _createDebtUseCase;
  final UpdateDebtUseCase _updateDebtUseCase;
  final GetPageDebtUseCase _getPageDebtUseCase;
  final GetDebtsByCreditorIdUseCase _getDebtsByCreditorIdUseCase;
  final GetDebtsByDebtorIdUseCase _getDebtsByDebtorIdUseCase;
  final GetAllDebtUseCase _getAllDebtUseCase;
  final GetDebtByIdUseCase _getDebtByIdUseCase;

  late StreamSubscription _debtCreatedSubscription;
  late StreamSubscription _debtDeletedSubscription;
  late StreamSubscription _debtUpdatedSubscription;

  /// Constructs a [DebtBloc] instance.
  ///
  /// This constructor initializes the BLoC with various use cases, a cache,
  /// and an event bus. It sets the initial state to `DebtInitial` and
  /// configures event handlers for all defined `DebtEvent`s.
  ///
  /// It also sets up subscriptions to `domain_events` from the `EventBus`
  /// to react to external changes in debt data (e.g., updates, additions,
  /// deletions originating from other parts of the application or data layer).
  ///
  /// **Dependencies:**
  /// - `_eventBus`: The domain event bus for cross-BLoC communication.
  /// - `_cache`: The application's caching mechanism for Debt objects.
  /// - `_deleteDebtUseCase`: For deleting debts.
  /// - `_createDebtUseCase`: For creating new debts.
  /// - `_updateDebtUseCase`: For updating existing debts.
  /// - `_getPageDebtUseCase`: For fetching debts by page.
  /// - `_getDebtsByCreditorIdUseCase`: For fetching debts by creditor ID.
  /// - `_getDebtsByDebtorIdUseCase`: For fetching debts by debtor ID.
  /// - `_getAllDebtUseCase`: For fetching all debts.
  /// - `_getDebtByIdUseCase`: For fetching a debt by ID.
  DebtBloc(
    this._eventBus,
    this._cache,
    this._deleteDebtUseCase,
    this._createDebtUseCase,
    this._updateDebtUseCase,
    this._getPageDebtUseCase,
    this._getDebtsByCreditorIdUseCase,
    this._getDebtsByDebtorIdUseCase,
    this._getAllDebtUseCase,
    this._getDebtByIdUseCase,
  ) : super(DebtInitial()) {
    on<LoadAllDebtsEvent>(_onLoadAllDebts);
    on<CreateDebtEvent>(_onCreateDebt);
    on<DeleteDebtEvent>(_onDeleteDebt);
    on<DebtDeletedEvent>(_onDebtDeleted);
    on<UpdateDebtEvent>(_onUpdateDebt);
    on<GetPageDebtEvent>(_onGetPageDebt);
    on<GetDebtsByCreditorIdEvent>(_onGetDebtsByCreditorId);
    on<GetDebtsByDebtorIdEvent>(_onGetDebtsByDebtorId);
    on<UnloadDebtEvent>(_onUnloadDebt);
    on<UnloadDebtsEvent>(_onUnloadDebts);
    on<DebtUpdatedEvent>(_onDebtUpdated);

    _debtCreatedSubscription = _eventBus
        .on<domain_events.DebtCreatedEvent>()
        .listen((event) {
          // _cache.addStrong(event.debt);
          // No emit or add event here, similar to PersonBloc's PersonCreatedEvent handling.
        });

    _debtDeletedSubscription = _eventBus
        .on<domain_events.DebtDeletedEvent>()
        .listen((event) {
          add(DebtDeletedEvent(event.debtId));
        });

    _debtUpdatedSubscription = _eventBus
        .on<domain_events.DebtUpdatedEvent>()
        .listen((event) {
          add(DebtUpdatedEvent(event.debt));
          // _cache.addStrong(event.debt);
          // No emit or add event here, similar to PersonBloc's PersonUpdatedEvent handling.
        });
  }

  /// Closes the [DebtBloc] and cancels all active `StreamSubscription`s
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
    _debtCreatedSubscription.cancel();
    _debtDeletedSubscription.cancel();
    _debtUpdatedSubscription.cancel();
    return super.close();
  }

  /// Emits a `DebtLoaded` state containing all [Debt] objects currently
  /// present in the BLoC's internal cache.
  ///
  /// This helper method is typically called after any operation that modifies
  /// the collection of debts in the cache (e.g., loading new data, updating
  /// an existing debt, or removing a debt). It ensures that the UI always
  /// receives the most up-to-date representation of the debt list.
  ///
  /// [emit]: The `Emitter<DebtState>` to emit the `DebtLoaded` state.
  void _emitLoadedDebts(Emitter<DebtState> emit) {
    emit(DebtLoaded(_cache.getAll<Debt>()));
  }

  /// Handles the `LoadAllDebtsEvent`.
  ///
  /// This method is responsible for initiating the loading of all [Debt]
  /// objects from the persistent data source. It uses the `_getAllDebtUseCase`
  /// to perform this retrieval.
  ///
  /// **Workflow:**
  /// 1. Emits `DebtLoading()` to signal that data fetching is in progress,
  ///    allowing the UI to display a loading indicator.
  /// 2. Executes the `_getAllDebtUseCase.call()` to retrieve all debts.
  /// 3. For each fetched [Debt] object, it performs a deep caching process:
  ///    a. It first ensures that the `debtor` and `creditor` [Person] objects
  ///       embedded within the debt are canonical instances managed by the
  ///       BLoC's internal `_cache`. This is achieved by:
  ///       - Adding or updating the `Person` objects from the debt into the `_cache`
  ///         using `_cache.addStrong`.
  ///       - Retrieving the canonical `Person` instances from the `_cache`.
  ///    b. A new [Debt] object is then created using `debt.copyWith()` with its
  ///       `creditor` and `debtor` fields referencing these canonical `Person` instances.
  ///    c. This newly constructed [Debt] object (which now holds references to
  ///       the canonical `Person` objects) is added to the BLoC's internal `_cache`
  ///       using `_cache.addStrong`, establishing a strong reference.
  /// 4. Calls `_emitLoadedDebts(emit)` to emit a `DebtLoaded` state,
  ///    providing the complete list of debts (from cache) to the UI.
  /// 5. Catches any exceptions during the loading process and emits `DebtError()`
  ///    with a descriptive message.
  ///
  /// [event]: The `LoadAllDebtsEvent` that triggers this data loading operation.
  /// [emit]: The `Emitter<DebtState>` used to emit `DebtLoading`, `DebtLoaded`,
  ///         or `DebtError` states.
  Future<void> _onLoadAllDebts(
    LoadAllDebtsEvent event,
    Emitter<DebtState> emit,
  ) async {
    emit(DebtLoading());
    try {
      final allDebts = await _getAllDebtUseCase.call();

      for (var debt in allDebts) {
        _processAndCacheDebt(debt);
      }
      _emitLoadedDebts(emit);
    } catch (e) {
      emit(DebtError("$e\nFailed to load all debts"));
    }
  }

  /// Handles the `CreateDebtEvent`.
  ///
  /// This method is responsible for creating a new [Debt] entity in the
  /// persistent data store. It uses the `_createDebtUseCase` to perform
  /// the creation.
  ///
  /// **Workflow:**
  /// 1. Emits `DebtLoading()` to indicate that a creation operation is in progress.
  /// 2. Calls `_createDebtUseCase.call(event.debt)` to save the new debt
  ///    to the data source.
  /// 3. Catches any exceptions during the creation process and emits `DebtError()`
  ///    with a descriptive message.
  ///
  /// [event]: The `CreateDebtEvent` containing the [Debt] object to be created.
  /// [emit]: The `Emitter<DebtState>` used to emit `DebtLoading` or `DebtError` states.
  Future<void> _onCreateDebt(
    CreateDebtEvent event,
    Emitter<DebtState> emit,
  ) async {
    emit(DebtLoading());
    try {
      await _createDebtUseCase.call(event.debt);
    } catch (e) {
      emit(DebtError("$e\nFailed to create debt"));
    }
  }

  /// Handles the `DeleteDebtEvent`.
  ///
  /// This method is responsible for initiating the deletion of a [Debt]
  /// entity from the persistent data store. It uses the `_deleteDebtUseCase`
  /// to perform this operation.
  ///
  /// **Workflow:**
  /// 1. Emits `DebtLoading()` to indicate that a deletion operation is in progress.
  /// 2. Calls `_deleteDebtUseCase.call(event.debt.id)` to remove the debt
  ///    from the data source.
  /// 3. Catches any exceptions during the deletion process and emits `DebtError()`
  ///    with a descriptive message.
  ///
  /// [event]: The `DeleteDebtEvent` containing the [Debt] object to be deleted.
  /// [emit]: The `Emitter<DebtState>` used to emit `DebtLoading` or `DebtError` states.
  Future<void> _onDeleteDebt(
    DeleteDebtEvent event,
    Emitter<DebtState> emit,
  ) async {
    emit(DebtLoading());
    try {
      await _deleteDebtUseCase.call(event.debt.id);
    } catch (e) {
      emit(DebtError("$e\nFailed to delete debt"));
    }
  }

  /// Handles the `DebtDeletedEvent`.
  ///
  /// This method is a notification handler responsible for updating the BLoC's
  /// internal cache and UI state after a [Debt] has been successfully
  /// deleted from the persistent data store (or is intended to be removed
  /// from the cache for other reasons).
  ///
  /// **Workflow:**
  /// 1. Calls `_cache.remove<Debt>(event.debtId)` to explicitly remove the
  ///    specified debt from the BLoC's internal cache.
  /// 2. Calls `_emitLoadedDebts(emit)` to emit a `DebtLoaded` state,
  ///    reflecting the updated list of debts (without the removed one) to the UI.
  ///
  /// [event]: The `DebtDeletedEvent` containing the ID of the [Debt] to be removed from the cache.
  /// [emit]: The `Emitter<DebtState>` used to emit the `DebtLoaded` state.
  Future<void> _onDebtDeleted(
    DebtDeletedEvent event,
    Emitter<DebtState> emit,
  ) async {
    _cache.remove<Debt>(event.debtId);
    _emitLoadedDebts(emit);
  }

  /// Handles the `UpdateDebtEvent`.
  ///
  /// This method is responsible for initiating the update of an existing
  /// [Debt] entity in the persistent data store. It uses the `_updateDebtUseCase`
  /// to perform this operation.
  ///
  /// **Workflow:**
  /// 1. Emits `DebtLoading()` to indicate that an update operation is in progress.
  /// 2. Calls `_updateDebtUseCase.execute(event.debt)` to save the updated debt
  ///    to the data source.
  /// 3. Catches any exceptions during the update process and emits `DebtError()`
  ///    with a descriptive message.
  ///
  /// [event]: The `UpdateDebtEvent` containing the updated [Debt] object.
  /// [emit]: The `Emitter<DebtState>` used to emit `DebtLoading` or `DebtError` states.
  Future<void> _onUpdateDebt(
    UpdateDebtEvent event,
    Emitter<DebtState> emit,
  ) async {
    emit(DebtLoading());
    try {
      await _updateDebtUseCase.call(event.debt);
    } catch (e) {
      emit(DebtError("$e\nFailed to update debt"));
    }
  }

  /// Handles the `GetPageDebtEvent`.
  ///
  /// This method is responsible for fetching a specific page of [Debt]
  /// objects from the persistent data source, typically used for pagination
  /// or lazy loading. It uses the `_getPageDebtUseCase` to retrieve the data.
  ///
  /// **Workflow:**
  /// 1. Emits `DebtLoading()` to signal that data fetching for the page is in progress.
  /// 2. Calls `_getPageDebtUseCase.call(event.page, event.limit)` to retrieve
  ///    the specified page of debts.
  /// 3. For each fetched [Debt] object, it processes and caches it using
  ///    `_processAndCacheDebt`, ensuring that embedded [Person] objects are
  ///    canonical instances from the BLoC's internal `_cache`.
  /// 4. Calls `_emitLoadedDebts(emit)` to emit a `DebtLoaded` state,
  ///    providing the updated list of debts (from cache) to the UI.
  /// 5. Catches any exceptions during the page fetching process and emits `DebtError()`
  ///    with a descriptive message.
  ///
  /// [event]: The `GetPageDebtEvent` containing the page number and limit for fetching.
  /// [emit]: The `Emitter<DebtState>` used to emit `DebtLoading`, `DebtLoaded`,
  ///         or `DebtError` states.
  Future<void> _onGetPageDebt(
    GetPageDebtEvent event,
    Emitter<DebtState> emit,
  ) async {
    emit(DebtLoading());
    try {
      final debts = await _getPageDebtUseCase.call(event.page, event.limit);
      for (var debt in debts) {
        _processAndCacheDebt(debt);
      }
      _emitLoadedDebts(emit);
    } catch (e) {
      emit(DebtError("$e\nFailed to get page of debts"));
    }
  }

  /// Handles the `GetDebtsByCreditorIdEvent`.
  ///
  /// This method is responsible for fetching a list of [Debt] objects
  /// where a specific person is the creditor. It uses the `_getDebtsByCreditorIdUseCase`
  /// to perform this retrieval.
  ///
  /// **Workflow:**
  /// 1. Emits `DebtLoading()` to signal that data fetching is in progress.
  /// 2. Calls `_getDebtsByCreditorIdUseCase.call(event.creditorId, event.page, event.limit)`
  ///    to retrieve the debts.
  /// 3. For each fetched [Debt] object, it processes and caches it using
  ///    `_processAndCacheDebt`, ensuring that embedded [Person] objects are
  ///    canonical instances from the BLoC's internal `_cache`.
  /// 4. Calls `_emitLoadedDebts(emit)` to emit a `DebtLoaded` state.
  /// 5. Catches any exceptions and emits `DebtError()`.
  ///
  /// [event]: The `GetDebtsByCreditorIdEvent` containing the creditor's ID, page, and limit.
  /// [emit]: The `Emitter<DebtState>` used to emit states.
  Future<void> _onGetDebtsByCreditorId(
    GetDebtsByCreditorIdEvent event,
    Emitter<DebtState> emit,
  ) async {
    emit(DebtLoading());
    try {
      final debts = await _getDebtsByCreditorIdUseCase.call(
        event.creditorId,
        event.page,
        event.limit,
      );
      for (var debt in debts) {
        _processAndCacheDebt(debt);
      }
      _emitLoadedDebts(emit);
    } catch (e) {
      emit(DebtError("$e\nFailed to get debts by creditor ID"));
    }
  }

  /// Handles the `GetDebtsByDebtorIdEvent`.
  ///
  /// This method is responsible for fetching a list of [Debt] objects
  /// where a specific person is the debtor. It uses the `_getDebtsByDebtorIdUseCase`
  /// to perform this retrieval.
  ///
  /// **Workflow:**
  /// 1. Emits `DebtLoading()` to signal that data fetching is in progress.
  /// 2. Calls `_getDebtsByDebtorIdUseCase.call(event.debtorId, event.page, event.limit)`
  ///    to retrieve the debts.
  /// 3. For each fetched [Debt] object, it processes and caches it using
  ///    `_processAndCacheDebt`, ensuring that embedded [Person] objects are
  ///    canonical instances from the BLoC's internal `_cache`.
  /// 4. Calls `_emitLoadedDebts(emit)` to emit a `DebtLoaded` state.
  /// 5. Catches any exceptions and emits `DebtError()`.
  ///
  /// [event]: The `GetDebtsByDebtorIdEvent` containing the debtor's ID, page, and limit.
  /// [emit]: The `Emitter<DebtState>` used to emit states.
  Future<void> _onGetDebtsByDebtorId(
    GetDebtsByDebtorIdEvent event,
    Emitter<DebtState> emit,
  ) async {
    emit(DebtLoading());
    try {
      final debts = await _getDebtsByDebtorIdUseCase.call(
        event.debtorId,
        event.page,
        event.limit,
      );
      for (var debt in debts) {
        _processAndCacheDebt(debt);
      }
      _emitLoadedDebts(emit);
    } catch (e) {
      emit(DebtError("$e\nFailed to get debts by debtor ID"));
    }
  }

  /// Handles the `UnloadDebtEvent`.
  ///
  /// This method is responsible for releasing a strong reference to a single
  /// [Debt] object in the BLoC's internal cache.
  ///
  /// **Workflow:**
  /// 1. Calls `_cache.releaseStrong(event.debt)` to decrement the strong
  ///    reference count for the specified debt in the cache.
  /// 2. Calls `_emitLoadedDebts(emit)` to emit a `DebtLoaded` state,
  ///    reflecting the potentially changed reference counts or removal if
  ///    references dropped to zero.
  ///
  /// [event]: The `UnloadDebtEvent` containing the [Debt] to be unloaded.
  /// [emit]: The `Emitter<DebtState>` used to emit the `DebtLoaded` state.
  Future<void> _onUnloadDebt(
    UnloadDebtEvent event,
    Emitter<DebtState> emit,
  ) async {
    _cache.releaseStrong<Debt>(event.debt);
    _emitLoadedDebts(emit);
  }

  /// Handles the `UnloadDebtsEvent`.
  ///
  /// This method is responsible for releasing strong references to a list of
  /// [Debt] objects in the BLoC's internal cache.
  ///
  /// **Workflow:**
  /// 1. Iterates through each `debt` in `event.debts`.
  /// 2. For each `debt`, it calls `_cache.releaseStrong(debt)` to decrement
  ///    its strong reference count in the cache.
  /// 3. After processing all debts, it calls `_emitLoadedDebts(emit)` to emit
  ///    a `DebtLoaded` state, updating the UI with the cache's current contents.
  ///
  /// [event]: The `UnloadDebtsEvent` containing the list of [Debt] objects
  ///          to be unloaded.
  /// [emit]: The `Emitter<DebtState>` used to emit the `DebtLoaded` state.
  Future<void> _onUnloadDebts(
    UnloadDebtsEvent event,
    Emitter<DebtState> emit,
  ) async {
    event.debts.forEach(_cache.releaseStrong<Debt>);
    _emitLoadedDebts(emit);
  }

  /// Handles the `DebtUpdatedEvent`.
  ///
  /// This method is a notification handler responsible for updating the BLoC's
  /// internal cache and UI state after a [Debt] has been successfully
  /// updated in the persistent data store.
  ///
  /// **Workflow:**
  /// 1. Calls `_cache.addStrong(event.debt)` to add or update the
  ///    specified debt in the BLoC's internal cache.
  /// 2. Calls `_emitLoadedDebts(emit)` to emit a `DebtLoaded` state,
  ///    reflecting the updated list of debts to the UI.
  ///
  /// [event]: The `DebtUpdatedEvent` containing the updated [Debt] object.
  /// [emit]: The `Emitter<DebtState>` used to emit the `DebtLoaded` state.
  Future<void> _onDebtUpdated(
    DebtUpdatedEvent event,
    Emitter<DebtState> emit,
  ) async {
    _cache.update(event.debt);
    _emitLoadedDebts(emit);
  }

  /// Retrieves all [Debt] objects that are currently loaded and managed
  /// by the BLoC's internal cache.
  ///
  /// This method provides direct access to the BLoC's local state without
  /// triggering any events or state changes. It is useful for components that
  /// need to quickly access the current set of loaded debts.
  ///
  /// Returns a `Future<List<Debt>>` containing all debts from the cache.
  Future<List<Debt>> getAllLoaded() async {
    return _cache.getAll<Debt>().values.toList(growable: false);
  }

  /// Processes a single [Debt] object, ensuring its embedded [Person]
  /// objects (debtor and creditor) are canonical instances from the cache,
  /// and then adds the processed [Debt] to the cache.
  ///
  /// This method first ensures that the `debtor` and `creditor` [Person] objects
  /// embedded within the provided `debt` are canonical instances managed by the
  /// BLoC's internal `_cache`. This is achieved by:
  ///   - Adding or updating the `Person` objects from the debt into the `_cache`
  ///     using `_cache.addStrong`.
  ///   - Retrieving the canonical `Person` instances from the `_cache`.
  /// A new [Debt] object is then created using `debt.copyWith()`, with its
  /// `creditor` and `debtor` fields referencing these canonical `Person` instances.
  /// This newly constructed [Debt] object is then added to the BLoC's internal `_cache`.
  ///
  /// Returns the processed [Debt] object with canonical [Person] references.
  Debt _processAndCacheDebt(Debt debt) {
    _cache.addStrong(debt.creditor);
    final cachedCreditor = _cache.get<Person>(debt.creditor.id)!;

    _cache.addStrong(debt.debtor);
    final cachedDebtor = _cache.get<Person>(debt.debtor.id)!;

    final debtWithCachedPeople = debt.copyWith(
      creditor: cachedCreditor,
      debtor: cachedDebtor,
    );
    _cache.addStrong(debtWithCachedPeople); // Cache the processed debt itself
    return debtWithCachedPeople;
  }

  /// Retrieves a single [Debt] object by its `id` from the BLoC's internal
  /// cache, falling back to the persistent data source if not found in cache.
  ///
  /// This method first checks the local cache for the debt. If the debt
  /// is found in the cache, it can optionally add a strong reference if `strong`
  /// is true and no strong references exist.
  /// If the debt is not in the cache, it attempts to fetch it from the data
  /// source using `_getDebtByIdUseCase`. Upon successful retrieval:
  ///   - If `strong` is `true`, the `fetchedDebt` is processed by
  ///     `_processAndCacheDebt` (which canonicalizes embedded [Person] objects
  ///     and adds the processed debt to the cache with a strong reference).
  ///   - If `strong` is `false`, the `fetchedDebt` is returned directly without
  ///     being processed by `_processAndCacheDebt` or added to the cache with
  ///     a strong reference. This means embedded [Person] objects might not
  ///     be canonicalized and the Debt object itself might not be managed
  ///     by the cache.
  ///
  /// **Parameters:**
  /// - `id`: The unique identifier of the [Debt] to retrieve.
  /// - `strong`: Optional. If `true`, ensures a strong reference to the debt
  ///   in the cache if it's already there but only has weak references, and also
  ///   ensures a strong reference for newly fetched debts after canonicalization.
  ///   If `false`, a strong reference is not explicitly ensured for either cached
  ///   or newly fetched debts. Defaults to `true`.
  ///
  /// Returns a `Future<Debt?>`, which resolves to the [Debt] object if found,
  /// or `null` if not found or an error occurs during retrieval.
  Future<Debt?> getById(int id, [bool strong = true]) async {
    final debt = _cache.get<Debt>(id);
    if (debt != null) {
      if (strong && _cache.references(debt) <= 0) _cache.addStrong(debt);
      return debt;
    }

    try {
      final fetchedDebt = await _getDebtByIdUseCase.call(id);
      if (fetchedDebt == null) {
        return null;
      }
      if (strong) return _processAndCacheDebt(fetchedDebt);
      return fetchedDebt;
    } catch (e) {
      return null;
    }
  }
}
