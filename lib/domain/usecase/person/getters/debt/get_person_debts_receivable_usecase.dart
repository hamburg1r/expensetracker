import 'package:expensetracker/domain/model/debt.dart';
import 'package:expensetracker/domain/repository/debt.dart';
import 'package:expensetracker/domain/repository/person.dart';

class GetPersonDebtsReceivableUseCase {
  final PersonRepo _personRepo;
  final DebtRepo _debtRepo;

  GetPersonDebtsReceivableUseCase(this._personRepo, this._debtRepo);

  Future<List<Debt>> call(int personId, int page, int limit) async {
    List<int> debtIds = await _personRepo.getDebtsReceivable(
      personId,
      page,
      limit,
    );
    List<Debt> debts = (await Future.wait(
      debtIds.map(_debtRepo.getById),
    )).nonNulls.toList(growable: false);
    return debts;
  }
}
