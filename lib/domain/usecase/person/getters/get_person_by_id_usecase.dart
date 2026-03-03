import 'package:expensetracker/domain/model/person.dart';
import 'package:expensetracker/domain/repository/person.dart';

class GetPersonByIdUseCase {
  final PersonRepo _personRepo;

  GetPersonByIdUseCase(this._personRepo);

  Future<Person?> call(int id) async {
    return await _personRepo.getById(id);
  }
}
