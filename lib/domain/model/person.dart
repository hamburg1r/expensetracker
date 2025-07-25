import 'package:freezed_annotation/freezed_annotation.dart';

part 'person.freezed.dart';

@Freezed()
abstract class Person with _$Person {
  const factory Person({
    @Default(0) int id,
    required String firstName,
    required String? middleName,
    required String? lastName,
    required int number,
    // required paid,
    // required participation,
    // required debts,
  }) = _Person;

  String get name => firstName + (middleName ?? '') + (lastName ?? '');

  const Person._();
}
