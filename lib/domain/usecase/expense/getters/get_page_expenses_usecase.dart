import 'package:expensetracker/domain/model/expense.dart';
import 'package:expensetracker/domain/repository/expense.dart';

/// A use case for retrieving a paginated list of [Expense] objects.
///
/// This class orchestrates the retrieval of expenses for a specific page
/// from the [ExpenseRepository]. It acts as an intermediary between the
/// BLoC layer and the data repository, ensuring a clean separation of concerns.
class GetPageExpensesUseCase {
  final ExpenseRepo _expenseRepository;

  /// Constructs a [GetPageExpensesUseCase] with the given [ExpenseRepository].
  ///
  /// - Parameters:
  ///   - [expenseRepository]: The repository responsible for expense data operations.
  GetPageExpensesUseCase(this._expenseRepository);

  /// Executes the use case, retrieving a page of expenses.
  ///
  /// - Parameters:
  ///   - [page]: The page number to retrieve (0-indexed).
  ///   - [limit]: The maximum number of expenses to retrieve per page.
  ///
  /// - Returns: A [Future] that completes with a [List] of [Expense] objects
  ///   for the specified page.
  Future<List<Expense>> call(int page, int limit) async {
    return _expenseRepository.getPage(page, limit);
  }
}
