part of 'person_bloc.dart';

sealed class PersonEvent extends Equatable {
  const PersonEvent();

  @override
  List<Object> get props => [];
}

class LoadAllPeopleEvent extends PersonEvent {}

class CreatePersonEvent extends PersonEvent {
  final Person person;

  const CreatePersonEvent(this.person);

  @override
  List<Object> get props => [person];
}

class DeletePersonEvent extends PersonEvent {
  final Person person;

  const DeletePersonEvent(this.person);

  @override
  List<Object> get props => [person];
}

class RemovePersonEvent extends PersonEvent {
  final Person person;

  const RemovePersonEvent(this.person);

  @override
  List<Object> get props => [person];
}

class UpdatePersonEvent extends PersonEvent {
  final Person person;

  const UpdatePersonEvent(this.person);

  @override
  List<Object> get props => [person];
}

class GetPagePeopleEvent extends PersonEvent {
  final int page;
  final int limit;

  const GetPagePeopleEvent(this.page, [this.limit = 20]);

  @override
  List<Object> get props => [page, limit];
}

class GetPersonDebtsOwedEvent extends PersonEvent {
  final Person person;
  final int page;
  final bool replace;
  final int limit;

  const GetPersonDebtsOwedEvent(
    this.person,
    this.page, [
    this.replace = false,
    this.limit = 20,
  ]);

  @override
  List<Object> get props => [person, page, replace, limit];
}

class GetPersonDebtsReceivableEvent extends PersonEvent {
  final Person person;
  final int page;
  final bool replace;
  final int limit;

  const GetPersonDebtsReceivableEvent(
    this.person,
    this.page, [
    this.replace = false,
    this.limit = 20,
  ]);

  @override
  List<Object> get props => [person, page, replace, limit];
}

class UnloadPersonEvent extends PersonEvent {
  final Person person;

  const UnloadPersonEvent(this.person);

  @override
  List<Object> get props => [person];
}

class UnloadPeopleEvent extends PersonEvent {
  final List<Person> people;

  const UnloadPeopleEvent(this.people);

  @override
  List<Object> get props => [people];
}

class PersonUpdatedEvent extends PersonEvent {
  final Person person;

  const PersonUpdatedEvent(this.person);

  @override
  List<Object> get props => [person];
}
