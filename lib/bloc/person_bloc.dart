import 'dart:async';
import 'package:expensetracker/domain/cache.dart';
import 'package:expensetracker/domain/event_bus/domain_event.dart';
import 'package:expensetracker/domain/event_bus/event_bus.dart';
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
  final EventBus _eventBus;
  late StreamSubscription _personDataChangedSubscription;

  PersonBloc(this.personRepo, this.debtRepo, this.cache, this._eventBus)
    : super(PersonInitial()) {
    on<LoadAllPeopleEvent>(_onLoadAllPeople);
    on<CreatePersonEvent>(_onCreatePerson);
    on<RemovePersonEvent>(_onRemovePerson);
    on<UpdatePersonEvent>(_onUpdatePerson);
    on<GetPagePeopleEvent>(_onGetPagePeople);
    on<GetPersonDebtsOwedEvent>(_onGetDebtsOwed);
    on<GetPersonDebtsReceivableEvent>(_onGetDebtsReceivable);
    on<UnloadPersonEvent>(_onUnloadPerson);
    on<UnloadPeopleEvent>(_onUnloadPeople);

    _personDataChangedSubscription = _eventBus
        .on<PersonDataChangedEvent>()
        .listen((event) {
          add(UpdatePersonEvent(event.updatedPerson));
        });
  }

  @override
  Future<void> close() {
    _personDataChangedSubscription.cancel();
    return super.close();
  }

  void _emitLoadedPeople(Emitter<PersonState> emit) {
    emit(PersonLoaded(cache.getAll<Person>()));
  }

  Future<void> _onLoadAllPeople(
    LoadAllPeopleEvent event,
    Emitter<PersonState> emit,
  ) async {
    emit(PersonLoading());
    try {
      final List<Person> all = await personRepo.getAll();
      all.forEach(cache.addStrong);
      _emitLoadedPeople(emit);
    } catch (e) {
      emit(PersonError("$e\nFailed to load"));
    }
  }

  Future<void> _onUnloadPerson(
    UnloadPersonEvent event,
    Emitter<PersonState> emit,
  ) async {
    cache.releaseStrong<Person>(event.person);
    _emitLoadedPeople(emit);
  }

  Future<void> _onUnloadPeople(
    UnloadPeopleEvent event,
    Emitter<PersonState> emit,
  ) async {
    for (var person in event.people) {
      cache.releaseStrong<Person>(person);
    }
    _emitLoadedPeople(emit);
  }

  Future<void> _onCreatePerson(
    CreatePersonEvent event,
    Emitter<PersonState> emit,
  ) async {
    emit(PersonLoading());
    try {
      await personRepo.create(event.person);
      cache.addStrong(event.person);
      _emitLoadedPeople(emit);
    } catch (e) {
      emit(PersonError("$e\nFailed to create Person"));
    }
  }

  Future<void> _onRemovePerson(
    RemovePersonEvent event,
    Emitter<PersonState> emit,
  ) async {
    emit(PersonLoading());
    try {
      await personRepo.delete(event.person.id);
      cache.remove<Person>(event.person.id);
      _emitLoadedPeople(emit);
    } catch (e) {
      emit(PersonError("$e\nFailed to remove Person"));
    }
  }

  Future<void> _onUpdatePerson(
    UpdatePersonEvent event,
    Emitter<PersonState> emit,
  ) async {
    emit(PersonLoading());
    try {
      await personRepo.update(event.person);
      cache.update(event.person);
      _emitLoadedPeople(emit);
    } catch (e) {
      emit(PersonError("$e\nFailed to update Person"));
    }
  }

  Future<void> _onGetPagePeople(
    GetPagePeopleEvent event,
    Emitter<PersonState> emit,
  ) async {
    emit(PersonLoading());
    try {
      final List<Person> pageData = await personRepo.getPage(
        event.page,
        event.limit,
      );
      pageData.forEach(cache.addStrong);
      _emitLoadedPeople(emit);
    } catch (e) {
      emit(PersonError("$e\nFailed to fetch Person for page: ${event.page}"));
    }
  }

  Future<void> _onGetDebtsOwed(
    GetPersonDebtsOwedEvent event,
    Emitter<PersonState> emit,
  ) async {
    emit(PersonLoading());
    try {
      await _handleDebtFetchingLogic(
        id: event.person.id,
        page: event.page,
        replace: event.replace,
        limit: event.limit,
        getDebtIdsFromRepo: personRepo.getDebtsOwed,
        getCurrentPersonDebts: (person) => person.debtsOwed,
        copyWithPersonDebts: (person, newDebts) =>
            person.copyWith(debtsOwed: newDebts),
        emit: emit,
      );
    } catch (e) {
      emit(PersonError("$e\nFailed to fetch debts owed for Person"));
    }
  }

  Future<void> _onGetDebtsReceivable(
    GetPersonDebtsReceivableEvent event,
    Emitter<PersonState> emit,
  ) async {
    emit(PersonLoading());
    try {
      await _handleDebtFetchingLogic(
        id: event.person.id,
        page: event.page,
        replace: event.replace,
        limit: event.limit,
        getDebtIdsFromRepo: personRepo.getDebtsReceivable,
        getCurrentPersonDebts: (person) => person.debtsReceivable,
        copyWithPersonDebts: (person, newDebts) =>
            person.copyWith(debtsReceivable: newDebts),
        emit: emit,
      );
    } catch (e) {
      emit(PersonError("$e\nFailed to fetch debts receivable for Person"));
    }
  }

  Future<void> _handleDebtFetchingLogic({
    required int id,
    required int page,
    required bool replace,
    required int limit,
    required Future<List<int>> Function(int id, int page, int limit)
    getDebtIdsFromRepo,
    required List<Debt> Function(Person person) getCurrentPersonDebts,
    required Person Function(Person person, List<Debt> newDebts)
    copyWithPersonDebts,
    required Emitter<PersonState> emit,
  }) async {
    Person? person = cache.get<Person>(id);
    if (person == null) {
      emit(
        PersonError(
          'Person with id $id is not loaded. Debts cannot be fetched.',
        ),
      );
      return;
    }

    try {
      List<int> debtIds = await getDebtIdsFromRepo(id, page, limit);
      List<Debt> debts = (await Future.wait(
        debtIds.map(debtRepo.getById),
      )).nonNulls.toList(growable: false);

      debts.forEach(cache.addWeak);

      if (replace) {
        final List<Debt> debtsToRemove = mergeOrDifferenceLists(
          getCurrentPersonDebts(person),
          debts,
          true,
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
              false,
              growable: false,
            ),
          ),
        );
      }
      _emitLoadedPeople(emit);
    } catch (e) {
      emit(PersonError("$e\nError during debt fetching logic for Person $id"));
    }
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
      return repoPerson;
    } catch (e) {
      return null;
    }
  }
}
