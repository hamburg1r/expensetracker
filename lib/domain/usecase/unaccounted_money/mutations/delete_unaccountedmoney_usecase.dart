import 'package:expensetracker/domain/repository/unaccountedmoney.dart';
import 'package:expensetracker/domain/repository/account.dart';

import 'package:expensetracker/domain/event_bus/event.dart';
import 'package:expensetracker/domain/event_bus/events/account_event.dart';

class DeleteUnaccountedMoneyUseCase {
  final UnaccountedMoneyRepo _unaccountedMoneyRepo;
  final EventBus _eventBus;
  final AccountRepo _accountRepo;

  DeleteUnaccountedMoneyUseCase(
    this._unaccountedMoneyRepo,
    this._eventBus,
    this._accountRepo,
  );

  Future<bool> call(int id) async {
    final unaccountedMoneyEntry = await _unaccountedMoneyRepo.getById(id);
    if (unaccountedMoneyEntry == null) {
      throw Exception(
        'UnaccountedMoney entry with ID $id not found. Cannot delete a non-existent entry.',
      );
    }

    final deleted = await _unaccountedMoneyRepo.delete(id);
    if (deleted) {
      final account = await _accountRepo.getById(
        unaccountedMoneyEntry.accountId,
      );
      if (account == null) {
        throw Exception(
          'Account with ID ${unaccountedMoneyEntry.accountId} not found for UnaccountedMoney entry deletion.',
        );
      }

      final updatedUnaccountedMoneyIds = account.unaccountedMoneyIds
        ..removeWhere((uId) => uId == id);

      final newTotalUnaccountedMoney =
          account.totalUnaccountedMoney - unaccountedMoneyEntry.amount;
      final newTotalMoney = account.totalMoney - unaccountedMoneyEntry.amount;

      final updatedAccount = account.copyWith(
        unaccountedMoneyIds: updatedUnaccountedMoneyIds,
        totalMoney: newTotalMoney,
        totalUnaccountedMoney: newTotalUnaccountedMoney,
      );
      await _accountRepo.update(updatedAccount);
      _eventBus.fire(AccountUpdatedEvent(updatedAccount));
    }
    return deleted;
  }
}
