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

class RemovePersonEvent extends PersonEvent {
  final int id;

  const RemovePersonEvent(this.id);

  @override
  List<Object> get props => [id];
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

class GetDebtsOwedEvent extends PersonEvent {
  final int id;
  final int page;
  final bool replace;
  final int limit;

  const GetDebtsOwedEvent(this.id, this.page,
      [this.replace = false, this.limit = 20]);

  @override
  List<Object> get props => [id, page, replace, limit];
}

class GetDebtsReceivableEvent extends PersonEvent {
  final int id;
  final int page;
  final bool replace;
  final int limit;

  const GetDebtsReceivableEvent(this.id, this.page,
      [this.replace = false, this.limit = 20]);

  @override
  List<Object> get props => [id, page, replace, limit];
}
