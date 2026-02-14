import 'package:expensetracker/domain/repository/unaccountedmoney.dart';
import 'package:expensetracker/domain/repository/account.dart'; // Import AccountRepo
import 'package:expensetracker/domain/model/unaccountedmoney.dart'; // Import UnaccountedMoney model
import 'package:expensetracker/domain/event_bus/event_bus.dart';
import 'package:expensetracker/domain/event_bus/domain_event.dart'; // Import AccountDataChangedEvent

class DeleteUnaccountedMoneyUseCase {
  final UnaccountedMoneyRepo _unaccountedMoneyRepo;
  final EventBus _eventBus;
  final AccountRepo _accountRepo; // Add AccountRepo

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
    final account = await _accountRepo.getById(unaccountedMoneyEntry.account.id);
    if (account == null) {
      throw Exception('Account with ID ${unaccountedMoneyEntry.account.id} not found for UnaccountedMoney entry deletion.');
    }

    final updatedUnaccountedMoneyList =
        List<UnaccountedMoney>.from(account.unaccountedMoney)
          ..removeWhere((um) => um.id == id);

    final newTotalUnaccountedMoney = account.totalUnaccountedMoney - unaccountedMoneyEntry.amount;
    final newTotalMoney = account.totalMoney - unaccountedMoneyEntry.amount;

    final updatedAccount = account.copyWith(
      unaccountedMoney: updatedUnaccountedMoneyList,
      totalMoney: newTotalMoney,
      totalUnaccountedMoney: newTotalUnaccountedMoney,
    );
    await _accountRepo.update(updatedAccount);
    _eventBus.fire(AccountDataChangedEvent(updatedAccount));
    }
    return deleted;
  }
}
