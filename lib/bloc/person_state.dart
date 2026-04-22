part of 'person_bloc.dart';

sealed class PersonState {
  const PersonState();
}

final class PersonInitial extends PersonState {}

final class PersonLoading extends PersonState {}

final class PersonLoaded extends PersonState {
  final Map<int, Person> people;
  const PersonLoaded(
    this.people,
  );
}

final class PersonError extends PersonState {
  final String message;
  const PersonError(this.message);
}

final class PersonDeleted extends PersonState {
  final int personId;
  const PersonDeleted(this.personId);
}

final class PersonUpdated extends PersonState {
  final Person person;
  const PersonUpdated(this.person);
}

final class DebtsOwedLoaded extends PersonState {
  final Person person;
  final List<Debt> debts;
  const DebtsOwedLoaded(this.person, this.debts);
}

final class DebtsReceivableLoaded extends PersonState {
  final Person person;
  final List<Debt> debts;
  const DebtsReceivableLoaded(this.person, this.debts);
}
