// TODO: This use case does not fire an event. Needs further consideration.
import 'package:expensetracker/domain/model/person.dart';
import 'package:expensetracker/domain/usecase/person/mutations/update_person_usecase.dart';

class RemoveDebtReceivableFromPersonUseCase {
  final UpdatePersonUseCase _updatePersonUseCase;

  RemoveDebtReceivableFromPersonUseCase(this._updatePersonUseCase);

  Future<void> call(Person person, int debtId) async {
    final updatedPerson = person.copyWith(
      debtsReceivableIds: [...person.debtsReceivableIds, debtId],
    );

    await _updatePersonUseCase(updatedPerson);
  }
}
