// TODO: This use case does not fire an event. Needs further consideration.
import 'package:expensetracker/domain/model/debt.dart';
import 'package:expensetracker/domain/model/person.dart';
import 'package:expensetracker/domain/usecase/person/mutations/update_person_usecase.dart';

class AddDebtReceivableToPersonUseCase {
  final UpdatePersonUseCase _updatePersonUseCase;

  AddDebtReceivableToPersonUseCase(this._updatePersonUseCase);

  Future<void> call(Person person, Debt debt) async {
    final updatedPerson = person.copyWith(
      debtsReceivableIds: [...person.debtsReceivableIds, debt.id],
    );

    await _updatePersonUseCase(updatedPerson);
  }
}
