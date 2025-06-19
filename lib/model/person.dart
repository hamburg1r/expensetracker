import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'person.g.dart';
part 'person.freezed.dart';

@freezed
abstract class PersonModel with _$PersonModel {
  factory PersonModel({
    required id,
    required String firstName,
    String? middleName,
    String? lastName,
    // required int countryCode,
    required int number,
  }) = _PersonModel;

  factory PersonModel.fromJson(Map<String, dynamic> json) =>
      _$PersonModelFromJson(json);
}

@riverpod
class Person extends _$Person {
  @override
  Future<List<PersonModel>> build() async {
    return [];
  }
}
