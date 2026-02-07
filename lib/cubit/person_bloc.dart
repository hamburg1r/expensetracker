import 'package:expensetracker/domain/cache.dart';
import 'package:expensetracker/domain/model/debt.dart';
import 'package:expensetracker/domain/model/person.dart';
import 'package:expensetracker/domain/repository/debt.dart';
import 'package:expensetracker/domain/repository/person.dart';
import 'package:expensetracker/utils/list_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'person_state.dart';
part 'person_event.dart';

class PersonBloc extends Bloc<PersonEvent, PersonState> {
  final PersonRepo personRepo;
  final DebtRepo debtRepo;
  final Cache cache;

  PersonBloc(this.personRepo, this.debtRepo, this.cache) : super(PersonInitial()) {
    on<LoadAllPeopleEvent>(_onLoadAllPeople);
    on<CreatePersonEvent>(_onCreatePerson);
    on<RemovePersonEvent>(_onRemovePerson);
    on<UpdatePersonEvent>(_onUpdatePerson);
    on<GetPagePeopleEvent>(_onGetPagePeople);
    on<GetDebtsOwedEvent>(_onGetDebtsOwed);
    on<GetDebtsReceivableEvent>(_onGetDebtsReceivable);
  }

  void _emitLoadedPeople(Emitter<PersonState> emit) {
    emit(PersonLoaded(cache.getAll<Person>()));
  }

  Future<void> _onLoadAllPeople(LoadAllPeopleEvent event, Emitter<PersonState> emit) async {
    emit(PersonLoading());
    try {
      final List<Person> all = await personRepo.getAll();
      all.forEach(cache.addStrong);
      _emitLoadedPeople(emit);
    } catch (e) {
      emit(PersonError("$e\nFailed to load"));
    }
  }

  Future<void> _onCreatePerson(CreatePersonEvent event, Emitter<PersonState> emit) async {
    await personRepo.create(event.person);
    cache.addStrong(event.person);
    _emitLoadedPeople(emit);
  }

  Future<void> _onRemovePerson(RemovePersonEvent event, Emitter<PersonState> emit) async {
    await personRepo.delete(event.id);
    cache.remove<Person>(event.id);
    _emitLoadedPeople(emit);
  }

  Future<void> _onUpdatePerson(UpdatePersonEvent event, Emitter<PersonState> emit) async {
    await personRepo.update(event.person);
    cache.update(event.person);
    _emitLoadedPeople(emit);
  }

  Future<void> _onGetPagePeople(GetPagePeopleEvent event, Emitter<PersonState> emit) async {
    emit(PersonLoading());
    try {
      final List<Person> pageData = await personRepo.getPage(event.page, event.limit);
      pageData.forEach(cache.addStrong);
      _emitLoadedPeople(emit);
    } catch (e) {
      emit(PersonError("$e\nFailed to fetch Person for page: ${event.page}"));
    }
  }

  Future<void> _onGetDebtsOwed(GetDebtsOwedEvent event, Emitter<PersonState> emit) async {
    await _handleDebtFetchingLogic(
      id: event.id,
      page: event.page,
      replace: event.replace,
      limit: event.limit,
      getDebtIdsFromRepo: personRepo.getDebtsOwed,
      getCurrentPersonDebts: (person) => person.debtsOwed,
      copyWithPersonDebts: (person, newDebts) => person.copyWith(debtsOwed: newDebts),
      emit: emit,
    );
  }

  Future<void> _onGetDebtsReceivable(GetDebtsReceivableEvent event, Emitter<PersonState> emit) async {
    await _handleDebtFetchingLogic(
      id: event.id,
      page: event.page,
      replace: event.replace,
      limit: event.limit,
      getDebtIdsFromRepo: personRepo.getDebtsReceivable,
      getCurrentPersonDebts: (person) => person.debtsReceivable,
      copyWithPersonDebts: (person, newDebts) => person.copyWith(debtsReceivable: newDebts),
      emit: emit,
    );
  }

  // Helper method for fetching debts, now using Emitter
  Future<void> _handleDebtFetchingLogic({
    required int id,
    required int page,
    required bool replace,
    required int limit,
    required Future<List<int>> Function(int id, int page, int limit) getDebtIdsFromRepo,
    required List<Debt> Function(Person person) getCurrentPersonDebts,
    required Person Function(Person person, List<Debt> newDebts) copyWithPersonDebts,
    required Emitter<PersonState> emit, // Emitter is passed here
  }) async {
    Person? person = cache.get<Person>(id);
    if (person == null) {
      emit(
        PersonError(
          'Person with id $id is not loaded. Debts cannot be fetched.',
        ),
      );
      return; // Return void as it's a Future<void>
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
    _emitLoadedPeople(emit); // Refresh the state after update
  }

  // This method is not part of the Bloc event stream directly.
  // It's meant to be called externally to get loaded data.
  // Its name should probably reflect it's not part of the Bloc's state changes.
  Future<List<Person>> getAllLoaded() async {
    return cache.getAll<Person>().values.toList(growable: false);
  }

  // This method is not part of the Bloc event stream directly.
  // It's meant to be called externally to get a single person.
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
      // No emit here, as this is a read operation not changing the overall state of the Bloc.
      // If a state change is needed, an event should be dispatched.
      return repoPerson;
    } catch (e) {
      // Should not emit directly here in a normal read function.
      // If this error affects the Bloc's overall state, an event should be dispatched.
      return null;
    }
  }
}
