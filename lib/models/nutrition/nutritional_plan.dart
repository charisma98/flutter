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

import 'package:json_annotation/json_annotation.dart';
import 'package:wger/helpers/json.dart';
import 'package:wger/models/nutrition/log.dart';
import 'package:wger/models/nutrition/meal.dart';

import 'nutritrional_values.dart';

part 'nutritional_plan.g.dart';

@JsonSerializable(explicitToJson: true)
class NutritionalPlan {
  @JsonKey(required: true)
  int? id;

  @JsonKey(required: true)
  late String description;

  @JsonKey(required: true, name: 'creation_date', toJson: toDate)
  late DateTime creationDate;

  @JsonKey(ignore: true, defaultValue: [])
  List<Meal> meals = [];

  @JsonKey(ignore: true, defaultValue: [])
  List<Log> logs = [];

  NutritionalPlan({
    this.id,
    required this.description,
    required this.creationDate,
    List<Meal>? meals,
    List<Log>? logs,
  }) {
    this.meals = meals ?? [];
    this.logs = logs ?? [];
  }

  NutritionalPlan.empty() {
    creationDate = DateTime.now();
    description = '';
  }

  // Boilerplate
  factory NutritionalPlan.fromJson(Map<String, dynamic> json) =>
      _$NutritionalPlanFromJson(json);
  Map<String, dynamic> toJson() => _$NutritionalPlanToJson(this);

  /// Calculations
  NutritionalValues get nutritionalValues {
    // This is already done on the server. It might be better to read it from there.
    var out = NutritionalValues();

    for (var meal in meals) {
      out += meal.nutritionalValues;
    }

    return out;
  }

  Map<DateTime, NutritionalValues> get logEntriesValues {
    var out = <DateTime, NutritionalValues>{};
    for (var log in logs) {
      final date =
          DateTime(log.datetime.year, log.datetime.month, log.datetime.day);

      if (!out.containsKey(date)) {
        out[date] = NutritionalValues();
      }

      out[date]!.add(log.nutritionalValues);
    }

    return out;
  }
}
