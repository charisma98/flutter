/*
 * This file is part of wger Workout Manager <https://github.com/wger-project>.
 * Copyright (C) 2020, 2021 wger Team
 *
 * wger Workout Manager is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * wger Workout Manager is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wger/models/nutrition/log.dart';
import 'package:wger/models/nutrition/nutritional_plan.dart';
import 'package:wger/models/nutrition/nutritional_values.dart';
import 'package:wger/theme/theme.dart';

class NutritionData {
  final String name;
  final double value;

  NutritionData(this.name, this.value);
}

/// Nutritional plan pie chart widget
class NutritionalPlanPieChartWidget extends StatelessWidget {
  final NutritionalValues _nutritionalValues;

  /// [_nutritionalValues] are the calculated [NutritionalValues] for the wanted
  /// plan.
  const NutritionalPlanPieChartWidget(this._nutritionalValues);

  @override
  Widget build(BuildContext context) {
    if (_nutritionalValues.energy == 0) {
      return Container();
    }

    return charts.PieChart<String>([
      charts.Series<NutritionData, String>(
        id: 'NutritionalValues',
        domainFn: (nutritionEntry, index) => nutritionEntry.name,
        measureFn: (nutritionEntry, index) => nutritionEntry.value,
        data: [
          NutritionData(
            AppLocalizations.of(context).protein,
            _nutritionalValues.protein,
          ),
          NutritionData(
            AppLocalizations.of(context).fat,
            _nutritionalValues.fat,
          ),
          NutritionData(
            AppLocalizations.of(context).carbohydrates,
            _nutritionalValues.carbohydrates,
          ),
        ],
        labelAccessorFn: (NutritionData row, _) =>
            '${row.name}\n${row.value.toStringAsFixed(0)}${AppLocalizations.of(context).g}',
      )
    ],
        defaultRenderer: charts.ArcRendererConfig(arcWidth: 60, arcRendererDecorators: [
          charts.ArcLabelDecorator(
            labelPosition: charts.ArcLabelPosition.outside,
          )
        ])
        /*
      defaultRenderer: new charts.ArcRendererConfig(
        arcWidth: 60,
        arcRendererDecorators: [new charts.ArcLabelDecorator()],
      ),

       */
        );
  }
}

class NutritionalDiaryChartWidget extends StatelessWidget {
  const NutritionalDiaryChartWidget({
    Key? key,
    required NutritionalPlan nutritionalPlan,
  })  : _nutritionalPlan = nutritionalPlan,
        super(key: key);

  final NutritionalPlan _nutritionalPlan;

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      [
        charts.Series<List<dynamic>, DateTime>(
          id: 'NutritionDiary',
          colorFn: (datum, index) => wgerChartSecondaryColor,
          domainFn: (datum, index) => datum[1],
          measureFn: (datum, index) => datum[0].energy,
          data: _nutritionalPlan.logEntriesValues.keys
              .map((e) => [_nutritionalPlan.logEntriesValues[e], e])
              .toList(),
        )
      ],
      defaultRenderer: charts.BarRendererConfig<DateTime>(),
      behaviors: [
        charts.RangeAnnotation([
          charts.LineAnnotationSegment(
            _nutritionalPlan.nutritionalValues.energy,
            charts.RangeAnnotationAxisType.measure,
            strokeWidthPx: 2,
            color: charts.MaterialPalette.gray.shade600,
          ),
        ]),
      ],
    );
  }
}

/// Nutritional plan pie chart widget
class NutritionalPlanHatchBarChartWidget extends StatelessWidget {

  final NutritionalValues _nutritionalValues;
  final NutritionalPlan _nutritionalPlan;

  /// [_nutritionalValues] are the calculated [NutritionalValues] for the wanted
  /// plan.
  const NutritionalPlanHatchBarChartWidget(this._nutritionalValues, this._nutritionalPlan);

  NutritionalValues nutritionalValuesFromPlanLogsSevenDayAvg() {

    NutritionalValues sevenDaysAvg = NutritionalValues();
    int count = 0;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    _nutritionalPlan.logEntriesValues.forEach((key, value) {
      if(key.difference(today).inDays >= -7) {
        sevenDaysAvg += value;
        count++;
      }
    });

    sevenDaysAvg.energy = sevenDaysAvg.energy/count;
    sevenDaysAvg.protein = sevenDaysAvg.protein/count;
    sevenDaysAvg.carbohydrates = sevenDaysAvg.carbohydrates/count;
    sevenDaysAvg.carbohydratesSugar = sevenDaysAvg.carbohydratesSugar/count;
    sevenDaysAvg.fat = sevenDaysAvg.fat/count;
    sevenDaysAvg.fatSaturated = sevenDaysAvg.fatSaturated/count;
    sevenDaysAvg.fibres = sevenDaysAvg.fibres/count;
    sevenDaysAvg.sodium = sevenDaysAvg.sodium/count;


    return sevenDaysAvg;
  }

  NutritionalValues nutritionalValuesFromPlanLogsToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return _nutritionalPlan.logEntriesValues[_nutritionalPlan.logEntriesValues.keys.firstWhere((d) => d.difference(today).inDays == 0)]
        ?? NutritionalValues();
  }

  @override
  Widget build(BuildContext context) {
    final NutritionalValues loggedNutritionalValues = nutritionalValuesFromPlanLogsToday();
    final NutritionalValues sevenDayAvg = nutritionalValuesFromPlanLogsSevenDayAvg();

    if (_nutritionalValues.energy == 0) {
      return Container();
    }

    return charts.BarChart(

      [
        charts.Series<NutritionData, String>(
          id: 'Planned',
          domainFn: (nutritionEntry, index) => nutritionEntry.name,
          measureFn: (nutritionEntry, index) => nutritionEntry.value,
          data: [
            NutritionData(
              AppLocalizations.of(context).energy,
              _nutritionalValues.energy,
            ),
            NutritionData(
              AppLocalizations.of(context).protein,
              _nutritionalValues.protein,
            ),
            NutritionData(
              AppLocalizations.of(context).carbohydrates,
              _nutritionalValues.carbohydrates,
            ),
            NutritionData(
              AppLocalizations.of(context).sugars,
              _nutritionalValues.carbohydratesSugar,
            ),
            NutritionData(
              AppLocalizations.of(context).fat,
              _nutritionalValues.fat,
            ),
            NutritionData(
              AppLocalizations.of(context).saturatedFat,
              _nutritionalValues.fatSaturated,
            ),
            NutritionData(
              AppLocalizations.of(context).fibres,
              _nutritionalValues.fibres,
            ),
            NutritionData(
              AppLocalizations.of(context).sodium,
              _nutritionalValues.sodium,
            ),
          ],


        ),
        charts.Series<NutritionData, String>(
          id: 'Logged',
          domainFn: (nutritionEntry, index) => nutritionEntry.name,
          measureFn: (nutritionEntry, index) => nutritionEntry.value,
          fillPatternFn: (nutritionEntry, index) => charts.FillPatternType.forwardHatch,
          data: [
            NutritionData(
              AppLocalizations.of(context).energy,
              loggedNutritionalValues.energy
            ),
            NutritionData(
              AppLocalizations.of(context).protein,
              loggedNutritionalValues.protein
            ),
            NutritionData(
              AppLocalizations.of(context).carbohydrates,
              loggedNutritionalValues.carbohydrates
            ),
            NutritionData(
              AppLocalizations.of(context).sugars,
              loggedNutritionalValues.carbohydratesSugar
            ),
            NutritionData(
              AppLocalizations.of(context).fat,
              loggedNutritionalValues.fat
            ),
            NutritionData(
              AppLocalizations.of(context).saturatedFat,
              loggedNutritionalValues.fatSaturated
            ),
            NutritionData(
              AppLocalizations.of(context).fibres,
              loggedNutritionalValues.fibres
            ),
            NutritionData(
              AppLocalizations.of(context).sodium,
              loggedNutritionalValues.sodium
            ),
          ],
        ),
        charts.Series<NutritionData, String>(
          id: 'Avg',
          domainFn: (nutritionEntry, index) => nutritionEntry.name,
          measureFn: (nutritionEntry, index) => nutritionEntry.value,
          data: [
            NutritionData(
              AppLocalizations.of(context).energy,
              sevenDayAvg.energy
            ),
            NutritionData(
              AppLocalizations.of(context).protein,
              sevenDayAvg.protein
            ),
            NutritionData(
              AppLocalizations.of(context).carbohydrates,
              sevenDayAvg.carbohydrates
            ),
            NutritionData(
              AppLocalizations.of(context).sugars,
              sevenDayAvg.carbohydratesSugar
            ),
            NutritionData(
              AppLocalizations.of(context).fat,
              sevenDayAvg.fat
            ),
            NutritionData(
              AppLocalizations.of(context).saturatedFat,
              sevenDayAvg.fatSaturated
            ),
            NutritionData(
              AppLocalizations.of(context).fibres,
              sevenDayAvg.fibres
            ),
            NutritionData(
              AppLocalizations.of(context).sodium,
              sevenDayAvg.sodium
            ),
          ],
        ),

      ],
      animate: true,
      domainAxis: const charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(labelRotation: 60),
      ),
      barGroupingType: charts.BarGroupingType.grouped,
    );
  }

}


