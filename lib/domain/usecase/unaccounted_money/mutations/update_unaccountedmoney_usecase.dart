import 'package:expensetracker/domain/model/unaccountedmoney.dart';
import 'package:expensetracker/domain/repository/unaccountedmoney.dart';
import 'package:expensetracker/domain/repository/account.dart'; // Import AccountRepo
import 'package:expensetracker/domain/event_bus/event.dart';
import 'package:expensetracker/domain/event_bus/events/account_event.dart';

class UpdateUnaccountedMoneyUseCase {
  final UnaccountedMoneyRepo _unaccountedMoneyRepo;
  final EventBus _eventBus;
  final AccountRepo _accountRepo; // Add AccountRepo

  UpdateUnaccountedMoneyUseCase(
    this._unaccountedMoneyRepo,
    this._eventBus,
    this._accountRepo,
  );

  Future<void> call(UnaccountedMoney entry) async {
    await _unaccountedMoneyRepo.update(entry);

    final account = await _accountRepo.getById(entry.account.id);
    if (account == null) {
      throw Exception(
        'Account with ID ${entry.account.id} not found for UnaccountedMoney entry update.',
      );
    }

    final oldEntryIndex = account.unaccountedMoney.indexWhere(
      (e) => e.id == entry.id,
    );

    if (oldEntryIndex == -1) {
      throw Exception(
        'UnaccountedMoney entry with ID ${entry.id} not found in account ${account.id}. Cannot update a non-existent entry.',
      );
    }

    final oldEntry = account.unaccountedMoney[oldEntryIndex];
    final amountChange = entry.amount - oldEntry.amount;

    final updatedUnaccountedMoneyList = List<UnaccountedMoney>.from(
      account.unaccountedMoney,
    );
    updatedUnaccountedMoneyList[oldEntryIndex] = entry;

    final newTotalMoney = account.totalMoney + amountChange;
    final newTotalUnaccountedMoney =
        account.totalUnaccountedMoney + amountChange;

    final updatedAccount = account.copyWith(
      unaccountedMoney: updatedUnaccountedMoneyList,
      totalMoney: newTotalMoney,
      totalUnaccountedMoney: newTotalUnaccountedMoney,
    );
    await _accountRepo.update(updatedAccount);
    _eventBus.fire(AccountDataChangedEvent(updatedAccount));
  }
}
