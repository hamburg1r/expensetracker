import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'person.g.dart';
part 'person.freezed.dart';

@freezed
sealed class PersonModel with _$PersonModel {
  factory PersonModel({
    required String firstName,
    String? middleName,
    required String lastName,
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
