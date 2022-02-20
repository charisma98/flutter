/*
 * This file is part of wger Workout Manager <https://github.com/wger-project>.
 * Copyright (C) 2020, 2021 wger Team
 *
 * wger Workout Manager is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wger/models/exercises/alias.dart';
import 'package:wger/models/exercises/base.dart';
import 'package:wger/models/exercises/category.dart';
import 'package:wger/models/exercises/comment.dart';
import 'package:wger/models/exercises/equipment.dart';
import 'package:wger/models/exercises/image.dart';
import 'package:wger/models/exercises/language.dart';
import 'package:wger/models/exercises/muscle.dart';

part 'exercise.g.dart';

@JsonSerializable()
class Exercise extends Equatable {
  @JsonKey(required: true)
  final int? id;

  @JsonKey(required: true)
  final String? uuid;

  @JsonKey(required: true, name: 'language')
  late int languageId;

  @JsonKey(ignore: true)
  late Language languageObj;

  @JsonKey(required: true, name: 'creation_date')
  final DateTime? creationDate;

  @JsonKey(required: true, name: 'exercise_base')
  late int? baseId;

  @JsonKey(ignore: true)
  late ExerciseBase baseObj;

  @JsonKey(required: true)
  final String name;

  @JsonKey(required: true)
  final String description;

  @JsonKey(ignore: true)
  List<Comment> tips = [];

  @JsonKey(ignore: true)
  List<Alias> alias = [];

  Exercise({
    this.id,
    this.uuid,
    this.creationDate,
    required this.name,
    required this.description,
    base,
    language,
  }) {
    if (base != null) {
      baseObj = base;
      baseId = base.id;
    }

    if (language != null) {
      languageObj = language;
      languageId = language.id;
    }
  }

  ExerciseImage? get getMainImage => baseObj.getMainImage;
  ExerciseCategory get category => baseObj.category;
  List<ExerciseImage> get images => baseObj.images;
  List<Equipment> get equipment => baseObj.equipment;
  List<Muscle> get muscles => baseObj.muscles;
  List<Muscle> get musclesSecondary => baseObj.musclesSecondary;

  set base(ExerciseBase base) {
    baseObj = base;
    baseId = base.id;
  }

  set language(Language language) {
    languageObj = language;
    languageId = language.id;
  }

  // Boilerplate
  factory Exercise.fromJson(Map<String, dynamic> json) => _$ExerciseFromJson(json);
  Map<String, dynamic> toJson() => _$ExerciseToJson(this);

  @override
  List<Object?> get props => [
        id,
        baseId,
        uuid,
        languageId,
        creationDate,
        name,
        description,
        baseObj,
      ];
}
