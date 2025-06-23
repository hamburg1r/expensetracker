import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'person.g.dart';

@collection
class PersonModel {
  Id id = Isar.autoIncrement;

  String firstName;
  String? middleName;
  String? lastName;
  int number;

  PersonModel({
    required this.firstName,
    this.middleName,
    this.lastName,
    required this.number,
  });
}

@riverpod
class Person extends _$Person {
  @override
  Future<List<PersonModel>> build() async {
    return [];
  }
}
