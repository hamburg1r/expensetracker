import 'package:expensetracker/model/entities/person.dart';
import 'package:expensetracker/model/main.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'debt.g.dart';

enum DebtType { owe, borrow }

@collection
class Debt {
  Id get id => Isar.autoIncrement;

  final person = IsarLink<Person>();
  double amount;
  @Enumerated(EnumType.name)
  DebtType type;
  String? description;
  DateTime date;
  bool isSettled;

  Debt({
    required this.amount,
    required this.type,
    this.description,
    required this.date,
    required this.isSettled,
  });
}

// FIXME: check this
@riverpod
class Debts extends _$Debts {
  late final Isar _isar;

  @override
  Future<List<Debt>> build() async {
    _isar = await ref.watch(debtDatabaseProvider.future);
    final debts = await _isar.debts.where().findAll();
    for (final d in debts) {
      await d.person.load();
    }
    return debts;
  }

  Future<void> add(Debt debt) async {
    await _isar.writeTxn(() async {
      await _isar.debts.put(debt);
      await debt.person.save();
    });
    state = AsyncValue.data(await _isar.debts.where().findAll());
  }

  Future<void> delete(Id id) async {
    await _isar.writeTxn(() async {
      await _isar.debts.delete(id);
    });
    state = AsyncValue.data(await _isar.debts.where().findAll());
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final debts = await _isar.debts.where().findAll();
    for (final d in debts) {
      await d.person.load();
    }
    state = AsyncValue.data(debts);
  }
}
