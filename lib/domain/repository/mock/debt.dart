import 'package:expensetracker/domain/model/debt.dart';
import 'package:expensetracker/domain/repository/debt.dart';

class MockDebtRepo implements DebtRepo {
  final List<Debt> _debts = [];
  int _nextId = 1;

  /// Creates a new debt in the mock repository.
  ///
  /// Assigns a new unique ID and initializes the version to 0.
  @override
  Future<int> create(Debt debt) async {
    final newDebt = debt.copyWith(id: _nextId++, version: 0); // Initialize version
    _debts.add(newDebt);
    return Future.value(newDebt.id);
  }

  /// Deletes a debt from the mock repository by its ID.
  ///
  /// Returns `true` if the debt was found and deleted, `false` otherwise.
  @override
  Future<bool> delete(int id) async {
    final initialLength = _debts.length;
    _debts.removeWhere((debt) => debt.id == id);
    return Future.value(_debts.length < initialLength);
  }

  /// Retrieves all debts from the mock repository.
  ///
  /// Returns a [List<Debt>] containing all stored debts.
  @override
  Future<List<Debt>> getAll() async {
    return Future.value(List.from(_debts));
  }

  /// Retrieves a single debt by its ID from the mock repository.
  ///
  /// Returns the [Debt] if found, otherwise returns `null`.
  @override
  Future<Debt?> getById(int id) async {
    for (var debt in _debts) {
      if (debt.id == id) {
        return Future.value(debt);
      }
    }
    return Future.value(null);
  }

  /// Updates an existing debt in the mock repository.
  ///
  /// Throws an [Exception] if the debt is not found or if a stale object error
  /// occurs due to optimistic locking. Increments the debt's version on successful update.
  @override
  Future<void> update(Debt debt) async {
    final index = _debts.indexWhere((d) => d.id == debt.id);
    if (index == -1) {
      throw Exception('Debt with ID ${debt.id} not found.');
    }
    final existingDebt = _debts[index];
    // Optimistic locking check
    if (existingDebt.version != debt.version) {
      throw Exception('Stale object error: Debt with ID ${debt.id} has been modified by another process.');
    }
    // Update the debt and increment its version
    _debts[index] = debt.copyWith(version: debt.version + 1);
    return Future.value(null); // Explicitly return Future.value(null) for consistency
  }

  /// Retrieves a paginated list of debts where the specified person is the creditor.
  ///
  /// [creditorId] The ID of the creditor.
  /// [page] The page number to retrieve (0-indexed).
  /// [limit] The maximum number of debts per page. Defaults to 20.
  ///
  /// Returns a [List<Debt>] for the specified page.
  @override
  Future<List<Debt>> getDebtsByCreditorId(
    int creditorId,
    int page, [
    int limit = 20,
  ]) async {
    final filteredDebts = _debts
        .where((debt) => debt.creditor.id == creditorId)
        .toList();
    final startIndex = page * limit;
    if (startIndex >= filteredDebts.length) {
      return Future.value([]);
    }
    final endIndex = (startIndex + limit).clamp(0, filteredDebts.length);
    return Future.value(filteredDebts.sublist(startIndex, endIndex));
  }

  /// Retrieves a paginated list of debts where the specified person is the debtor.
  ///
  /// [debtorId] The ID of the debtor.
  /// [page] The page number to retrieve (0-indexed).
  /// [limit] The maximum number of debts per page. Defaults to 20.
  ///
  /// Returns a [List<Debt>] for the specified page.
  @override
  Future<List<Debt>> getDebtsByDebtorId(
    int debtorId,
    int page, [
    int limit = 20,
  ]) async {
    final filteredDebts = _debts
        .where((debt) => debt.debtor.id == debtorId)
        .toList();
    final startIndex = page * limit;
    if (startIndex >= filteredDebts.length) {
      return Future.value([]);
    }
    final endIndex = (startIndex + limit).clamp(0, filteredDebts.length);
    return Future.value(filteredDebts.sublist(startIndex, endIndex));
  }

  /// Retrieves a paginated list of all debts.
  ///
  /// [page] The page number to retrieve (0-indexed).
  /// [limit] The maximum number of debts per page. Defaults to 20.
  ///
  /// Returns a [List<Debt>] for the specified page.
  @override
  Future<List<Debt>> getPage(int page, [int limit = 20]) async {
    final startIndex = page * limit;
    if (startIndex >= _debts.length) {
      return Future.value([]);
    }
    final endIndex = (startIndex + limit).clamp(0, _debts.length);
    return Future.value(_debts.sublist(startIndex, endIndex));
  }
}
