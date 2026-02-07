import 'package:expensetracker/domain/cache.dart';
import 'package:expensetracker/domain/model/debt.dart';
import 'package:expensetracker/domain/model/person.dart';
import 'package:expensetracker/domain/repository/debt.dart';
import 'package:expensetracker/domain/repository/person.dart';
import 'package:expensetracker/utils/list_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'person_state.dart';

class PersonCubit extends Cubit<PersonState> {
  final PersonRepo personRepo;
  final DebtRepo debtRepo;
  final Cache cache;
  PersonCubit(
    this.personRepo,
    this.debtRepo,
    this.cache, [
    bool initialLoad = true,
  ]) : super(PersonInitial()) {
    if (initialLoad) {
      loadAll();
    }
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
    return _handleDebtFetchingLogic(
      id: id,
      page: page,
      replace: replace,
      limit: limit,
      getDebtIdsFromRepo: personRepo.getDebtsOwed,
      getCurrentPersonDebts: (person) => person.debtsOwed,
      copyWithPersonDebts: (person, newDebts) =>
          person.copyWith(debtsOwed: newDebts),
    );
  }

  Future<List<Debt>> getDebtsRecievable(
    int id,
    int page, [
    bool replace = false,
    int limit = 20,
  ]) async {
    return _handleDebtFetchingLogic(
      id: id,
      page: page,
      replace: replace,
      limit: limit,
      getDebtIdsFromRepo: personRepo.getDebtsReceivable,
      getCurrentPersonDebts: (person) => person.debtsReceivable,
      copyWithPersonDebts: (person, newDebts) =>
          person.copyWith(debtsReceivable: newDebts),
    );
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

  Future<List<Debt>> _handleDebtFetchingLogic({
    required int id,
    required int page,
    required bool replace,
    required int limit,
    required Future<List<int>> Function(int id, int page, int limit)
    getDebtIdsFromRepo,
    required List<Debt> Function(Person person) getCurrentPersonDebts,
    required Person Function(Person person, List<Debt> newDebts)
    copyWithPersonDebts,
  }) async {
    Person? person = cache.get<Person>(id);
    if (person == null) {
      emit(
        PersonError(
          'Person with id $id is not loaded. Debts cannot be fetched.',
        ),
      );
      return [];
    }

    List<int> debtIds = await getDebtIdsFromRepo(id, page, limit);
    List<Debt> debts = (await Future.wait(
      debtIds.map(debtRepo.getById),
    )).nonNulls.toList(growable: false);

    debts.forEach(cache.addWeak);

    if (replace) {
      final List<Debt> debtsToRemove = mergeOrDifferenceLists(
        getCurrentPersonDebts(person),
        debts,
        true, // getDifference
        growable: false,
      );
      debtsToRemove.forEach(cache.releaseStrong);

      cache.update(copyWithPersonDebts(person, debts));
    } else {
      cache.update(
        copyWithPersonDebts(
          person,
          mergeOrDifferenceLists(
            getCurrentPersonDebts(person),
            debts,
            false, // getDifference
            growable: false,
          ),
        ),
      );
    }
    return debts;
  }
}
