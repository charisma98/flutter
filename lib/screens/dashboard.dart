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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wger/providers/exercises.dart';
import 'package:wger/widgets/core/app_bar.dart';
import 'package:wger/widgets/dashboard/calendar.dart';
import 'package:wger/widgets/dashboard/widgets.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WgerAppBar(AppLocalizations.of(context).labelDashboard),
      body: SingleChildScrollView(
        child: Column(
          children: [
            IconButton(
              onPressed: () {
                Provider.of<ExercisesProvider>(context, listen: false).fetchAndSetExercisesTEST();
              },
              icon: Icon(Icons.update),
            ),
            DashboardWorkoutWidget(),
            DashboardNutritionWidget(),
            DashboardWeightWidget(),
            DashboardCalendarWidget(),
          ],
        ),
      ),
    );
  }
}
