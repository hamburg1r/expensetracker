// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PersonModel _$PersonModelFromJson(Map<String, dynamic> json) => _PersonModel(
      firstName: json['firstName'] as String,
      middleName: json['middleName'] as String?,
      lastName: json['lastName'] as String,
      number: (json['number'] as num).toInt(),
    );

Map<String, dynamic> _$PersonModelToJson(_PersonModel instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'middleName': instance.middleName,
      'lastName': instance.lastName,
      'number': instance.number,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$personHash() => r'b1948437ed331854bbed68d8c07b6f2706619840';

/// See also [Person].
@ProviderFor(Person)
final personProvider =
    AutoDisposeAsyncNotifierProvider<Person, List<PersonModel>>.internal(
  Person.new,
  name: r'personProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$personHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Person = AutoDisposeAsyncNotifier<List<PersonModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
