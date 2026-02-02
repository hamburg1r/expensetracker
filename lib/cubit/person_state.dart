part of 'person_cubit.dart';

sealed class PersonState {
  const PersonState();
}

final class PersonInitial extends PersonState {}

final class PersonLoading extends PersonState {}

final class PersonLoaded extends PersonState {
  final Map<int, Person> people;
  const PersonLoaded(this.people);
}

final class PersonError extends PersonState {
  final String message;
  const PersonError(this.message);
}
