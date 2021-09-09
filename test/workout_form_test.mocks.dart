// Mocks generated by Mockito 5.0.15 from annotations
// in wger/test/workout_form_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i13;
import 'dart:ui' as _i15;

import 'package:http/http.dart' as _i5;
import 'package:mockito/mockito.dart' as _i1;
import 'package:wger/models/exercises/exercise.dart' as _i14;
import 'package:wger/models/workouts/day.dart' as _i7;
import 'package:wger/models/workouts/log.dart' as _i11;
import 'package:wger/models/workouts/repetition_unit.dart' as _i3;
import 'package:wger/models/workouts/session.dart' as _i10;
import 'package:wger/models/workouts/set.dart' as _i8;
import 'package:wger/models/workouts/setting.dart' as _i9;
import 'package:wger/models/workouts/weight_unit.dart' as _i2;
import 'package:wger/models/workouts/workout_plan.dart' as _i6;
import 'package:wger/providers/auth.dart' as _i4;
import 'package:wger/providers/workout_plans.dart' as _i12;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

class _FakeWeightUnit_0 extends _i1.Fake implements _i2.WeightUnit {}

class _FakeRepetitionUnit_1 extends _i1.Fake implements _i3.RepetitionUnit {}

class _FakeAuthProvider_2 extends _i1.Fake implements _i4.AuthProvider {}

class _FakeClient_3 extends _i1.Fake implements _i5.Client {}

class _FakeWorkoutPlan_4 extends _i1.Fake implements _i6.WorkoutPlan {}

class _FakeDay_5 extends _i1.Fake implements _i7.Day {}

class _FakeSet_6 extends _i1.Fake implements _i8.Set {}

class _FakeSetting_7 extends _i1.Fake implements _i9.Setting {}

class _FakeWorkoutSession_8 extends _i1.Fake implements _i10.WorkoutSession {}

class _FakeLog_9 extends _i1.Fake implements _i11.Log {}

class _FakeUri_10 extends _i1.Fake implements Uri {}

class _FakeResponse_11 extends _i1.Fake implements _i5.Response {}

/// A class which mocks [WorkoutPlansProvider].
///
/// See the documentation for Mockito's code generation for more information.
class MockWorkoutPlansProvider extends _i1.Mock implements _i12.WorkoutPlansProvider {
  MockWorkoutPlansProvider() {
    _i1.throwOnMissingStub(this);
  }

  @override
  List<_i6.WorkoutPlan> get items =>
      (super.noSuchMethod(Invocation.getter(#items), returnValue: <_i6.WorkoutPlan>[])
          as List<_i6.WorkoutPlan>);
  @override
  List<_i2.WeightUnit> get weightUnits =>
      (super.noSuchMethod(Invocation.getter(#weightUnits), returnValue: <_i2.WeightUnit>[])
          as List<_i2.WeightUnit>);
  @override
  _i2.WeightUnit get defaultWeightUnit =>
      (super.noSuchMethod(Invocation.getter(#defaultWeightUnit), returnValue: _FakeWeightUnit_0())
          as _i2.WeightUnit);
  @override
  List<_i3.RepetitionUnit> get repetitionUnits =>
      (super.noSuchMethod(Invocation.getter(#repetitionUnits), returnValue: <_i3.RepetitionUnit>[])
          as List<_i3.RepetitionUnit>);
  @override
  _i3.RepetitionUnit get defaultRepetitionUnit =>
      (super.noSuchMethod(Invocation.getter(#defaultRepetitionUnit),
          returnValue: _FakeRepetitionUnit_1()) as _i3.RepetitionUnit);
  @override
  _i4.AuthProvider get auth =>
      (super.noSuchMethod(Invocation.getter(#auth), returnValue: _FakeAuthProvider_2())
          as _i4.AuthProvider);
  @override
  set auth(_i4.AuthProvider? _auth) =>
      super.noSuchMethod(Invocation.setter(#auth, _auth), returnValueForMissingStub: null);
  @override
  _i5.Client get client =>
      (super.noSuchMethod(Invocation.getter(#client), returnValue: _FakeClient_3()) as _i5.Client);
  @override
  set client(_i5.Client? _client) =>
      super.noSuchMethod(Invocation.setter(#client, _client), returnValueForMissingStub: null);
  @override
  bool get hasListeners =>
      (super.noSuchMethod(Invocation.getter(#hasListeners), returnValue: false) as bool);
  @override
  _i6.WorkoutPlan findById(int? id) =>
      (super.noSuchMethod(Invocation.method(#findById, [id]), returnValue: _FakeWorkoutPlan_4())
          as _i6.WorkoutPlan);
  @override
  int findIndexById(int? id) =>
      (super.noSuchMethod(Invocation.method(#findIndexById, [id]), returnValue: 0) as int);
  @override
  void setCurrentPlan(int? id) =>
      super.noSuchMethod(Invocation.method(#setCurrentPlan, [id]), returnValueForMissingStub: null);
  @override
  void resetCurrentPlan() =>
      super.noSuchMethod(Invocation.method(#resetCurrentPlan, []), returnValueForMissingStub: null);
  @override
  _i13.Future<void> fetchAndSetAllPlansFull() =>
      (super.noSuchMethod(Invocation.method(#fetchAndSetAllPlansFull, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i13.Future<void>);
  @override
  _i13.Future<void> fetchAndSetAllPlansSparse() =>
      (super.noSuchMethod(Invocation.method(#fetchAndSetAllPlansSparse, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i13.Future<void>);
  @override
  _i13.Future<_i6.WorkoutPlan> fetchAndSetPlanSparse(int? planId) =>
      (super.noSuchMethod(Invocation.method(#fetchAndSetPlanSparse, [planId]),
              returnValue: Future<_i6.WorkoutPlan>.value(_FakeWorkoutPlan_4()))
          as _i13.Future<_i6.WorkoutPlan>);
  @override
  _i13.Future<_i6.WorkoutPlan> fetchAndSetWorkoutPlanFull(int? workoutId) =>
      (super.noSuchMethod(Invocation.method(#fetchAndSetWorkoutPlanFull, [workoutId]),
              returnValue: Future<_i6.WorkoutPlan>.value(_FakeWorkoutPlan_4()))
          as _i13.Future<_i6.WorkoutPlan>);
  @override
  _i13.Future<_i6.WorkoutPlan> addWorkout(_i6.WorkoutPlan? workout) =>
      (super.noSuchMethod(Invocation.method(#addWorkout, [workout]),
              returnValue: Future<_i6.WorkoutPlan>.value(_FakeWorkoutPlan_4()))
          as _i13.Future<_i6.WorkoutPlan>);
  @override
  _i13.Future<void> editWorkout(_i6.WorkoutPlan? workout) =>
      (super.noSuchMethod(Invocation.method(#editWorkout, [workout]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i13.Future<void>);
  @override
  _i13.Future<void> deleteWorkout(int? id) =>
      (super.noSuchMethod(Invocation.method(#deleteWorkout, [id]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i13.Future<void>);
  @override
  _i13.Future<Map<String, dynamic>> fetchLogData(
          _i6.WorkoutPlan? workout, _i14.Exercise? exercise) =>
      (super.noSuchMethod(Invocation.method(#fetchLogData, [workout, exercise]),
              returnValue: Future<Map<String, dynamic>>.value(<String, dynamic>{}))
          as _i13.Future<Map<String, dynamic>>);
  @override
  _i13.Future<void> fetchAndSetRepetitionUnits() =>
      (super.noSuchMethod(Invocation.method(#fetchAndSetRepetitionUnits, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i13.Future<void>);
  @override
  _i13.Future<void> fetchAndSetWeightUnits() =>
      (super.noSuchMethod(Invocation.method(#fetchAndSetWeightUnits, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i13.Future<void>);
  @override
  _i13.Future<void> fetchAndSetUnits() =>
      (super.noSuchMethod(Invocation.method(#fetchAndSetUnits, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i13.Future<void>);
  @override
  _i13.Future<_i7.Day> addDay(_i7.Day? day, _i6.WorkoutPlan? workout) =>
      (super.noSuchMethod(Invocation.method(#addDay, [day, workout]),
          returnValue: Future<_i7.Day>.value(_FakeDay_5())) as _i13.Future<_i7.Day>);
  @override
  _i13.Future<void> editDay(_i7.Day? day) => (super.noSuchMethod(Invocation.method(#editDay, [day]),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i13.Future<void>);
  @override
  _i13.Future<void> deleteDay(_i7.Day? day) =>
      (super.noSuchMethod(Invocation.method(#deleteDay, [day]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i13.Future<void>);
  @override
  _i13.Future<_i8.Set> addSet(_i8.Set? workoutSet) =>
      (super.noSuchMethod(Invocation.method(#addSet, [workoutSet]),
          returnValue: Future<_i8.Set>.value(_FakeSet_6())) as _i13.Future<_i8.Set>);
  @override
  _i13.Future<void> editSet(_i8.Set? workoutSet) =>
      (super.noSuchMethod(Invocation.method(#editSet, [workoutSet]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i13.Future<void>);
  @override
  _i13.Future<List<_i8.Set>> reorderSets(List<_i8.Set>? sets, int? startIndex) =>
      (super.noSuchMethod(Invocation.method(#reorderSets, [sets, startIndex]),
          returnValue: Future<List<_i8.Set>>.value(<_i8.Set>[])) as _i13.Future<List<_i8.Set>>);
  @override
  _i13.Future<void> fetchComputedSettings(_i8.Set? workoutSet) =>
      (super.noSuchMethod(Invocation.method(#fetchComputedSettings, [workoutSet]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i13.Future<void>);
  @override
  _i13.Future<String> fetchSmartText(_i8.Set? workoutSet, _i14.Exercise? exercise) =>
      (super.noSuchMethod(Invocation.method(#fetchSmartText, [workoutSet, exercise]),
          returnValue: Future<String>.value('')) as _i13.Future<String>);
  @override
  _i13.Future<void> deleteSet(_i8.Set? workoutSet) =>
      (super.noSuchMethod(Invocation.method(#deleteSet, [workoutSet]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i13.Future<void>);
  @override
  _i13.Future<_i9.Setting> addSetting(_i9.Setting? workoutSetting) =>
      (super.noSuchMethod(Invocation.method(#addSetting, [workoutSetting]),
          returnValue: Future<_i9.Setting>.value(_FakeSetting_7())) as _i13.Future<_i9.Setting>);
  @override
  _i13.Future<dynamic> fetchSessionData() =>
      (super.noSuchMethod(Invocation.method(#fetchSessionData, []),
          returnValue: Future<dynamic>.value()) as _i13.Future<dynamic>);
  @override
  _i13.Future<_i10.WorkoutSession> addSession(_i10.WorkoutSession? session) =>
      (super.noSuchMethod(Invocation.method(#addSession, [session]),
              returnValue: Future<_i10.WorkoutSession>.value(_FakeWorkoutSession_8()))
          as _i13.Future<_i10.WorkoutSession>);
  @override
  _i13.Future<_i11.Log> addLog(_i11.Log? log) =>
      (super.noSuchMethod(Invocation.method(#addLog, [log]),
          returnValue: Future<_i11.Log>.value(_FakeLog_9())) as _i13.Future<_i11.Log>);
  @override
  Uri makeUrl(String? path, {int? id, String? objectMethod, Map<String, dynamic>? query}) =>
      (super.noSuchMethod(
          Invocation.method(
              #makeUrl, [path], {#id: id, #objectMethod: objectMethod, #query: query}),
          returnValue: _FakeUri_10()) as Uri);
  @override
  _i13.Future<Map<String, dynamic>> fetch(Uri? uri) =>
      (super.noSuchMethod(Invocation.method(#fetch, [uri]),
              returnValue: Future<Map<String, dynamic>>.value(<String, dynamic>{}))
          as _i13.Future<Map<String, dynamic>>);
  @override
  _i13.Future<Map<String, dynamic>> post(Map<String, dynamic>? data, Uri? uri) =>
      (super.noSuchMethod(Invocation.method(#post, [data, uri]),
              returnValue: Future<Map<String, dynamic>>.value(<String, dynamic>{}))
          as _i13.Future<Map<String, dynamic>>);
  @override
  _i13.Future<Map<String, dynamic>> patch(Map<String, dynamic>? data, Uri? uri) =>
      (super.noSuchMethod(Invocation.method(#patch, [data, uri]),
              returnValue: Future<Map<String, dynamic>>.value(<String, dynamic>{}))
          as _i13.Future<Map<String, dynamic>>);
  @override
  _i13.Future<_i5.Response> deleteRequest(String? url, int? id) => (super.noSuchMethod(
      Invocation.method(#deleteRequest, [url, id]),
      returnValue: Future<_i5.Response>.value(_FakeResponse_11())) as _i13.Future<_i5.Response>);
  @override
  String toString() => super.toString();
  @override
  void addListener(_i15.VoidCallback? listener) => super
      .noSuchMethod(Invocation.method(#addListener, [listener]), returnValueForMissingStub: null);
  @override
  void removeListener(_i15.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#removeListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void dispose() =>
      super.noSuchMethod(Invocation.method(#dispose, []), returnValueForMissingStub: null);
  @override
  void notifyListeners() =>
      super.noSuchMethod(Invocation.method(#notifyListeners, []), returnValueForMissingStub: null);
}
