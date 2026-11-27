# expensetracker

## Project Overview

This is a Flutter project named `expensetracker`, designed to help users track their expenses. It utilizes `flutter_bloc` for state management, `freezed` and `json_serializable` for code generation, and appears to be set up for local data persistence with ObjectBox (although currently commented out in `pubspec.yaml`). The project structure follows typical Flutter conventions with `lib`, `android`, and `test` directories.

The `README.md` includes a `mermaid` ER diagram outlining the data model, which consists of `Person`, `Account`, `Budget`, `Category`, `Expense`, and `Debt` entities.

## Building and Running

To work with this Flutter project, use the standard Flutter CLI commands:

*   **Install dependencies:**
    ```bash
    flutter pub get
    ```
*   **Run the application:**
    ```bash
    flutter run
    ```
*   **Run tests:**
    ```bash
    flutter test
    ```
*   **Build the application (e.g., for Android APK):**
    ```bash
    flutter build apk
    ```
    (Replace `apk` with `ios`, `web`, etc., as needed for other platforms.)
*   **Generate code (for `freezed`, `json_serializable`, etc.):
    ```bash
    flutter pub run build_runner build
    ```

## Development Conventions

*   **Language:** Dart
*   **Framework:** Flutter
*   **State Management:** `flutter_bloc` and `equatable` are used to implement the BLoC (Business Logic Component) pattern for managing application state.
*   **Code Generation:**
    *   `freezed` is used for generating immutable data classes, union types, and copyWith methods.
    *   `json_serializable` is used in conjunction with `freezed` for automatic JSON serialization/deserialization.
*   **Linting/Code Style:** `flutter_lints` is used to enforce good coding practices, configured via `analysis_options.yaml`.
*   **Testing:** Unit and widget tests are written using `flutter_test` and `bloc_test`. Mocking is facilitated by `mockito`.
*   **Documentation (Doc Strings):** All public and private methods should have comprehensive doc strings (`///`). These doc strings must accurately describe the method's purpose, parameters, return values, and workflow. It is crucial to keep doc strings updated whenever the method's implementation, behavior, or signature changes.
*   **Local Persistence:** The presence of commented-out `objectbox` and `objectbox_generator` in `pubspec.yaml` suggests an intention to use ObjectBox for local database storage.

## Committing Changes

*   When there are staged changes, create a commit message that clearly describes the modifications. Utilize `git diff` to understand the exact changes and craft more detailed and accurate commit messages.
*   **Important Note on Backticks in Commit Messages (via Shell Tool):** The backtick character (`) gets evaluated by bash, causing text between backticks to be ignored when processing the string. To prevent this, either escape the backtick with a backslash (`\``) or use quotes (e.g., `'` or `"`) around the text containing backticks when creating commit messages through the shell tool.

### BLoC Conventions (`bloc.dart` files)

*   **Imports and Variable Declarations:** Imports and variable declarations should be grouped logically and separated by a new line after each section. For example, imports for use cases related to accounts should be grouped, followed by a new line, and then imports for use cases related to debt.
*   **Event Naming:**
    *   **Request Events:** Events that trigger an action (e.g., creating, updating, deleting data) should be named descriptively, often starting with a verb (e.g., `DeletePersonEvent`, `CreateAccountEvent`).
    *   **Notification Events:** Events that signify a change has occurred (e.g., data successfully deleted, a new item added) should also be descriptive, often ending with "ed" or "Changed" (e.g., `PersonDeletedEvent`, `AccountCreatedEvent`).
*   **`on` Declaration Grouping:** Within BLoC files, `on` declarations should be grouped as follows, with a new line separating each logical section:
    *   Getters (e.g., `on<GetPersonEvent>`)
    *   Request Events (e.g., `on<CreatePersonEvent>`, `on<DeletePersonEvent>`)
    *   Notification Events (e.g., `on<PersonCreatedEvent>`, `on<PersonDeletedEvent>`)
