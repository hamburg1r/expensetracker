import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:expensetracker/domain/event_bus/event.dart';
import 'package:expensetracker/domain/cache.dart';

List<SingleChildWidget> coreProviders = [
  Provider<EventBus>(
    create: (_) => EventBus(),
    dispose: (context, bus) => bus.dispose(),
  ),
  Provider<Cache>(
    create: (_) => Cache(),
  ),
];
