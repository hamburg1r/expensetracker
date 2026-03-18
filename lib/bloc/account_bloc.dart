import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:expensetracker/domain/model/account.dart';
import 'package:expensetracker/domain/model/person.dart';

import 'package:expensetracker/domain/cache.dart';
import 'package:expensetracker/domain/event_bus/event.dart';
import 'package:expensetracker/domain/event_bus/events/account_event.dart'
    as domain_events;

import 'package:expensetracker/domain/usecase/account/getters/get_account_by_id_usecase.dart';
import 'package:expensetracker/domain/usecase/account/getters/get_all_accounts_usecase.dart';
import 'package:expensetracker/domain/usecase/account/getters/get_page_accounts_usecase.dart';
import 'package:expensetracker/domain/usecase/account/mutations/create_account_usecase.dart';
import 'package:expensetracker/domain/usecase/account/mutations/delete_account_usecase.dart';
import 'package:expensetracker/domain/usecase/account/mutations/update_account_usecase.dart';

part 'account_event.dart';
part 'account_state.dart';

/// Manages the state and business logic related to [Account] entities within the application.
///
/// This BLoC handles various account-related operations such as loading all accounts,
/// creating, updating, deleting accounts, and fetching accounts based on specific criteria
/// (e.g., by ID, or paginated lists). It interacts with
/// Account-related use cases for data persistence, [Cache] for efficient data retrieval,
/// and [EventBus] for cross-BLoC communication and reacting to domain events.
///
/// It exposes methods for event handling (`_onLoadAllAccounts`, `_onCreateAccount`, etc.).
class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final GetAllAccountsUseCase _getAllAccountsUseCase;
  final GetPageAccountsUseCase _getPageAccountsUseCase;
  final GetAccountByIdUseCase _getAccountByIdUseCase;

  final CreateAccountUseCase _createAccountUseCase;
  final UpdateAccountUseCase _updateAccountUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;

  final Cache _cache;
  final EventBus _eventBus;

  late StreamSubscription _accountCreatedSubscription;
  late StreamSubscription _accountUpdatedSubscription;
  late StreamSubscription _accountDeletedSubscription;

  /// Constructs an [AccountBloc] instance.
  ///
  /// This constructor initializes the BLoC with various use cases, a cache,
  /// and an event bus. It sets the initial state to `AccountInitial` and
  /// configures event handlers for all defined `AccountEvent`s.
  ///
  /// It also sets up subscriptions to `domain_events` from the `EventBus`
  /// to react to external changes in account data (e.g., updates, additions,
  /// deletions originating from other parts of the application or data layer).
  ///
  /// **Dependencies:**
  /// - `_getAllAccountsUseCase`: For fetching all accounts.
  /// - `_createAccountUseCase`: For creating new accounts.
  /// - `_updateAccountUseCase`: For updating existing accounts.
  /// - `_deleteAccountUseCase`: For deleting accounts.
  /// - `_getPageAccountsUseCase`: For fetching accounts by page.
  /// - `_getAccountByIdUseCase`: For fetching a single account by ID.
  /// - `_eventBus`: The domain event bus for cross-BLoC communication.
  /// - `_cache`: The application's caching mechanism for Account objects.
  AccountBloc(
    this._getAllAccountsUseCase,
    this._createAccountUseCase,
    this._updateAccountUseCase,
    this._deleteAccountUseCase,
    this._getPageAccountsUseCase,
    this._getAccountByIdUseCase,
    this._eventBus,
    this._cache,
  ) : super(AccountInitial()) {
    on<LoadAllAccountsEvent>(_onLoadAllAccounts);
    on<GetPageAccountsEvent>(_onGetPageAccounts);
    on<GetAccountByIdEvent>(_onGetAccountById);
    on<UnloadAccountEvent>(_onUnloadAccount);
    on<UnloadAccountsEvent>(_onUnloadAccounts);

    on<CreateAccountEvent>(_onCreateAccount);
    on<UpdateAccountEvent>(_onUpdateAccount);
    on<DeleteAccountEvent>(_onDeleteAccount);

    on<AccountCreatedEvent>(_onAccountCreated);
    on<AccountUpdatedEvent>(_onAccountUpdated);
    on<AccountDeletedEvent>(_onAccountDeleted);

    _accountCreatedSubscription = _eventBus
        .on<domain_events.AccountCreatedEvent>()
        .listen((event) {
          add(AccountCreatedEvent(event.account));
        });

    _accountUpdatedSubscription = _eventBus
        .on<domain_events.AccountUpdatedEvent>()
        .listen((event) {
          add(AccountUpdatedEvent(event.account));
        });

    _accountDeletedSubscription = _eventBus
        .on<domain_events.AccountDeletedEvent>()
        .listen((event) {
          add(AccountDeletedEvent(event.accountId));
        });
  }

  /// Closes the [AccountBloc] and cancels all active `StreamSubscription`s
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
    _accountCreatedSubscription.cancel();
    _accountUpdatedSubscription.cancel();
    _accountDeletedSubscription.cancel();
    return super.close();
  }

  /// Emits an `AccountLoaded` state containing all [Account] objects currently
  /// present in the BLoC's internal cache.
  ///
  /// This helper method is typically called after any operation that modifies
  /// the collection of accounts in the cache (e.g., loading new data, updating
  /// an existing account, or removing an account). It ensures that the UI always
  /// receives the most up-to-date representation of the account list.
  ///
  /// [emit]: The `Emitter<AccountState>` to emit the `AccountLoaded` state.
  void _emitLoadedAccounts(Emitter<AccountState> emit) {
    emit(AccountLoaded(_cache.getAll<Account>()));
  }

  /// Handles the `LoadAllAccountsEvent`.
  ///
  /// This method is responsible for initiating the loading of all [Account]
  /// objects from the persistent data source. It uses the `_getAllAccountsUseCase`
  /// to perform this retrieval.
  ///
  /// **Workflow:**
  /// 1. Emits `AccountLoading()` to signal that data fetching is in progress,
  ///    allowing the UI to display a loading indicator.
  /// 2. Executes the `_getAllAccountsUseCase.call()` to retrieve all accounts.
  /// 3. For each fetched [Account] object, it processes and caches it using
  ///    `_processAndCacheAccount`, ensuring that embedded [Person] objects are
  ///    canonical instances from the BLoC's internal `_cache`.
  /// 4. Calls `_emitLoadedAccounts(emit)` to emit an `AccountLoaded` state,
  ///    providing the complete list of accounts (from cache) to the UI.
  /// 5. Catches any exceptions during the loading process and emits `AccountError()`
  ///    with a descriptive message.
  ///
  /// [event]: The `LoadAllAccountsEvent` that triggers this data loading operation.
  /// [emit]: The `Emitter<AccountState>` used to emit `AccountLoading`, `AccountLoaded`,
  ///         or `AccountError` states.
  Future<void> _onLoadAllAccounts(
    LoadAllAccountsEvent event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading());
    try {
      final allAccounts = await _getAllAccountsUseCase.call();
      allAccounts.forEach(_processAndCacheAccount);
      _emitLoadedAccounts(emit);
    } catch (e) {
      emit(AccountError("$e\nFailed to load all accounts"));
    }
  }

  /// Handles the `GetPageAccountsEvent`.
  ///
  /// This method is responsible for fetching a specific page of [Account]
  /// objects from the persistent data source, typically used for pagination
  /// or lazy loading. It uses the `_getPageAccountsUseCase` to retrieve the data.
  ///
  /// **Workflow:**
  /// 1. Emits `AccountLoading()` to signal that data fetching for the page is in progress.
  /// 2. Calls `_getPageAccountsUseCase.call(event.page, event.limit)` to retrieve
  ///    the specified page of accounts.
  /// 3. For each fetched [Account] object, it processes and caches it using
  ///    `_processAndCacheAccount`, ensuring that embedded [Person] objects are
  ///    canonical instances from the BLoC's internal `_cache`.
  /// 4. Calls `_emitLoadedAccounts(emit)` to emit an `AccountLoaded` state,
  ///    providing the updated list of accounts (from cache) to the UI.
  /// 5. Catches any exceptions during the page fetching process and emits `AccountError()`
  ///    with a descriptive message.
  ///
  /// [event]: The `GetPageAccountsEvent` containing the page number and limit for fetching.
  /// [emit]: The `Emitter<AccountState>` used to emit `AccountLoading`, `AccountLoaded`,
  ///         or `AccountError` states.
  Future<void> _onGetPageAccounts(
    GetPageAccountsEvent event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading());
    try {
      final pageData = await _getPageAccountsUseCase.call(
        event.page,
        event.limit,
      );
      pageData.forEach(_processAndCacheAccount);
      _emitLoadedAccounts(emit);
    } catch (e) {
      emit(AccountError("$e\nFailed to get page of accounts"));
    }
  }

  /// Handles the `CreateAccountEvent`.
  ///
  /// This method is responsible for creating a new [Account] entity in the
  /// persistent data store. It uses the `_createAccountUseCase` to perform
  /// the creation.
  ///
  /// **Workflow:**
  /// 1. Emits `AccountLoading()` to indicate that a creation operation is in progress.
  /// 2. Calls `_createAccountUseCase.call(event.account)` to save the new account
  ///    to the data source.
  /// 3. Catches any exceptions during the creation process and emits `AccountError()`
  ///    with a descriptive message.
  ///
  /// [event]: The `CreateAccountEvent` containing the [Account] object to be created.
  /// [emit]: The `Emitter<AccountState>` used to emit `AccountLoading` or `AccountError` states.
  Future<void> _onCreateAccount(
    CreateAccountEvent event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading());
    try {
      await _createAccountUseCase.call(event.account);
    } catch (e) {
      emit(AccountError("$e\nFailed to create account"));
    }
  }

  /// Handles the `UpdateAccountEvent`.
  ///
  /// This method is responsible for initiating the update of an existing
  /// [Account] entity in the persistent data store. It uses the `_updateAccountUseCase`
  /// to perform this operation.
  ///
  /// **Workflow:**
  /// 1. Emits `AccountLoading()` to indicate that an update operation is in progress.
  /// 2. Calls `_updateAccountUseCase.call(event.account)` to save the updated account
  ///    to the data source.
  /// 3. Catches any exceptions during the update process and emits `AccountError()`
  ///    with a descriptive message.
  ///
  /// [event]: The `UpdateAccountEvent` containing the updated [Account] object.
  /// [emit]: The `Emitter<AccountState>` used to emit `AccountLoading` or `AccountError` states.
  Future<void> _onUpdateAccount(
    UpdateAccountEvent event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading());
    try {
      await _updateAccountUseCase.call(event.account);
    } catch (e) {
      emit(AccountError("$e\nFailed to update account"));
    }
  }

  /// Handles the `DeleteAccountEvent`.
  ///
  /// This method is responsible for initiating the deletion of an [Account]
  /// entity from the persistent data store. It uses the `_deleteAccountUseCase`
  /// to perform this operation.
  ///
  /// **Workflow:**
  /// 1. Emits `AccountLoading()` to indicate that a deletion operation is in progress.
  /// 2. Calls `_deleteAccountUseCase.call(event.account.id)` to remove the account
  ///    from the data source.
  /// 3. Catches any exceptions during the deletion process and emits `AccountError()`
  ///    with a descriptive message.
  ///
  /// [event]: The `DeleteAccountEvent` containing the [Account] object to be deleted.
  /// [emit]: The `Emitter<AccountState>` used to emit `AccountLoading` or `AccountError` states.
  Future<void> _onDeleteAccount(
    DeleteAccountEvent event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading());
    try {
      await _deleteAccountUseCase.call(event.account.id);
    } catch (e) {
      emit(AccountError("$e\nFailed to delete account"));
    }
  }

  /// Handles the `UnloadAccountEvent`.
  ///
  /// This method is responsible for releasing a strong reference to a single
  /// [Account] object in the BLoC's internal `_cache`. This typically means the
  /// UI no longer requires this specific account to maintain a strong reference,
  /// allowing it to be potentially garbage collected if no other strong
  /// references exist.
  ///
  /// **Workflow:**
  /// 1. Calls `_cache.releaseStrong(event.account)` to decrement the strong
  ///    reference count for the specified account in the cache.
  /// 2. Calls `_emitLoadedAccounts(emit)` to emit an `AccountLoaded` state,
  ///    reflecting the potentially changed reference counts or removal if
  ///    references dropped to zero.
  ///
  /// [event]: The `UnloadAccountEvent` containing the [Account] to be unloaded.
  /// [emit]: The `Emitter<AccountState>` used to emit the `AccountLoaded` state.
  Future<void> _onUnloadAccount(
    UnloadAccountEvent event,
    Emitter<AccountState> emit,
  ) async {
    _cache.releaseStrong<Account>(event.account);
    _emitLoadedAccounts(emit);
  }

  /// Handles the `UnloadAccountsEvent`.
  ///
  /// This method is responsible for releasing strong references to a list of
  /// [Account] objects in the BLoC's internal `_cache`. This is useful when a
  /// collection of accounts is no longer actively needed by the UI, allowing
  /// the cache to manage their lifecycle more efficiently.
  ///
  /// **Workflow:**
  /// 1. Iterates through each `account` in `event.accounts`.
  /// 2. For each `account`, it calls `_cache.releaseStrong(account)` to decrement
  ///    its strong reference count in the cache.
  /// 3. After processing all accounts, it calls `_emitLoadedAccounts(emit)` to emit
  ///    an `AccountLoaded` state, updating the UI with the cache's current contents.
  ///
  /// [event]: The `UnloadAccountsEvent` containing the list of [Account] objects
  ///          to be unloaded.
  /// [emit]: The `Emitter<AccountState>` used to emit the `AccountLoaded` state.
  Future<void> _onUnloadAccounts(
    UnloadAccountsEvent event,
    Emitter<AccountState> emit,
  ) async {
    event.accounts.forEach(_cache.releaseStrong<Account>);
    _emitLoadedAccounts(emit);
  }

  /// Handles the `AccountCreatedEvent`.
  ///
  /// This method is a notification handler responsible for reacting to the
  /// creation of a new [Account] in the data layer.
  /// This specific handler currently does not perform any explicit state
  /// changes or cache updates, as the `_processAndCacheAccount` method
  /// is typically called during initial data loading or when an account
  /// is fetched by ID.
  ///
  /// [event]: The `AccountCreatedEvent` containing the newly created [Account] object.
  /// [emit]: The `Emitter<AccountState>` used to emit new states.
  Future<void> _onAccountCreated(
    AccountCreatedEvent event,
    Emitter<AccountState> emit,
  ) async {}

  /// Processes a single [Account] object, ensuring its embedded [Person]
  /// objects (owner) are canonical instances from the cache,
  /// and then adds the processed [Account] to the cache.
  ///
  /// This method first ensures that the `owner` [Person] object
  /// embedded within the provided `account` is a canonical instance managed by the
  /// BLoC's internal `_cache`. This is achieved by:
  ///   - Adding or updating the `Person` object from the account into the `_cache`
  ///     using `_cache.addStrong`.
  ///   - Retrieving the canonical `Person` instance from the `_cache`.
  /// A new [Account] object is then created using `account.copyWith()`, with its
  /// `owner` field referencing this canonical `Person` instance.
  /// This newly constructed [Account] object is then added to the BLoC's internal `_cache`.
  ///
  /// Returns the processed [Account] object with canonical [Person] references.
  Account _processAndCacheAccount(Account account) {
    _cache.addStrong(account.owner);
    final cachedOwner = _cache.get<Person>(account.owner.id)!;

    final accountWithCachedPerson = account.copyWith(
      owner: cachedOwner,
    );
    _cache.addStrong(accountWithCachedPerson);
    return accountWithCachedPerson;
  }

  /// Handles the `AccountUpdatedEvent`.
  ///
  /// This method is a notification handler responsible for updating the BLoC's
  /// internal cache and UI state after an [Account] has been successfully
  /// updated in the persistent data store.
  ///
  /// **Workflow:**
  /// 1. Calls `_cache.update(event.account)` to update the
  ///    specified account in the BLoC's internal cache.
  /// 2. Calls `_emitLoadedAccounts(emit)` to emit an `AccountLoaded` state,
  ///    reflecting the updated list of accounts to the UI.
  ///
  /// [event]: The `AccountUpdatedEvent` containing the updated [Account] object.
  /// [emit]: The `Emitter<AccountState>` used to emit the `AccountLoaded` state.
  Future<void> _onAccountUpdated(
    AccountUpdatedEvent event,
    Emitter<AccountState> emit,
  ) async {
    _cache.update(event.account);
    _emitLoadedAccounts(emit);
  }

  /// Handles the `AccountDeletedEvent`.
  ///
  /// This method is a notification handler responsible for updating the BLoC's
  /// internal cache and UI state after an [Account] has been successfully
  /// deleted from the persistent data store.
  ///
  /// **Workflow:**
  /// 1. Calls `_cache.remove<Account>(event.accountId)` to explicitly remove the
  ///    specified account from the BLoC's internal cache.
  /// 2. Calls `_emitLoadedAccounts(emit)` to emit an `AccountLoaded` state,
  ///    reflecting the updated list of accounts (without the removed one) to the UI.
  ///
  /// [event]: The `AccountDeletedEvent` containing the ID of the [Account] to be removed from the cache.
  /// [emit]: The `Emitter<AccountState>` used to emit the `AccountLoaded` state.
  Future<void> _onAccountDeleted(
    AccountDeletedEvent event,
    Emitter<AccountState> emit,
  ) async {
    _cache.remove<Account>(event.accountId);
    _emitLoadedAccounts(emit);
  }

  /// Handles the `GetAccountByIdEvent`.
  ///
  /// This method retrieves a single [Account] object by its `id`.
  /// It first checks the local cache. If the account is found in the cache,
  /// it is processed and cached again to ensure a strong reference is maintained.
  /// If the account is not in the cache, it attempts to fetch it from the
  /// data source using `_getAccountByIdUseCase`. Upon successful retrieval,
  /// the fetched account is processed and cached using `_processAndCacheAccount`.
  ///
  /// After successfully retrieving and caching the account (or if it was already
  /// in the cache), `_emitLoadedAccounts` is called to update the state.
  /// If the account is not found or an error occurs, an `AccountError` state is emitted.
  ///
  /// [event]: The `GetAccountByIdEvent` containing the ID of the [Account] to retrieve.
  /// [emit]: The `Emitter<AccountState>` used to emit `AccountLoading`, `AccountLoaded`,
  ///         or `AccountError` states.
  Future<void> _onGetAccountById(
    GetAccountByIdEvent event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading());
    try {
      final account = _cache.get<Account>(event.id);
      Account? fetchedAccount;

      if (account != null) {
        fetchedAccount = _processAndCacheAccount(account);
      } else {
        fetchedAccount = await _getAccountByIdUseCase.call(event.id);
        if (fetchedAccount != null) {
          fetchedAccount = _processAndCacheAccount(fetchedAccount);
        }
      }

      if (fetchedAccount != null) {
        _emitLoadedAccounts(emit);
      } else {
        emit(AccountError("Account with ID ${event.id} not found."));
      }
    } catch (e) {
      emit(AccountError("$e\nFailed to get account by ID: ${event.id}"));
    }
  }
}
