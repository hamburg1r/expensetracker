// TODO: This use case does not fire an event. Needs further consideration.
import 'package:expensetracker/domain/model/debt.dart';
import 'package:expensetracker/domain/model/person.dart';
import 'package:expensetracker/domain/usecase/person/mutations/update_person_usecase.dart';

class AddDebtOwedToPersonUseCase {
  final UpdatePersonUseCase _updatePersonUseCase;

  AddDebtOwedToPersonUseCase(this._updatePersonUseCase);

  Future<void> call(Person person, Debt debt) async {
    final updatedPerson = person.copyWith(
      debtsOwedIds: [...person.debtsOwedIds, debt.id],
    );

    await _updatePersonUseCase(updatedPerson);
  }
}
