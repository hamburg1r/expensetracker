# Use Case Interconnections

This diagram illustrates the high-level interconnections and dependencies between different groups of use cases in the application.

```mermaid
graph TD
    subgraph Person Use Cases
        PersonUC(Person Use Cases)
    end

    subgraph Account Use Cases
        AccountUC(Account Use Cases)
    end

    subgraph Debt Use Cases
        DebtUC(Debt Use Cases)
    end

    subgraph Expense Use Cases
        ExpenseUC(Expense Use Cases)
    end

    subgraph Budget Use Cases
        BudgetUC(Budget Use Cases)
    end

    subgraph Category Use Cases
        CategoryUC(Category Use Cases)
    end

    subgraph UnaccountedMoney Use Cases
        UnaccountedMoneyUC(UnaccountedMoney Use Cases)
    end

    ExpenseUC --> PersonUC : Manages Participants/Payer
    ExpenseUC --> AccountUC : Relates to Account
    ExpenseUC --> DebtUC : Can Create/Manage Debts
    ExpenseUC --> CategoryUC : Assigns Category

    DebtUC --> PersonUC : Links Creditor/Debtor
    DebtUC --> ExpenseUC : Associated with Expense

    AccountUC --> UnaccountedMoneyUC : Manages Unaccounted Money
    AccountUC --> ExpenseUC : Funds Expenses

    BudgetUC --> CategoryUC : Contains Categories

    CategoryUC --> BudgetUC : Belongs to Budget

    click PersonUC href "person_model.md" "Person Use Cases"
    click AccountUC href "account_model.md" "Account Use Cases"
    click DebtUC href "debt_model.md" "Debt Use Cases"
    click ExpenseUC href "expense_model.md" "Expense Use Cases"
    click BudgetUC href "budget_category_model.md" "Budget Use Cases"
    click CategoryUC href "budget_category_model.md" "Category Use Cases"
    click UnaccountedMoneyUC href "unaccounted_money_model.md" "Unaccounted Money Use Cases"
```
---
See also: [Model Connections](model_connections.md)
