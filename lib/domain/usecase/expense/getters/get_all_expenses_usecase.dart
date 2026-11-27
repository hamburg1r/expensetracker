import 'package:expensetracker/domain/model/expense.dart';
import 'package:expensetracker/domain/repository/expense.dart';

/// A use case for retrieving all [Expense] objects.
///
/// This class orchestrates the retrieval of all expenses from the
/// [ExpenseRepository]. It acts as an intermediary between the BLoC layer
/// and the data repository, ensuring a clean separation of concerns.
class GetAllExpensesUseCase {
  final ExpenseRepo _expenseRepository;

  /// Constructs a [GetAllExpensesUseCase] with the given [ExpenseRepository].
  ///
  /// - Parameters:
  ///   - [expenseRepository]: The repository responsible for expense data operations.
  GetAllExpensesUseCase(this._expenseRepository);

  /// Executes the use case, retrieving all expenses.
  ///
  /// - Returns: A [Future] that completes with a [List] of all [Expense] objects.
  Future<List<Expense>> call() async {
    return _expenseRepository.getAll();
  }
}
