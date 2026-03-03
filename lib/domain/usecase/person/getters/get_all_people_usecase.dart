import 'package:expensetracker/domain/model/person.dart';
import 'package:expensetracker/domain/repository/person.dart';

class GetAllPeopleUseCase {
  final PersonRepo _personRepo;

  GetAllPeopleUseCase(this._personRepo);

  Future<List<Person>> call() async {
    return await _personRepo.getAll();
  }
}
