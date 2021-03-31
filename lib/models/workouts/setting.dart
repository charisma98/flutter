import 'package:json_annotation/json_annotation.dart';
import 'package:wger/helpers/json.dart';
import 'package:wger/models/exercises/exercise.dart';
import 'package:wger/models/workouts/repetition_unit.dart';
import 'package:wger/models/workouts/weight_unit.dart';

part 'setting.g.dart';

@JsonSerializable()
class Setting {
  @JsonKey(required: true)
  int? id;

  @JsonKey(required: true, name: 'set')
  late int setId;

  @JsonKey(ignore: true)
  late Exercise exerciseObj;

  @JsonKey(required: true, name: 'exercise')
  late int exerciseId;

  @JsonKey(required: true, name: 'repetition_unit')
  late int repetitionUnitId;

  @JsonKey(ignore: true)
  late RepetitionUnit repetitionUnitObj;

  @JsonKey(required: true)
  late int reps;

  @JsonKey(required: true, fromJson: toNum, toJson: toString)
  late num weight;

  @JsonKey(required: true, name: 'weight_unit')
  late int weightUnitId;

  @JsonKey(ignore: true)
  late WeightUnit weightUnitObj;

  @JsonKey(required: true)
  late String comment = '';

  @JsonKey(required: true)
  String? rir = '';

  // Generated by Server
  @JsonKey(required: false)
  late String repsText;

  Setting({
    this.id,
    required this.setId,
    required this.exerciseId,
    required this.repetitionUnitId,
    required this.reps,
    required this.weightUnitId,
    required this.comment,
    required this.rir,
    required this.repsText,
  });

  Setting.withData({
    this.id,
    required this.setId,
    Exercise? exerciseObj,
    required this.repetitionUnitId,
    required this.reps,
    required this.weight,
    required this.weightUnitId,
    required this.comment,
    this.rir = '',
    required this.repsText,
  }) {
    if (exerciseObj != null) {
      this.exerciseId = exerciseObj.id;
      this.exerciseObj = exerciseObj;
    }
  }

  // Boilerplate
  factory Setting.fromJson(Map<String, dynamic> json) => _$SettingFromJson(json);
  Map<String, dynamic> toJson() => _$SettingToJson(this);
}
