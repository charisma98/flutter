// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Exercise _$ExerciseFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'exercise_base',
      'uuid',
      'language',
      'creation_date',
      'name',
      'description'
    ],
  );
  return Exercise(
    id: json['id'] as int,
    baseId: json['exercise_base'] as int,
    uuid: json['uuid'] as String,
    creationDate: DateTime.parse(json['creation_date'] as String),
    languageId: json['language'] as int,
    name: json['name'] as String,
    description: json['description'] as String,
  );
}

Map<String, dynamic> _$ExerciseToJson(Exercise instance) => <String, dynamic>{
      'id': instance.id,
      'exercise_base': instance.baseId,
      'uuid': instance.uuid,
      'language': instance.languageId,
      'creation_date': instance.creationDate.toIso8601String(),
      'name': instance.name,
      'description': instance.description,
    };
