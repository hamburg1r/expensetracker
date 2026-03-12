import 'package:expensetracker/domain/event_bus/event.dart';
import 'package:expensetracker/domain/event_bus/events/account_event.dart';
import 'package:expensetracker/domain/repository/account.dart';

class DeleteAccountUseCase {
  final AccountRepo _accountRepo;
  final EventBus _eventBus;

  DeleteAccountUseCase(
    this._accountRepo,
    this._eventBus,
  );

  Future<void> call(int id) async {
    final deleted = await _accountRepo.delete(id);
    if (deleted) {
      _eventBus.fire(AccountDeletedEvent(id));
    }
  }
}
