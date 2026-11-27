import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:expensetracker/domain/model/debt.dart';
import 'package:expensetracker/domain/model/person.dart';
import 'package:expensetracker/domain/usecase/expense/mutations/add_participation_to_expense_usecase.dart';
import 'package:expensetracker/domain/usecase/expense/mutations/remove_participation_from_expense_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:expensetracker/domain/model/expense.dart';

import 'package:expensetracker/domain/cache.dart';
import 'package:expensetracker/domain/event_bus/event.dart';
import 'package:expensetracker/domain/event_bus/events/expense_event.dart'
    as domain_events;

import 'package:expensetracker/domain/usecase/expense/getters/get_all_expenses_usecase.dart';
import 'package:expensetracker/domain/usecase/expense/getters/get_page_expenses_usecase.dart';
import 'package:expensetracker/domain/usecase/expense/getters/get_expense_by_id_usecase.dart';

import 'package:expensetracker/domain/usecase/expense/mutations/create_expense_usecase.dart';
import 'package:expensetracker/domain/usecase/expense/mutations/delete_expense_usecase.dart';
import 'package:expensetracker/domain/usecase/expense/mutations/update_expense_usecase.dart';
import 'package:expensetracker/domain/usecase/expense/mutations/add_debt_to_expense_usecase.dart';
import 'package:expensetracker/domain/usecase/expense/mutations/remove_debt_from_expense_usecase.dart';

part 'expense_event.dart';
part 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final GetAllExpensesUseCase _getAllExpensesUseCase;
  final GetPageExpensesUseCase _getPageExpensesUseCase;
  final GetExpenseByIdUseCase _getExpenseByIdUseCase;

  final CreateExpenseUseCase _createExpenseUseCase;
  final UpdateExpenseUseCase _updateExpenseUseCase;
  final DeleteExpenseUseCase _deleteExpenseUseCase;
  final AddDebtToExpenseUseCase _addDebtToExpenseUseCase;
  final RemoveDebtFromExpenseUseCase _removeDebtFromExpenseUseCase;
  final AddParticipationToExpenseUseCase _addParticipationToExpenseUseCase;
  final RemoveParticipationFromExpenseUseCase
  _removeParticipationFromExpenseUseCase;

  final Cache cache;
  final EventBus _eventBus;

  late StreamSubscription _expenseUpdatedSubscription;
  late StreamSubscription _expenseAddedSubscription;
  late StreamSubscription _expenseDeletedSubscription;
  late StreamSubscription _unloadExpenseSubscription;

  ExpenseBloc(
    this._getAllExpensesUseCase,
    this._getPageExpensesUseCase,
    this._getExpenseByIdUseCase,
    this._createExpenseUseCase,
    this._updateExpenseUseCase,
    this._deleteExpenseUseCase,
    this._addDebtToExpenseUseCase,
    this._removeDebtFromExpenseUseCase,
    this._addParticipationToExpenseUseCase,
    this._removeParticipationFromExpenseUseCase,
    this.cache,
    this._eventBus,
  ) : super(ExpenseInitial()) {
    on<LoadAllExpensesEvent>(_onLoadAllExpenses);
    on<GetPageExpensesEvent>(_onGetPageExpenses);
    on<UnloadExpenseEvent>(_onUnloadExpense);
    on<UnloadExpensesEvent>(_onUnloadExpenses);

    on<CreateExpenseEvent>(_onCreateExpense);
    on<UpdateExpenseEvent>(_onUpdateExpense);
    on<DeleteExpenseEvent>(_onDeleteExpense);
    on<AddDebtToExpenseEvent>(_onAddDebtToExpense);
    on<RemoveDebtFromExpenseEvent>(_onRemoveDebtFromExpense);
    on<AddParticipationToExpenseEvent>(_onAddParticipationToExpense);
    on<RemoveParticipationFromExpenseEvent>(_onRemoveParticipationFromExpense);

    on<ExpenseCreatedEvent>(_onExpenseCreated);
    on<ExpenseUpdatedEvent>(_onExpenseUpdated);
    on<ExpenseDeletedEvent>(_onExpenseDeleted);
    on<GetExpenseByIdEvent>(_onGetExpenseById);

    _expenseUpdatedSubscription = _eventBus
        .on<domain_events.ExpenseUpdatedEvent>()
        .listen((event) {
          add(ExpenseUpdatedEvent(event.expense));
        });

    _expenseAddedSubscription = _eventBus
        .on<domain_events.ExpenseCreatedEvent>()
        .listen((event) {
          add(ExpenseCreatedEvent(event.expense));
        });

    _expenseDeletedSubscription = _eventBus
        .on<domain_events.ExpenseDeletedEvent>()
        .listen((event) {
          add(ExpenseDeletedEvent(event.expenseId));
        });

    _unloadExpenseSubscription = _eventBus
        .on<domain_events.UnloadExpenseEvent>()
        .listen((event) {
          final expense = cache.get<Expense>(event.expenseId);
          if (expense != null) {
            add(UnloadExpenseEvent(expense));
          }
        });
  }

  @override
  Future<void> close() {
    _expenseUpdatedSubscription.cancel();
    _expenseAddedSubscription.cancel();
    _expenseDeletedSubscription.cancel();
    _unloadExpenseSubscription.cancel();
    return super.close();
  }

  Future<void> _onExpenseUpdated(
    ExpenseUpdatedEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    cache.update(event.expense);
    emit(ExpenseUpdated(event.expense));
  }

  Future<void> _onLoadAllExpenses(
    LoadAllExpensesEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseLoading());
    try {
      final List<Expense> all = await _getAllExpensesUseCase.call();
      all.forEach(cache.addStrong);
      emit(ExpenseLoaded(cache.getAll<Expense>()));
    } catch (e) {
      emit(ExpenseError("$e\nFailed to load"));
    }
  }

  Future<void> _onUnloadExpense(
    UnloadExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    cache.releaseStrong<Expense>(event.expense);
    emit(ExpenseLoaded(cache.getAll<Expense>()));
  }

  Future<void> _onUnloadExpenses(
    UnloadExpensesEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    for (var expense in event.expenses) {
      cache.releaseStrong<Expense>(expense);
    }
    emit(ExpenseLoaded(cache.getAll<Expense>()));
  }

  Future<void> _onCreateExpense(
    CreateExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseLoading());
    try {
      await _createExpenseUseCase.call(event.expense);
    } catch (e) {
      emit(ExpenseError("$e\nFailed to create Expense"));
    }
  }

  Future<void> _onDeleteExpense(
    DeleteExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseLoading());
    try {
      await _deleteExpenseUseCase.call(event.expense.id);
    } catch (e) {
      emit(ExpenseError("$e\nFailed to remove Expense"));
    }
  }

  Future<void> _onExpenseDeleted(
    ExpenseDeletedEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    cache.remove<Expense>(event.expenseId);
    emit(ExpenseDeleted(event.expenseId));
  }

  Future<void> _onExpenseCreated(
    ExpenseCreatedEvent event,
    Emitter<ExpenseState> emit,
  ) async {}

  Future<void> _onUpdateExpense(
    UpdateExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseLoading());
    try {
      await _updateExpenseUseCase.call(event.expense);
    } catch (e) {
      emit(ExpenseError("$e\nFailed to update Expense"));
    }
  }

  Future<void> _onGetPageExpenses(
    GetPageExpensesEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseLoading());
    try {
      final List<Expense> pageData = await _getPageExpensesUseCase.call(
        event.page,
        event.limit,
      );
      pageData.forEach(cache.addStrong);
      emit(ExpenseLoaded(cache.getAll<Expense>()));
    } catch (e) {
      emit(ExpenseError("$e\nFailed to fetch Expense for page: ${event.page}"));
    }
  }

  Future<List<Expense>> getAllLoaded() async {
    return cache.getAll<Expense>().values.toList(growable: false);
  }

  Future<void> _onGetExpenseById(
    GetExpenseByIdEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseLoading());
    try {
      final expense =
          cache.get<Expense>(event.id) ??
          await _getExpenseByIdUseCase.call(event.id);

      if (expense == null) {
        emit(ExpenseError("Expense with ID ${event.id} not found."));
        return;
      }
      cache.addStrong(expense);

      emit(ExpenseLoaded(cache.getAll<Expense>()));
    } catch (e) {
      emit(ExpenseError("$e\nFailed to get expense by ID: ${event.id}"));
    }
  }

  Future<void> _onAddDebtToExpense(
    AddDebtToExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseLoading());
    try {
      await _addDebtToExpenseUseCase.call(event.expense, event.debt);
    } catch (e) {
      emit(ExpenseError("$e\nFailed to add debt to Expense"));
    }
  }

  Future<void> _onRemoveDebtFromExpense(
    RemoveDebtFromExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseLoading());
    try {
      await _removeDebtFromExpenseUseCase.call(event.expense, event.debt);
    } catch (e) {
      emit(ExpenseError("$e\nFailed to remove debt from Expense"));
    }
  }

  Future<void> _onAddParticipationToExpense(
    AddParticipationToExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseLoading());
    try {
      await _addParticipationToExpenseUseCase.call(event.expense, event.person);
    } catch (e) {
      emit(ExpenseError("$e\nFailed to add participation to Expense"));
    }
  }

  Future<void> _onRemoveParticipationFromExpense(
    RemoveParticipationFromExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseLoading());
    try {
      await _removeParticipationFromExpenseUseCase.call(
        event.expense,
        event.person,
      );
    } catch (e) {
      emit(ExpenseError("$e\nFailed to remove participation from Expense"));
    }
  }
}
