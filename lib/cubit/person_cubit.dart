import 'package:expensetracker/domain/cache.dart';
import 'package:expensetracker/domain/model/person.dart';
import 'package:expensetracker/domain/repository/person.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'person_state.dart';

class PersonCubit extends Cubit<PersonState> {
  final PersonRepo personRepo;
  final Cache cache;
  PersonCubit(
    this.personRepo,
    this.cache,
  ) : super(PersonInitial()) {
    loadAll();
  }

  void _addToCache(Person person, [bool partial = true]) {
    if (cache.people.containsKey(person.id)) {
      cache.people[person.id]!.increment();
      cache.people[person.id]!.value = person;
    }

    cache.people[person.id] = CacheItem(
      value: person,
      partial: partial,
    );
  }

  void _addCache(CacheItem<Person> cacheItem) {
    cache.people[cacheItem.value.id] = cacheItem;
  }

  Future<void> loadAll() async {
    emit(PersonLoading());
    try {
      final all = await personRepo.getAll();
      all.forEach(_addToCache);
      emit(PersonLoaded(cache.people));
    } catch (e) {
      emit(PersonError("$e\nFailed to load"));
    }
  }

  Future<void> loadOnly(int id) async {
    emit(PersonLoading());
    try {
      emit(PersonLoading());
    } catch (e) {
      emit(PersonError("$e\nFailed to load Person with id:$id"));
    }
  }

  Future<void> create(Person person) async {
    await personRepo.create(person);
    await loadAll();
  }

  Future<void> remove(int id) async {
    await personRepo.delete(id);
    await loadAll();
  }

  Future<void> update(Person person) async {
    await personRepo.update(person);
    await loadAll();
  }

  Future<Person?> getById(int id) async {
    return personRepo.getById(id);
  }
}
