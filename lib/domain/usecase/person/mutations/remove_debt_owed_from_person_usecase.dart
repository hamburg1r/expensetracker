// TODO: This use case does not fire an event. Needs further consideration.
import 'package:expensetracker/domain/model/person.dart';
import 'package:expensetracker/domain/usecase/person/mutations/update_person_usecase.dart';

class RemoveDebtOwedFromPersonUseCase {
  final UpdatePersonUseCase _updatePersonUseCase;

  RemoveDebtOwedFromPersonUseCase(this._updatePersonUseCase);

  Future<void> call(Person person, int debtId) async {
    final updatedPerson = person.copyWith(
      debtsOwedIds: [...person.debtsOwedIds, debtId],
    );

    await _updatePersonUseCase(updatedPerson);
  }
}
