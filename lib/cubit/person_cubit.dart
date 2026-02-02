import 'package:expensetracker/domain/cache.dart';
import 'package:expensetracker/domain/model/debt.dart';
import 'package:expensetracker/domain/model/person.dart';
import 'package:expensetracker/domain/repository/debt.dart';
import 'package:expensetracker/domain/repository/person.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'person_state.dart';

class PersonCubit extends Cubit<PersonState> {
  final PersonRepo personRepo;
  final DebtRepo debtRepo;
  final Cache cache;
  PersonCubit(
    this.personRepo,
    this.debtRepo,
    this.cache,
  ) : super(PersonInitial()) {
    loadAll();
  }

  void _emitLoadedPeople() {
    emit(PersonLoaded(cache.getAll<Person>()));
  }

  Future<void> loadAll() async {
    emit(PersonLoading());
    try {
      final List<Person> all = await personRepo.getAll();
      all.forEach(cache.addStrong);
      _emitLoadedPeople();
    } catch (e) {
      emit(PersonError("$e\nFailed to load"));
    }
  }

  Future<List<Debt>> getDebtsOwed(
    int id,
    int page, [
    bool replace = false,
    int limit = 20,
  ]) async {
    Person? person = cache.get<Person>(id);
    if (person == null) {
      throw StateError(
        'Person with id $id is not loaded. Debts cannot be fetched.',
      );
    }

    List<int> debtIds = await personRepo.getDebtsOwed(id, page, limit);
    List<Debt> debts = (await Future.wait(
      debtIds.map(debtRepo.getById),
    )).nonNulls.toList(growable: false);

    debts.forEach(cache.addWeak);

    if (replace) {
      person.debtsOwed
          .toSet()
          .difference(debts.toSet())
          .forEach(cache.releaseStrong);

      cache.update(person.copyWith(debtsOwed: debts));
    } else {
      cache.update(person.copyWith(debtsOwed: [...person.debtsOwed, ...debts]));
    }
    return debts;
  }

  Future<void> create(Person person) async {
    await personRepo.create(person);
    cache.addStrong(person);
    _emitLoadedPeople();
  }

  Future<void> remove(int id) async {
    await personRepo.delete(id);
    cache.remove<Person>(id);
    _emitLoadedPeople();
  }

  Future<void> update(Person person) async {
    await personRepo.update(person);
    cache.update(person);
    _emitLoadedPeople();
  }

  Future<List<Person>> getAllLoaded() async {
    return cache.getAll<Person>().values.toList(growable: false);
  }

  Future<Person?> getById(int id, [bool strong = true]) async {
    final person = cache.get<Person>(id);
    if (person != null) {
      if (strong && cache.references(person) <= 0) cache.addStrong(person);
      return person;
    }

    try {
      final repoPerson = await personRepo.getById(id);
      if (repoPerson == null) {
        return null;
      }
      cache.addStrong(repoPerson);
      _emitLoadedPeople();
      return repoPerson;
    } catch (e) {
      emit(PersonError("$e\nFailed to load Person with id: $id"));
      return null;
    }
  }

  Future<void> getPage(
    int page, [
    int limit = 20,
  ]) async {
    emit(PersonLoading());
    try {
      final List<Person> pageData = await personRepo.getPage(page, limit);
      pageData.forEach(cache.addStrong);
      _emitLoadedPeople();
    } catch (e) {
      emit(PersonError("$e\nFailed to fetch Person for page: $page"));
    }
  }
}
