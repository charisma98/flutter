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

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wger/helpers/consts.dart';
import 'package:wger/models/exercises/category.dart';
import 'package:wger/models/exercises/equipment.dart';
import 'package:wger/models/exercises/exercise.dart';
import 'package:wger/models/exercises/muscle.dart';
import 'package:wger/exceptions/http_exception.dart';
import 'package:wger/providers/auth.dart';
import 'package:wger/providers/base_provider.dart';

class ExercisesProvider extends WgerBaseProvider with ChangeNotifier {
  static const daysToCache = 7;

  static const _exerciseInfoUrlPath = 'exerciseinfo';
  static const _exerciseSearchPath = 'exercise/search';

  static const _exerciseCommentUrlPath = 'exercisecomment';
  static const _exerciseImagesUrlPath = 'exerciseimage';
  static const _categoriesUrlPath = 'exercisecategory';
  static const _musclesUrlPath = 'muscle';
  static const _equipmentUrlPath = 'equipment';

  List<Exercise> _exercises = [];
  List<ExerciseCategory> _categories = [];
  List<Muscle> _muscles = [];
  List<Equipment> _equipment = [];
  Filters? _filters;

  ExercisesProvider(AuthProvider auth, List<Exercise> entries, [http.Client? client])
      : this._exercises = entries,
        super(auth, client);

  List<Exercise> get items => [..._exercises];
  List<ExerciseCategory> get categories => [..._categories];
  Filters? get filters => _filters;

  // Initialze filters for exersices search in exersices list
  void initFilters() {
    if (_muscles.isEmpty || _equipment.isEmpty || _filters != null) return;

    _filters = Filters(
      exerciseCategories: FilterCategory<ExerciseCategory>(
        title: 'Muscle Groups',
        items: Map.fromEntries(
          _categories.map(
            (category) => MapEntry<ExerciseCategory, bool>(category, false),
          ),
        ),
      ),
      equipment: FilterCategory<Equipment>(
        title: 'Equipment',
        items: Map.fromEntries(
          _equipment.map(
            (singleEquipment) => MapEntry<Equipment, bool>(singleEquipment, false),
          ),
        ),
      ),
    );
  }

  List<Exercise> findByFilters() {
    // Filters not initalized
    if (filters == null) return [];

    // Filters are initialized but nothing is marked
    if (filters!.isNothingMarked) return items;

    // Filter by exercise category and equipment (REPLACE WITH HTTP REQUEST)
    return items
        .where((exercise) => filters!.exerciseCategories.selected.contains(exercise.categoryObj))
        .toList();
  }

  List<Exercise> findByCategory(ExerciseCategory? category) {
    if (category == null) return this.items;
    return this.items.where((exercise) => exercise.categoryObj == category).toList();
  }

  /// Returns an exercise
  Exercise findById(int exerciseId) {
    return _exercises.firstWhere((exercise) => exercise.id == exerciseId);
  }

  Future<void> fetchAndSetCategories() async {
    final response = await client.get(makeUrl(_categoriesUrlPath));
    final categories = json.decode(response.body) as Map<String, dynamic>;
    try {
      for (final category in categories['results']) {
        _categories.add(ExerciseCategory.fromJson(category));
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchAndSetMuscles() async {
    final response = await client.get(makeUrl(_musclesUrlPath));
    final muscles = json.decode(response.body) as Map<String, dynamic>;
    try {
      for (final muscle in muscles['results']) {
        _muscles.add(Muscle.fromJson(muscle));
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchAndSetEquipment() async {
    final response = await client.get(makeUrl(_equipmentUrlPath));
    final equipments = json.decode(response.body) as Map<String, dynamic>;
    try {
      for (final equipment in equipments['results']) {
        _equipment.add(Equipment.fromJson(equipment));
      }
    } catch (error) {
      throw (error);
    }
  }

  /// Returns the exercise with the given ID
  ///
  /// If the exercise is not known locally, it is fetched from the server.
  /// This method is called when a workout is first loaded, after that the
  /// regular not-async getById method can be used
  Future<Exercise> fetchAndSetExercise(int exerciseId) async {
    try {
      return findById(exerciseId);
    } on StateError catch (e) {
      // Get exercise from the server and save to cache

      final data = await fetch(makeUrl(_exerciseInfoUrlPath, id: exerciseId));
      final exercise = Exercise.fromJson(data);
      _exercises.add(exercise);
      final prefs = await SharedPreferences.getInstance();
      final exerciseData = json.decode(prefs.getString(PREFS_EXERCISES)!);
      exerciseData['exercises'].add(exercise.toJson());
      prefs.setString(PREFS_EXERCISES, json.encode(exerciseData));
      log("Saved exercise '${exercise.name}' to cache.");
      return exercise;
    }
  }

  Future<void> fetchAndSetExercises() async {
    // Load exercises from cache, if available
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(PREFS_EXERCISES)) {
      final exerciseData = json.decode(prefs.getString(PREFS_EXERCISES)!);
      if (DateTime.parse(exerciseData['expiresIn']).isAfter(DateTime.now())) {
        exerciseData['exercises'].forEach((e) => _exercises.add(Exercise.fromJson(e)));
        exerciseData['equipment'].forEach((e) => _equipment.add(Equipment.fromJson(e)));
        exerciseData['muscles'].forEach((e) => _muscles.add(Muscle.fromJson(e)));
        exerciseData['categories'].forEach((e) => _categories.add(ExerciseCategory.fromJson(e)));
        log("Read ${exerciseData['exercises'].length} exercises from cache. Valid till ${exerciseData['expiresIn']}");
        return;
      }
    }

    // Load categories, muscles and equipments
    await fetchAndSetCategories();
    await fetchAndSetMuscles();
    await fetchAndSetEquipment();

    final response = await client.get(
        makeUrl(
          _exerciseInfoUrlPath,
          query: {'limit': '1000'},
        ),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        });
    final exercisesData = json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

    try {
      // Load exercises
      exercisesData['results'].forEach((e) => _exercises.add(Exercise.fromJson(e)));

      // Save the result to the cache
      final exerciseData = {
        'date': DateTime.now().toIso8601String(),
        'expiresIn': DateTime.now().add(Duration(days: daysToCache)).toIso8601String(),
        'exercises': _exercises.map((e) => e.toJson()).toList(),
        'equipment': _equipment.map((e) => e.toJson()).toList(),
        'categories': _categories.map((e) => e.toJson()).toList(),
        'muscles': _muscles.map((e) => e.toJson()).toList(),
      };
      log("Saved ${_exercises.length} exercises from cache. Valid till ${exerciseData['expiresIn']}");

      prefs.setString(PREFS_EXERCISES, json.encode(exerciseData));
      notifyListeners();
    } on MissingRequiredKeysException catch (error) {
      log(error.missingKeys.toString());
      throw (error);
    }
  }

  /// Searches for an exercise
  ///
  /// We could do this locally, but the server has better text searching capabilities
  /// with postgresql.
  Future<List> searchExercise(String name, [String languageCode = 'en']) async {
    if (name.length <= 1) {
      return [];
    }

    // Send the request
    final response = await client.get(
      makeUrl(
        _exerciseSearchPath,
        query: {'term': name, 'language': languageCode},
      ),
      headers: <String, String>{
        'Authorization': 'Token ${auth.token}',
        'User-Agent': auth.getAppNameHeader(),
      },
    );

    // Something wrong with our request
    if (response.statusCode >= 400) {
      throw WgerHttpException(response.body);
    }

    // Process the response
    final result = json.decode(utf8.decode(response.bodyBytes))['suggestions'] as List<dynamic>;
    for (var entry in result) {
      entry['exercise_obj'] = await fetchAndSetExercise(entry['data']['id']);
    }
    return result;
  }
}

class FilterCategory<T> {
  bool isExpanded;
  final Map<T, bool> items;
  final String title;

  List<T> get selected => [...items.keys].where((key) => items[key]!).toList();

  FilterCategory({
    required this.title,
    required this.items,
    this.isExpanded = false,
  });
}

class Filters {
  final FilterCategory<ExerciseCategory> exerciseCategories;
  final FilterCategory<Equipment> equipment;
  List<FilterCategory> get filterCategories => [exerciseCategories, equipment];

  bool get isNothingMarked {
    final isExersiceCategoryMarked = exerciseCategories.items.values.any((isMarked) => isMarked);
    final isEquipmentMarked = equipment.items.values.any((isMarked) => isMarked);
    return !isExersiceCategoryMarked && !isEquipmentMarked;
  }

  bool _doesNeedUpdate = false;
  bool get doesNeedUpdate => _doesNeedUpdate;

  void markNeedsUpdate() {
    _doesNeedUpdate = true;
  }

  void markUpdated() {
    _doesNeedUpdate = false;
  }

  Filters({
    required this.exerciseCategories,
    required this.equipment,
  });
}
