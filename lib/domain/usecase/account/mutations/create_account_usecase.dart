import 'package:expensetracker/domain/event_bus/event.dart';
import 'package:expensetracker/domain/event_bus/events/account_event.dart';
import 'package:expensetracker/domain/model/account.dart';
import 'package:expensetracker/domain/repository/account.dart';

class CreateAccountUseCase {
  final AccountRepo _accountRepo;
  final EventBus _eventBus;

  CreateAccountUseCase(this._accountRepo, this._eventBus);

  Future<void> call(Account account) async {
    final int id = await _accountRepo.create(account);
    _eventBus.fire(AccountCreatedEvent(account.copyWith(id: id)));
  }
}
