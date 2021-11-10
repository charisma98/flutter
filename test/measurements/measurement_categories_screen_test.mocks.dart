// Mocks generated by Mockito 5.0.16 from annotations
// in wger/test/measurements/measurement_categories_screen_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i5;
import 'dart:ui' as _i7;

import 'package:mockito/mockito.dart' as _i1;
import 'package:wger/models/measurements/measurement_category.dart' as _i3;
import 'package:wger/models/measurements/measurement_entry.dart' as _i6;
import 'package:wger/providers/base_provider.dart' as _i2;
import 'package:wger/providers/measurement.dart' as _i4;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeWgerBaseProvider_0 extends _i1.Fake implements _i2.WgerBaseProvider {
}

class _FakeMeasurementCategory_1 extends _i1.Fake
    implements _i3.MeasurementCategory {}

/// A class which mocks [MeasurementProvider].
///
/// See the documentation for Mockito's code generation for more information.
class MockMeasurementProvider extends _i1.Mock
    implements _i4.MeasurementProvider {
  MockMeasurementProvider() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.WgerBaseProvider get baseProvider =>
      (super.noSuchMethod(Invocation.getter(#baseProvider),
          returnValue: _FakeWgerBaseProvider_0()) as _i2.WgerBaseProvider);
  @override
  List<_i3.MeasurementCategory> get categories =>
      (super.noSuchMethod(Invocation.getter(#categories),
              returnValue: <_i3.MeasurementCategory>[])
          as List<_i3.MeasurementCategory>);
  @override
  bool get hasListeners =>
      (super.noSuchMethod(Invocation.getter(#hasListeners), returnValue: false)
          as bool);
  @override
  void clear() => super.noSuchMethod(Invocation.method(#clear, []),
      returnValueForMissingStub: null);
  @override
  _i3.MeasurementCategory findCategoryById(int? id) => (super.noSuchMethod(
      Invocation.method(#findCategoryById, [id]),
      returnValue: _FakeMeasurementCategory_1()) as _i3.MeasurementCategory);
  @override
  _i5.Future<void> fetchAndSetCategories() =>
      (super.noSuchMethod(Invocation.method(#fetchAndSetCategories, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i5.Future<void>);
  @override
  _i5.Future<void> fetchAndSetCategoryEntries(int? id) =>
      (super.noSuchMethod(Invocation.method(#fetchAndSetCategoryEntries, [id]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i5.Future<void>);
  @override
  _i5.Future<void> fetchAndSetAllCategoriesAndEntries() => (super.noSuchMethod(
      Invocation.method(#fetchAndSetAllCategoriesAndEntries, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i5.Future<void>);
  @override
  _i5.Future<void> addCategory(_i3.MeasurementCategory? category) =>
      (super.noSuchMethod(Invocation.method(#addCategory, [category]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i5.Future<void>);
  @override
  _i5.Future<void> deleteCategory(int? id) =>
      (super.noSuchMethod(Invocation.method(#deleteCategory, [id]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i5.Future<void>);
  @override
  _i5.Future<void> editCategory(int? id, String? newName, String? newUnit) =>
      (super.noSuchMethod(
          Invocation.method(#editCategory, [id, newName, newUnit]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i5.Future<void>);
  @override
  _i5.Future<void> addEntry(_i6.MeasurementEntry? entry) =>
      (super.noSuchMethod(Invocation.method(#addEntry, [entry]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i5.Future<void>);
  @override
  _i5.Future<void> deleteEntry(int? id, int? categoryId) =>
      (super.noSuchMethod(Invocation.method(#deleteEntry, [id, categoryId]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i5.Future<void>);
  @override
  _i5.Future<void> editEntry(int? id, int? categoryId, num? newValue,
          String? newNotes, DateTime? newDate) =>
      (super.noSuchMethod(
          Invocation.method(
              #editEntry, [id, categoryId, newValue, newNotes, newDate]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i5.Future<void>);
  @override
  String toString() => super.toString();
  @override
  void addListener(_i7.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#addListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void removeListener(_i7.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#removeListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void dispose() => super.noSuchMethod(Invocation.method(#dispose, []),
      returnValueForMissingStub: null);
  @override
  void notifyListeners() =>
      super.noSuchMethod(Invocation.method(#notifyListeners, []),
          returnValueForMissingStub: null);
}
