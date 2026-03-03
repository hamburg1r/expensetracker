import 'package:expensetracker/domain/model/person.dart';
import 'package:expensetracker/domain/repository/person.dart';

class GetPagePeopleUseCase {
  final PersonRepo _personRepo;

  GetPagePeopleUseCase(this._personRepo);

  Future<List<Person>> call(int page, int limit) async {
    return await _personRepo.getPage(page, limit);
  }
}
