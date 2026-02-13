import 'dart:async';
import 'package:expensetracker/domain/event_bus/domain_event.dart';

class EventBus {
  final _controller = StreamController<DomainEvent>.broadcast();

  Stream<T> on<T extends DomainEvent>() {
    return _controller.stream.where((event) => event is T).cast<T>();
  }

  void fire(DomainEvent event) {
    _controller.add(event);
  }

  void dispose() {
    _controller.close();
  }
}
