part of 'person_cubit.dart';

sealed class PersonState {}

class PersonInitial extends PersonState {}

class PersonLoading extends PersonState {}

class PersonLoaded extends PersonState {
  final List<Person> people;
  PersonLoaded(this.people);
}

class PersonError extends PersonState {
  final String message;
  PersonError(this.message);
}
