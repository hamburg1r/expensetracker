import 'package:expensetracker/domain/event_bus/event.dart';
import 'package:expensetracker/domain/event_bus/events/account_event.dart';
import 'package:expensetracker/domain/model/account.dart';
import 'package:expensetracker/domain/repository/account.dart';

class UpdateAccountUseCase {
  final AccountRepo _accountRepo;
  final EventBus _eventBus;

  UpdateAccountUseCase(this._accountRepo, this._eventBus);

  Future<void> call(Account account) async {
    await _accountRepo.update(account);
    _eventBus.fire(AccountUpdatedEvent(account));
  }
}
