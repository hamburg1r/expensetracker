import 'package:expensetracker/domain/model/unaccountedmoney.dart';
import 'package:expensetracker/domain/repository/unaccountedmoney.dart';
import 'package:expensetracker/domain/repository/account.dart';
import 'package:expensetracker/domain/event_bus/event.dart';
import 'package:expensetracker/domain/event_bus/events/account_event.dart';

class UpdateUnaccountedMoneyUseCase {
  final UnaccountedMoneyRepo _unaccountedMoneyRepo;
  final EventBus _eventBus;
  final AccountRepo _accountRepo;

  UpdateUnaccountedMoneyUseCase(
    this._unaccountedMoneyRepo,
    this._eventBus,
    this._accountRepo,
  );

  Future<void> call(UnaccountedMoney entry) async {
    await _unaccountedMoneyRepo.update(entry);

    final account = await _accountRepo.getById(entry.accountId);
    if (account == null) {
      throw Exception(
        'Account with ID ${entry.accountId} not found for UnaccountedMoney entry update.',
      );
    }

    final oldEntry = await _unaccountedMoneyRepo.getById(entry.id);
    if (oldEntry == null) {
      throw Exception(
        'Old UnaccountedMoney entry with ID ${entry.id} not found. Cannot update.',
      );
    }

    final amountChange = entry.amount - oldEntry.amount;

    final newTotalMoney = account.totalMoney + amountChange;
    final newTotalUnaccountedMoney =
        account.totalUnaccountedMoney + amountChange;

    final updatedAccount = account.copyWith(
      totalMoney: newTotalMoney,
      totalUnaccountedMoney: newTotalUnaccountedMoney,
    );
    await _accountRepo.update(updatedAccount);
    _eventBus.fire(AccountUpdatedEvent(updatedAccount));
  }
}
