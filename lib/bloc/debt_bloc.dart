import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:expensetracker/domain/model/debt.dart';

import 'package:expensetracker/domain/cache.dart';
import 'package:expensetracker/domain/event_bus/event.dart';
import 'package:expensetracker/domain/event_bus/events/debt_event.dart'
    as domain_events;

import 'package:expensetracker/domain/usecase/debt/getters/get_all_debt_usecase.dart';
import 'package:expensetracker/domain/usecase/debt/getters/get_debt_by_id_usecase.dart';
import 'package:expensetracker/domain/usecase/debt/getters/get_debts_by_creditor_id_usecase.dart';
import 'package:expensetracker/domain/usecase/debt/getters/get_debts_by_debtor_id_usecase.dart';
import 'package:expensetracker/domain/usecase/debt/getters/get_page_debt_usecase.dart';

import 'package:expensetracker/domain/usecase/debt/mutations/create_debt_usecase.dart';
import 'package:expensetracker/domain/usecase/debt/mutations/delete_debt_usecase.dart';
import 'package:expensetracker/domain/usecase/debt/mutations/update_debt_usecase.dart';

part 'debt_state.dart';
part 'debt_event.dart';

class DebtBloc extends Bloc<DebtEvent, DebtState> {
  final GetAllDebtUseCase _getAllDebtUseCase;
  final GetDebtByIdUseCase _getDebtByIdUseCase;
  final GetPageDebtUseCase _getPageDebtUseCase;
  final GetDebtsByCreditorIdUseCase _getDebtsByCreditorIdUseCase;
  final GetDebtsByDebtorIdUseCase _getDebtsByDebtorIdUseCase;

  final CreateDebtUseCase _createDebtUseCase;
  final UpdateDebtUseCase _updateDebtUseCase;
  final DeleteDebtUseCase _deleteDebtUseCase;

  final EventBus _eventBus;
  final Cache _cache;

  late StreamSubscription _debtCreatedSubscription;
  late StreamSubscription _debtDeletedSubscription;
  late StreamSubscription _debtUpdatedSubscription;
  late StreamSubscription _unloadDebtSubscription;

  DebtBloc(
    this._getAllDebtUseCase,
    this._getDebtByIdUseCase,
    this._getPageDebtUseCase,
    this._getDebtsByCreditorIdUseCase,
    this._getDebtsByDebtorIdUseCase,
    this._createDebtUseCase,
    this._updateDebtUseCase,
    this._deleteDebtUseCase,
    this._eventBus,
    this._cache,
  ) : super(DebtInitial()) {
    on<LoadAllDebtsEvent>(_onLoadAllDebts);
    on<GetPageDebtEvent>(_onGetPageDebt);
    on<GetDebtsByCreditorIdEvent>(_onGetDebtsByCreditorId);
    on<GetDebtsByDebtorIdEvent>(_onGetDebtsByDebtorId);
    on<UnloadDebtEvent>(_onUnloadDebt);
    on<UnloadDebtsEvent>(_onUnloadDebts);

    on<CreateDebtEvent>(_onCreateDebt);
    on<UpdateDebtEvent>(_onUpdateDebt);
    on<DeleteDebtEvent>(_onDeleteDebt);

    on<DebtCreatedEvent>(_onDebtCreated);
    on<DebtUpdatedEvent>(_onDebtUpdated);
    on<DebtDeletedEvent>(_onDebtDeleted);
    on<GetDebtByIdEvent>(_onGetDebtById); // Add this line

    _debtCreatedSubscription = _eventBus
        .on<domain_events.DebtCreatedEvent>()
        .listen((event) {
          add(DebtCreatedEvent(event.debt));
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
        });

    _unloadDebtSubscription = _eventBus
        .on<domain_events.UnloadDebtEvent>()
        .listen((event) {
          final debt = _cache.get<Debt>(event.debtId);
          if (debt != null) {
            add(UnloadDebtEvent(debt));
          }
        });
  }

  @override
  Future<void> close() {
    _debtCreatedSubscription.cancel();
    _debtDeletedSubscription.cancel();
    _debtUpdatedSubscription.cancel();
    _unloadDebtSubscription.cancel();
    return super.close();
  }

  void _emitLoadedDebts(Emitter<DebtState> emit) {
    emit(DebtLoaded(_cache.getAll<Debt>()));
  }

  Future<void> _onLoadAllDebts(
    LoadAllDebtsEvent event,
    Emitter<DebtState> emit,
  ) async {
    emit(DebtLoading());
    try {
      final allDebts = await _getAllDebtUseCase.call();

      allDebts.forEach(_cache.addStrong);
      _emitLoadedDebts(emit);
    } catch (e) {
      emit(DebtError("$e\nFailed to load all debts"));
    }
  }

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

  Future<void> _onDebtDeleted(
    DebtDeletedEvent event,
    Emitter<DebtState> emit,
  ) async {
    _cache.remove<Debt>(event.debtId);
    _emitLoadedDebts(emit);
  }

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

  Future<void> _onGetPageDebt(
    GetPageDebtEvent event,
    Emitter<DebtState> emit,
  ) async {
    emit(DebtLoading());
    try {
      final debts = await _getPageDebtUseCase.call(event.page, event.limit);
      debts.forEach(_cache.addStrong);
      _emitLoadedDebts(emit);
    } catch (e) {
      emit(DebtError("$e\nFailed to get page of debts"));
    }
  }

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
      debts.forEach(_cache.addStrong);
      _emitLoadedDebts(emit);
    } catch (e) {
      emit(DebtError("$e\nFailed to get debts by creditor ID"));
    }
  }

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
      debts.forEach(_cache.addStrong);
      _emitLoadedDebts(emit);
    } catch (e) {
      emit(DebtError("$e\nFailed to get debts by debtor ID"));
    }
  }

  Future<void> _onUnloadDebt(
    UnloadDebtEvent event,
    Emitter<DebtState> emit,
  ) async {
    _cache.releaseStrong<Debt>(event.debt);
    _emitLoadedDebts(emit);
  }

  Future<void> _onUnloadDebts(
    UnloadDebtsEvent event,
    Emitter<DebtState> emit,
  ) async {
    event.debts.forEach(_cache.releaseStrong<Debt>);
    _emitLoadedDebts(emit);
  }

  Future<void> _onDebtUpdated(
    DebtUpdatedEvent event,
    Emitter<DebtState> emit,
  ) async {
    _cache.update(event.debt);
    _emitLoadedDebts(emit);
  }

  Future<void> _onDebtCreated(
    DebtCreatedEvent event,
    Emitter<DebtState> emit,
  ) async {}

  Future<List<Debt>> getAllLoaded() async {
    return _cache.getAll<Debt>().values.toList(growable: false);
  }

  Future<void> _onGetDebtById(
    GetDebtByIdEvent event,
    Emitter<DebtState> emit,
  ) async {
    emit(DebtLoading());
    try {
      final debt = _cache.get<Debt>(event.id);
      Debt? fetchedDebt;

      if (debt != null) {
        _cache.addStrong(debt);
        fetchedDebt = debt;
      } else {
        fetchedDebt = await _getDebtByIdUseCase.call(event.id);
        if (fetchedDebt != null) {
          _cache.addStrong(fetchedDebt);
        }
      }

      if (fetchedDebt != null) {
        _emitLoadedDebts(emit);
      } else {
        emit(DebtError("Debt with ID ${event.id} not found."));
      }
    } catch (e) {
      emit(DebtError("$e\nFailed to get debt by ID: ${event.id}"));
    }
  }
}
