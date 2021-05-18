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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wger/helpers/json.dart';
import 'package:wger/helpers/ui.dart';
import 'package:wger/models/exercises/exercise.dart';
import 'package:wger/models/http_exception.dart';
import 'package:wger/models/workouts/day.dart';
import 'package:wger/models/workouts/log.dart';
import 'package:wger/models/workouts/session.dart';
import 'package:wger/models/workouts/setting.dart';
import 'package:wger/models/workouts/workout_plan.dart';
import 'package:wger/providers/exercises.dart';
import 'package:wger/providers/workout_plans.dart';
import 'package:wger/theme/theme.dart';
import 'package:wger/widgets/exercises/images.dart';
import 'package:wger/widgets/workouts/forms.dart';

class GymMode extends StatefulWidget {
  final Day _workoutDay;
  late TimeOfDay _start;

  GymMode(this._workoutDay) {
    _start = TimeOfDay.now();
  }

  @override
  _GymModeState createState() => _GymModeState();
}

class _GymModeState extends State<GymMode> {
  var _totalElements = 1;

  PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Calculate amount of elements for progress indicator
    for (var set in widget._workoutDay.sets) {
      _totalElements = _totalElements + set.settingsComputed.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    final exerciseProvider = Provider.of<ExercisesProvider>(context, listen: false);
    final workoutProvider = Provider.of<WorkoutPlansProvider>(context, listen: false);
    var currentElement = 1;
    List<Widget> out = [];

    // Build the list of exercise overview, sets and pause pages
    for (var set in widget._workoutDay.sets) {
      var firstPage = true;
      for (var setting in set.settingsComputed) {
        var ratioCompleted = currentElement / _totalElements;
        currentElement++;
        if (firstPage) {
          out.add(ExerciseOverview(
            _controller,
            exerciseProvider.findById(setting.exerciseId),
            ratioCompleted,
          ));
        }
        out.add(LogPage(
          _controller,
          setting,
          exerciseProvider.findById(setting.exerciseId),
          workoutProvider.findById(widget._workoutDay.workoutId),
          ratioCompleted,
        ));
        out.add(TimerWidget(_controller, ratioCompleted));
        firstPage = false;
      }
    }

    return PageView(
      controller: _controller,
      children: [
        StartPage(
          _controller,
          widget._workoutDay,
        ),
        ...out,
        SessionPage(
          workoutProvider.findById(widget._workoutDay.workoutId),
          _controller,
          widget._start,
        ),
      ],
    );
  }
}

class StartPage extends StatelessWidget {
  PageController _controller;
  final Day _day;

  StartPage(this._controller, this._day);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              AppLocalizations.of(context)!.todaysWorkout,
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          Divider(),
          Expanded(
            child: ListView(
              children: [
                ..._day.sets.map(
                  (set) {
                    return Column(
                      children: [
                        ...set.settingsFiltered.map((s) {
                          return Column(
                            children: [
                              Text(
                                s.exerciseObj.name,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              ...set.getSmartRepr(s.exerciseObj).map((e) => Text(e)).toList(),
                              SizedBox(height: 15),
                            ],
                          );
                        }).toList(),
                      ],
                    );
                  },
                ).toList(),
              ],
            ),
          ),
          ElevatedButton(
            child: Text(AppLocalizations.of(context)!.start),
            onPressed: () {
              _controller.nextPage(duration: Duration(milliseconds: 200), curve: Curves.bounceIn);
            },
          ),
          NavigationFooter(
            _controller,
            0,
            showPrevious: false,
          ),
        ],
      ),
    );
  }
}

class LogPage extends StatefulWidget {
  PageController _controller;
  Setting _setting;
  Exercise _exercise;
  WorkoutPlan _workoutPlan;
  final double _ratioCompleted;
  Log _log = Log.empty();

  LogPage(
      this._controller, this._setting, this._exercise, this._workoutPlan, this._ratioCompleted) {
    _log.date = DateTime.now();
    _log.workoutPlan = _workoutPlan.id!;
    _log.exercise = _exercise;
    _log.weightUnit = _setting.weightUnitObj;
    _log.repetitionUnit = _setting.repetitionUnitObj;
  }

  @override
  _LogPageState createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  final _form = GlobalKey<FormState>();
  String rirValue = Setting.DEFAULT_RIR;
  final _repsController = TextEditingController();
  final _weightController = TextEditingController();
  final _rirController = TextEditingController();
  var _detailed = false;

  @override
  void initState() {
    super.initState();

    if (widget._setting.reps != null) {
      _repsController.text = widget._setting.reps.toString();
    }

    if (widget._setting.weight != null) {
      _weightController.text = widget._setting.weight.toString();
    }

    if (widget._setting.rir != null) {
      _rirController.text = widget._setting.rir!;
    }
  }

  Widget getRepsWidget() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.repetitions,
        prefixIcon: IconButton(
          icon: Icon(
            Icons.add,
            color: Colors.black,
          ),
          onPressed: () {
            try {
              int newValue = int.parse(_repsController.text) + 1;
              _repsController.text = newValue.toString();
            } on FormatException catch (e) {}
          },
        ),
        suffixIcon: IconButton(
          icon: Icon(
            Icons.remove,
            color: Colors.black,
          ),
          onPressed: () {
            try {
              int newValue = int.parse(_repsController.text) - 1;
              if (newValue > 0) {
                _repsController.text = newValue.toString();
              }
            } on FormatException catch (e) {}
          },
        ),
      ),
      enabled: true,
      controller: _repsController,
      keyboardType: TextInputType.number,
      onFieldSubmitted: (_) {},
      onSaved: (newValue) {
        widget._log.reps = int.parse(newValue!);
      },
      validator: (value) {
        try {
          int.parse(value!);
        } catch (error) {
          return AppLocalizations.of(context)!.enterValidNumber;
        }
        return null;
      },
    );
  }

  Widget getWeightWidget() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.weight,
        prefixIcon: IconButton(
          icon: Icon(
            Icons.add,
            color: Colors.black,
          ),
          onPressed: () {
            try {
              double newValue = double.parse(_weightController.text) + 1.25;
              _weightController.text = newValue.toString();
            } on FormatException catch (e) {}
          },
        ),
        suffixIcon: IconButton(
          icon: Icon(
            Icons.remove,
            color: Colors.black,
          ),
          onPressed: () {
            try {
              double newValue = double.parse(_weightController.text) - 1.25;
              if (newValue > 0) {
                _weightController.text = newValue.toString();
              }
            } on FormatException catch (e) {}
          },
        ),
      ),
      controller: _weightController,
      keyboardType: TextInputType.number,
      onFieldSubmitted: (_) {},
      onSaved: (newValue) {
        widget._log.weight = double.parse(newValue!);
      },
      validator: (value) {
        try {
          double.parse(value!);
        } catch (error) {
          return AppLocalizations.of(context)!.enterValidNumber;
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              widget._exercise.name,
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
          ),
          Divider(),
          Center(
            child: Text(
              '${widget._setting.singleSettingRepText}',
              style: Theme.of(context).textTheme.headline3,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
              child: (widget._workoutPlan.filterLogsByExercise(widget._exercise).length > 0)
                  ? ListView(
                      children: [
                        Text(
                          'Logs',
                          style: Theme.of(context).textTheme.headline6,
                          textAlign: TextAlign.center,
                        ),
                        ...widget._workoutPlan.filterLogsByExercise(widget._exercise).map((log) {
                          return ListTile(
                            title: Text(log.singleLogRepText.replaceAll('\n', '')),
                            subtitle: Text(
                                DateFormat.yMd(Localizations.localeOf(context).languageCode)
                                    .format(log.date)),
                            trailing: Icon(Icons.arrow_forward),
                            onTap: () {
                              setState(() {
                                // Text field
                                _repsController.text = log.reps.toString();
                                _weightController.text = log.weight.toString();

                                // Drop downs
                                widget._log.rir = log.rir;
                                widget._log.repetitionUnit = log.repetitionUnitObj;
                                widget._log.weightUnit = log.weightUnitObj;
                              });
                            },
                            contentPadding: EdgeInsets.symmetric(horizontal: 40),
                          );
                        }).toList(),
                      ],
                    )
                  : Container()),
          SizedBox(height: 15),
          Form(
            key: _form,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_detailed)
                  Row(
                    children: [
                      Flexible(child: getRepsWidget()),
                      SizedBox(width: 8),
                      Flexible(child: getWeightWidget()),
                    ],
                  ),
                if (_detailed)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(child: getRepsWidget()),
                      SizedBox(width: 8),
                      Flexible(child: RepetitionUnitInputWidget(widget._log)),
                    ],
                  ),
                if (_detailed)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(child: getWeightWidget()),
                      SizedBox(width: 8),
                      Flexible(child: WeightUnitInputWidget(widget._log))
                    ],
                  ),
                if (_detailed) RiRInputWidget(widget._log),
                /*
                  TextFormField(
                    decoration: InputDecoration(labelText: AppLocalizations.of(context)!.comment),
                    controller: _commentController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    onFieldSubmitted: (_) {},
                    onSaved: (newValue) {
                      _log.
                    },
                  ),

                   */
                IconButton(
                  icon: Icon(_detailed ? Icons.unfold_less : Icons.unfold_more),
                  onPressed: () {
                    setState(() {
                      _detailed = !_detailed;
                    });
                  },
                ),
                ElevatedButton(
                  child: Text(AppLocalizations.of(context)!.save),
                  onPressed: () async {
                    // Validate and save the current values to the weightEntry
                    final isValid = _form.currentState!.validate();
                    if (!isValid) {
                      return;
                    }
                    _form.currentState!.save();

                    // Save the entry on the server
                    try {
                      await Provider.of<WorkoutPlansProvider>(context, listen: false)
                          .addLog(widget._log);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 2), // default is 4
                          content: Text(
                            AppLocalizations.of(context)!.successfullySaved,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                      widget._controller.nextPage(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.bounceIn,
                      );
                    } on WgerHttpException catch (error) {
                      showHttpExceptionErrorDialog(error, context);
                    } catch (error) {
                      showErrorDialog(error, context);
                    }
                  },
                ),
              ],
            ),
          ),
          NavigationFooter(widget._controller, widget._ratioCompleted),
        ],
      ),
    );
  }
}

class ExerciseOverview extends StatelessWidget {
  final PageController _controller;
  final Exercise _exercise;
  final double _ratioCompleted;

  ExerciseOverview(this._controller, this._exercise, this._ratioCompleted);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              _exercise.name,
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
          ),
          Divider(),
          Expanded(
            child: ListView(
              children: [
                Text(
                  _exercise.categoryObj.name,
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
                ..._exercise.equipment
                    .map((e) => Text(
                          e.name,
                          style: Theme.of(context).textTheme.headline6,
                          textAlign: TextAlign.center,
                        ))
                    .toList(),
                if (_exercise.images.length > 0)
                  Container(
                    width: double.infinity,
                    height: 200,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        ..._exercise.images.map((e) => ExerciseImageWidget(image: e)).toList(),
                      ],
                    ),
                  ),
                Html(data: _exercise.description),
              ],
            ),
          ),
          NavigationFooter(_controller, _ratioCompleted),
        ],
      ),
    );
  }
}

class SessionPage extends StatefulWidget {
  WorkoutPlan _workoutPlan;
  PageController _controller;
  TimeOfDay _start;

  SessionPage(this._workoutPlan, this._controller, this._start);

  @override
  _SessionPageState createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  final _form = GlobalKey<FormState>();
  final impressionController = TextEditingController();
  final notesController = TextEditingController();
  final timeStartController = TextEditingController();
  final timeEndController = TextEditingController();

  int impressionValue = 2;
  var _session = WorkoutSession();

  @override
  void initState() {
    super.initState();

    timeStartController.text = timeToString(widget._start)!;
    timeEndController.text = timeToString(TimeOfDay.now())!;
    _session.workoutId = widget._workoutPlan.id!;
    _session.date = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              AppLocalizations.of(context)!.workoutSession,
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Divider(),
          Expanded(child: Container()),
          Form(
            key: _form,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButtonFormField(
                  value: impressionValue,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.impression,
                  ),
                  items: IMPRESSION_MAP.keys.map<DropdownMenuItem<int>>((int key) {
                    return DropdownMenuItem<int>(
                      value: key,
                      child: Text(IMPRESSION_MAP[key]!),
                    );
                  }).toList(),
                  onSaved: (int? newValue) {
                    _session.impression = newValue!;
                  },
                  onChanged: (int? newValue) {
                    setState(() {
                      impressionValue = newValue!;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.notes,
                  ),
                  maxLines: 3,
                  controller: notesController,
                  keyboardType: TextInputType.multiline,
                  onFieldSubmitted: (_) {},
                  onSaved: (newValue) {
                    _session.notes = newValue!;
                  },
                ),
                Row(
                  children: [
                    Flexible(
                      child: TextFormField(
                        decoration:
                            InputDecoration(labelText: AppLocalizations.of(context)!.timeStart),
                        controller: timeStartController,
                        onFieldSubmitted: (_) {},
                        onTap: () async {
                          // Stop keyboard from appearing
                          FocusScope.of(context).requestFocus(new FocusNode());

                          // Open time picker
                          var pickedTime = await showTimePicker(
                            context: context,
                            initialTime: widget._start,
                          );

                          timeStartController.text = timeToString(pickedTime)!;
                        },
                        onSaved: (newValue) {
                          _session.timeStart = stringToTime(newValue);
                        },
                      ),
                    ),
                    Flexible(
                      child: TextFormField(
                        decoration:
                            InputDecoration(labelText: AppLocalizations.of(context)!.timeEnd),
                        controller: timeEndController,
                        onFieldSubmitted: (_) {},
                        onTap: () async {
                          // Stop keyboard from appearing
                          FocusScope.of(context).requestFocus(new FocusNode());

                          // Open time picker
                          var pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );

                          timeStartController.text = timeToString(pickedTime)!;
                        },
                        onSaved: (newValue) {
                          _session.timeEnd = stringToTime(newValue);
                        },
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  child: Text(AppLocalizations.of(context)!.save),
                  onPressed: () async {
                    // Validate and save the current values to the weightEntry
                    final isValid = _form.currentState!.validate();
                    if (!isValid) {
                      return;
                    }
                    _form.currentState!.save();

                    // Save the entry on the server
                    try {
                      await Provider.of<WorkoutPlansProvider>(context, listen: false)
                          .addSession(_session);
                      Navigator.of(context).pop();
                    } on WgerHttpException catch (error) {
                      showHttpExceptionErrorDialog(error, context);
                    } catch (error) {
                      showErrorDialog(error, context);
                    }
                  },
                ),
              ],
            ),
          ),
          NavigationFooter(
            widget._controller,
            1,
            showNext: false,
          ),
        ],
      ),
    );
  }
}

class TimerWidget extends StatefulWidget {
  final PageController _controller;
  final double _ratioCompleted;

  TimerWidget(this._controller, this._ratioCompleted);

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  // See https://stackoverflow.com/questions/54610121/flutter-countdown-timer

  Timer? _timer;
  int _seconds = 1;
  final _maxSeconds = 600;
  DateTime today = new DateTime(2000, 1, 1, 0, 0, 0);

  void startTimer() {
    setState(() {
      _seconds = 0;
    });

    _timer?.cancel();

    const oneSecond = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSecond,
      (Timer timer) {
        if (_seconds == _maxSeconds) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _seconds++;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                DateFormat('m:ss').format(today.add(Duration(seconds: _seconds))),
                style: Theme.of(context).textTheme.headline1!.copyWith(color: wgerPrimaryColor),
              ),
            ),
          ),
          NavigationFooter(widget._controller, widget._ratioCompleted),
        ],
      ),
    );
  }
}

class NavigationFooter extends StatelessWidget {
  final PageController _controller;
  final double _ratioCompleted;
  final bool showPrevious;
  final bool showNext;

  NavigationFooter(this._controller, this._ratioCompleted,
      {this.showPrevious = true, this.showNext = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 30),
        LinearProgressIndicator(
          minHeight: 1.5,
          value: _ratioCompleted,
          valueColor: AlwaysStoppedAnimation<Color>(wgerPrimaryColor),
          backgroundColor: Colors.white,
        ),
        Row(
          children: [
            // Nest all widgets in an expanded so that they all take the same size
            // independently of how wide they are so that the buttons are positioned
            // always on the same spot

            Expanded(
              child: showPrevious
                  ? IconButton(
                      icon: Icon(Icons.chevron_left),
                      onPressed: () {
                        _controller.previousPage(
                            duration: Duration(milliseconds: 200), curve: Curves.bounceIn);
                      },
                    )
                  : Container(),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            Expanded(
              child: showNext
                  ? IconButton(
                      icon: Icon(Icons.chevron_right),
                      onPressed: () {
                        _controller.nextPage(
                            duration: Duration(milliseconds: 200), curve: Curves.bounceIn);
                      },
                    )
                  : Container(),
            ),
          ],
        ),
      ],
    );
  }
}
