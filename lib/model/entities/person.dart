import 'package:expensetracker/model/entities/debt.dart';
import 'package:expensetracker/model/entities/expenses.dart';
import 'package:expensetracker/model/main.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'person.g.dart';

@collection
class Person {
  Id id = Isar.autoIncrement;

  String firstName;
  String? middleName;
  String? lastName;
  int number;
  @Backlink(to: 'payer')
  final paid = IsarLinks<Expense>();
  @Backlink(to: 'participants')
  final participation = IsarLinks<Expense>();
  @Backlink(to: 'person')
  final debts = IsarLinks<Debt>();

  Person({
    required this.firstName,
    this.middleName,
    this.lastName,
    required this.number,
  });
}

// FIXME: check this
@riverpod
class People extends _$People {
  late final Isar _isar;

  @override
  Future<List<Person>> build() async {
    _isar = await ref.watch(expenseDatabaseProvider.future);
    final people = await _isar.persons.where().findAll();
    for (final p in people) {
      await p.paid.load();
      await p.participation.load();
      await p.debts.load();
    }
    return people;
  }

  Future<void> add(Person person) async {
    await _isar.writeTxn(() async {
      await _isar.persons.put(person);
    });
    state = AsyncValue.data(await _isar.persons.where().findAll());
  }

  Future<void> delete(Id id) async {
    await _isar.writeTxn(() async {
      await _isar.persons.delete(id);
    });
    state = AsyncValue.data(await _isar.persons.where().findAll());
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final people = await _isar.persons.where().findAll();
    for (final p in people) {
      await p.paid.load();
      await p.participation.load();
      await p.debts.load();
    }
    state = AsyncValue.data(people);
  }
}
