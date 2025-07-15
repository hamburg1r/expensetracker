import 'package:expensetracker/domain/model/person.dart';
import 'package:expensetracker/domain/repository/person.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'person_state.dart';

class PersonCubit extends Cubit<PersonState> {
  final PersonRepo _repo;
  PersonCubit(this._repo) : super(PersonInitial());

  Future<void> load() async {
    emit(PersonLoading());
    try {
      final all = await _repo.getAll();
      emit(PersonLoaded(all));
    } catch (e) {
      emit(PersonError("Failed to load"));
    }
  }

  Future<void> add(Person person) async {
    await _repo.add(person);
    await load();
  }

  Future<void> remove(int id) async {
    await _repo.delete(id);
    await load();
  }

  Future<void> update(Person person) async {
    await _repo.update(person);
    await load();
  }

  Future<Person?> getById(int id) async {
    return _repo.getFromId(id);
  }
}
