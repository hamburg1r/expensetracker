import 'package:expensetracker/domain/model/account.dart';
import 'package:expensetracker/domain/model/budget.dart';
import 'package:expensetracker/domain/model/debt.dart';
import 'package:expensetracker/domain/model/expense.dart';
import 'package:expensetracker/domain/model/person.dart';
import 'package:flutter/foundation.dart';

class Cache {
  final Map<int, CacheItem<Account>> accounts = {};
  final Map<int, CacheItem<Budget>> budgets = {};
  final Map<int, CacheItem<Category>> categories = {};
  final Map<int, CacheItem<Debt>> debts = {};
  final Map<int, CacheItem<Expense>> expenses = {};
  final Map<int, CacheItem<Person>> people = {};

  void addStrongAccount(Account account) {
    if (accounts.containsKey(account.id)) {
      accounts[account.id]!.increment();
    } else {
      accounts[account.id] = CacheItem(value: account);
    }
  }

  void addWeakAccount(Account account) {
    if (!accounts.containsKey(account.id)) {
      accounts[account.id] = CacheItem(
        value: account,
        references: 0,
      );
    }
  }

  void releaseStrongAccount(Account account) {
    if (!accounts.containsKey(account.id)) return;

    accounts[account.id]!.decrement();

    if (accounts[account.id]!.references == 0) {
      accounts.remove(account.id);
    }
  }

  void _garbageCollectAccount(Account account) {
    for (var child in account.expenses) {}
  }
}

class CacheItem<T> {
  T value;
  int references;
  CacheItem({
    required this.value,
    this.references = 1,
  });

  void increment() => references++;
  void decrement() {
    if (references == 0) return;
    references--;
  }
}
