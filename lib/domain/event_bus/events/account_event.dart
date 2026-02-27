import 'package:expensetracker/domain/model/account.dart';
import 'package:expensetracker/domain/event_bus/event.dart';

class AccountDataChangedEvent extends DomainEvent {
  final Account updatedAccount;
  AccountDataChangedEvent(this.updatedAccount);
}
