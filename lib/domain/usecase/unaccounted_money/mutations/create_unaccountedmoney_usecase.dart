import 'package:expensetracker/domain/event_bus/event.dart';
import 'package:expensetracker/domain/event_bus/events/account_event.dart';
import 'package:expensetracker/domain/repository/account.dart';
import 'package:expensetracker/domain/model/unaccountedmoney.dart';
import 'package:expensetracker/domain/repository/unaccountedmoney.dart';

class CreateUnaccountedMoneyUseCase {
  final UnaccountedMoneyRepo _unaccountedMoneyRepo;
  final EventBus _eventBus;
  final AccountRepo _accountRepo;

  CreateUnaccountedMoneyUseCase(
    this._unaccountedMoneyRepo,
    this._eventBus,
    this._accountRepo,
  );

  Future<int> call(UnaccountedMoney entry) async {
    final id = await _unaccountedMoneyRepo.create(entry);
    // Optionally publish a domain event, e.g., UnaccountedMoneyCreatedEvent
    // _eventBus.fire(UnaccountedMoneyCreatedEvent(id, entry));

    final account = await _accountRepo.getById(entry.accountId);
    if (account == null) {
      throw Exception(
        'Account with ID ${entry.accountId} not found for UnaccountedMoney entry creation.',
      );
    }

    final updatedAccount = account.copyWith(
      unaccountedMoneyIds: [
        ...account.unaccountedMoneyIds,
        id,
      ],
      totalMoney: account.totalMoney + entry.amount,
      totalUnaccountedMoney: account.totalUnaccountedMoney + entry.amount,
    );
    await _accountRepo.update(updatedAccount);
    _eventBus.fire(AccountUpdatedEvent(updatedAccount));

    return id;
  }
}
