import 'package:expensetracker/domain/model/expense.dart';
import 'package:expensetracker/domain/repository/expense.dart';

/// A use case for retrieving a single [Expense] object by its ID.
///
/// This class orchestrates the retrieval of an expense by its unique identifier
/// from the [ExpenseRepository]. It acts as an intermediary between the BLoC layer
/// and the data repository, ensuring a clean separation of concerns.
class GetExpenseByIdUseCase {
  final ExpenseRepo _expenseRepository;

  /// Constructs a [GetExpenseByIdUseCase] with the given [ExpenseRepository].
  ///
  /// - Parameters:
  ///   - [expenseRepository]: The repository responsible for expense data operations.
  GetExpenseByIdUseCase(this._expenseRepository);

  /// Executes the use case, retrieving an expense by its ID.
  ///
  /// - Parameters:
  ///   - [id]: The unique integer ID of the expense to retrieve.
  ///
  /// - Returns: A [Future] that completes with the [Expense] object if found,
  ///   otherwise `null`.
  Future<Expense?> call(int id) async {
    return _expenseRepository.getById(id);
  }
}
