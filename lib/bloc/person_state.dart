part of 'person_bloc.dart';

sealed class PersonState {
  const PersonState();
}

final class PersonInitial extends PersonState {}

final class PersonLoading extends PersonState {}

// TODO: needs current page number
final class PersonLoaded extends PersonState {
  final Map<int, Person> people;
  final bool isLoadingMore; // New property
  const PersonLoaded(this.people, {this.isLoadingMore = false}); // Update constructor
  // TODO: need some methods or data members for updated/delete person info storage
  // Maybe a list of previous list indices
}

final class PersonError extends PersonState {
  final String message;
  const PersonError(this.message);
}
