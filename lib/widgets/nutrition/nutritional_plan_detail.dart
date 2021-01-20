/*
 * This file is part of wger Workout Manager <https://github.com/wger-project>.
 * Copyright (C) 2020 wger Team
 *
 * wger Workout Manager is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * wger Workout Manager is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wger/locale/locales.dart';
import 'package:wger/models/nutrition/nutritional_plan.dart';
import 'package:wger/models/nutrition/nutritrional_values.dart';
import 'package:wger/widgets/core/bottom_sheet.dart';
import 'package:wger/widgets/nutrition/charts.dart';
import 'package:wger/widgets/nutrition/forms.dart';
import 'package:wger/widgets/nutrition/meal.dart';

class NutritionalPlanDetailWidget extends StatelessWidget {
  final NutritionalPlan _nutritionalPlan;
  NutritionalPlanDetailWidget(this._nutritionalPlan);

  @override
  Widget build(BuildContext context) {
    final nutritionalValues = _nutritionalPlan.nutritionalValues;

    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                DefaultMaterialLocalizations()
                    .formatMediumDate(_nutritionalPlan.creationDate)
                    .toString(),
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                _nutritionalPlan.description,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            if (_nutritionalPlan.meals.length > 0)
              ..._nutritionalPlan.meals.map((meal) => MealWidget(meal)).toList(),
            ElevatedButton(
              child: Text(AppLocalizations.of(context).add),
              onPressed: () {
                showFormBottomSheet(
                    context, AppLocalizations.of(context).addMeal, MealForm(_nutritionalPlan));
              },
            ),
            Container(
              padding: EdgeInsets.all(15),
              height: 220,
              child: NutritionalPlanPieChartWidget(nutritionalValues),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Table(
                children: [
                  TableRow(children: [
                    Text('Energy'),
                    Text(
                        '${nutritionalValues.energy.toStringAsFixed(0)} kcal / ${nutritionalValues.energyKj.toStringAsFixed(0)} kJ'),
                  ]),
                  TableRow(children: [
                    Text('Protein'),
                    Text('${nutritionalValues.protein.toStringAsFixed(0)}g'),
                  ]),
                  TableRow(children: [
                    Text('Carbohydrates'),
                    Text('${nutritionalValues.carbohydrates.toStringAsFixed(0)}g')
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text('sugar content'),
                    ),
                    Text('${nutritionalValues.carbohydratesSugar.toStringAsFixed(0)}g')
                  ]),
                  TableRow(children: [
                    Text('Fat'),
                    Text('${nutritionalValues.fat.toStringAsFixed(0)}g'),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text('Saturated fat'),
                    ),
                    Text('${nutritionalValues.fatSaturated.toStringAsFixed(0)}g')
                  ]),
                  TableRow(children: [
                    Text('Fibres'),
                    Text('${nutritionalValues.fibres.toStringAsFixed(0)}g'),
                  ]),
                  TableRow(children: [
                    Text('Sodium'),
                    Text('${nutritionalValues.sodium.toStringAsFixed(0)}g'),
                  ]),
                ],
              ),
            ),
            Padding(padding: const EdgeInsets.all(8.0)),
            Text('Diary', style: Theme.of(context).textTheme.headline6),
            Container(
              padding: EdgeInsets.all(15),
              height: 220,
              child: NutritionalDiaryChartWidget(nutritionalPlan: _nutritionalPlan),
            ),
            Container(
              height: 200,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(''),
                          Text(AppLocalizations.of(context).energy),
                          Text(AppLocalizations.of(context).protein),
                          Text(AppLocalizations.of(context).carbohydrates),
                          Text(AppLocalizations.of(context).sugars),
                          Text(AppLocalizations.of(context).fat),
                          Text(AppLocalizations.of(context).saturatedFat),
                        ],
                      ),
                    ),
                    ..._nutritionalPlan.logEntriesValues.entries
                        .map((entry) => NutritionDiaryEntry(entry.key, entry.value))
                        .toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NutritionDiaryEntry extends StatelessWidget {
  final DateTime date;
  final NutritionalValues values;

  NutritionDiaryEntry(
    this.date,
    this.values,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(DateFormat.yMd().format(date).toString(),
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text('${values.energy.toStringAsFixed(0)} kJ'),
          Text('${values.protein.toStringAsFixed(0)} g'),
          Text('${values.carbohydrates.toStringAsFixed(0)} g'),
          Text('${values.carbohydratesSugar.toStringAsFixed(0)} g'),
          Text('${values.fat.toStringAsFixed(0)} g'),
          Text('${values.fatSaturated.toStringAsFixed(0)} g'),
        ],
      ),
    );
  }
}
