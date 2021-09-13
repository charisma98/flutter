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

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wger/exceptions/no_such_entry_exception.dart';
import 'package:wger/helpers/consts.dart';
import 'package:wger/models/exercises/base.dart';
import 'package:wger/models/exercises/category.dart';
import 'package:wger/models/exercises/equipment.dart';
import 'package:wger/models/exercises/exercise.dart';
import 'package:wger/models/exercises/language.dart';
import 'package:wger/models/exercises/muscle.dart';
import 'package:wger/providers/base_provider.dart';

class ExercisesProvider with ChangeNotifier {
  final WgerBaseProvider baseProvider;

  static const EXERCISE_CACHE_DAYS = 7;

  static const _exerciseInfoUrlPath = 'exerciseinfo';
  static const _exerciseBaseUrlPath = 'exercise-base';
  static const _exerciseUrlPath = 'exercise';
  static const _exerciseSearchPath = 'exercise/search';

  static const _exerciseCommentUrlPath = 'exercisecomment';
  static const _exerciseImagesUrlPath = 'exerciseimage';
  static const _categoriesUrlPath = 'exercisecategory';
  static const _musclesUrlPath = 'muscle';
  static const _equipmentUrlPath = 'equipment';
  static const _languageUrlPath = 'language';

  List<ExerciseBase> _exerciseBases = [];
  List<Exercise> _exercises = [];
  List<ExerciseCategory> _categories = [];
  List<Muscle> _muscles = [];
  List<Equipment> _equipment = [];
  List<Language> _languages = [];
  Filters? _filters;

  ExercisesProvider(this.baseProvider);

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
        .where((exercise) => filters!.exerciseCategories.selected.contains(exercise.category))
        .toList();
  }

  /// Clears all lists
  clear() {
    _equipment = [];
    _muscles = [];
    _categories = [];
    _languages = [];
    _exerciseBases = [];
  }

  List<Exercise> findByCategory(ExerciseCategory? category) {
    if (category == null) return this.items;
    return this.items.where((exercise) => exercise.category == category).toList();
  }

  /// Find exercise by ID
  Exercise findExerciseById(int id) {
    return _exercises.firstWhere(
      (exercise) => exercise.id == id,
      orElse: () => throw NoSuchEntryException(),
    );
  }

  /// Find category by ID
  ExerciseCategory findCategoryById(int id) {
    return _categories.firstWhere(
      (cat) => cat.id == id,
      orElse: () => throw NoSuchEntryException(),
    );
  }

  /// Find equipment by ID
  Equipment findEquipmentById(int id) {
    return _equipment.firstWhere(
      (equipment) => equipment.id == id,
      orElse: () => throw NoSuchEntryException(),
    );
  }

  /// Find muscle by ID
  Muscle findMuscleById(int id) {
    return _muscles.firstWhere(
      (muscle) => muscle.id == id,
      orElse: () => throw NoSuchEntryException(),
    );
  }

  /// Find language by ID
  Language findLanguageById(int id) {
    return _languages.firstWhere(
      (language) => language.id == id,
      orElse: () => throw NoSuchEntryException(),
    );
  }

  Future<void> fetchAndSetCategories() async {
    final categories = await baseProvider.fetch(baseProvider.makeUrl(_categoriesUrlPath));
    try {
      for (final category in categories['results']) {
        _categories.add(ExerciseCategory.fromJson(category));
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchAndSetMuscles() async {
    final muscles = await baseProvider.fetch(baseProvider.makeUrl(_musclesUrlPath));
    try {
      for (final muscle in muscles['results']) {
        _muscles.add(Muscle.fromJson(muscle));
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchAndSetEquipment() async {
    final equipments = await baseProvider.fetch(baseProvider.makeUrl(_equipmentUrlPath));
    try {
      for (final equipment in equipments['results']) {
        _equipment.add(Equipment.fromJson(equipment));
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchAndSetLanguages() async {
    final languageData = await baseProvider.fetch(baseProvider.makeUrl(_languageUrlPath));
    try {
      for (final language in languageData['results']) {
        _languages.add(Language.fromJson(language));
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
      return findExerciseById(exerciseId);
    } on NoSuchEntryException {
      // Get exercise from the server and save to cache

      // TODO: do this right (and save to cache)
      final exerciseTranslationData = await baseProvider.fetch(
        baseProvider.makeUrl(
          _exerciseUrlPath,
          id: exerciseId,
        ),
      );
      final exercise = Exercise.fromJson(exerciseTranslationData);

      final exerciseBaseData = await baseProvider.fetch(
        baseProvider.makeUrl(_exerciseBaseUrlPath, id: exercise.baseId),
      );
      final base = ExerciseBase.fromJson(exerciseBaseData);
      setExerciseBaseData(base, [exercise]);

      /*
      final prefs = await SharedPreferences.getInstance();

      final exerciseTranslationData = await baseProvider.fetch(
        baseProvider.makeUrl(
          _exerciseUrlPath,
          id: exerciseId,
        ),
      );

      final exercise = Exercise.fromJson(exerciseTranslationData);
      final exerciseBaseData = await baseProvider.fetch(
        baseProvider.makeUrl(_exerciseBaseUrlPath, id: exercise.baseId),
      );

      final base = setExerciseBaseData(ExerciseBase.fromJson(exerciseBaseData), [exercise]);

      //exerciseData['exercises'].add(exercise.toJson());
      //prefs.setString(PREFS_EXERCISES, json.encode(exerciseData));
      //log("Saved exercise '${exercise.name}' to cache.");

       */
      return exercise;
    }
  }

  /// Helper function that sets different objects such as category, etc.
  ExerciseBase setExerciseBaseData(ExerciseBase base, List<Exercise> exercises) {
    base.category = findCategoryById(base.categoryId);
    base.muscles = base.musclesIds.map((e) => findMuscleById(e)).toList();
    base.musclesSecondary = base.musclesSecondaryIds.map((e) => findMuscleById(e)).toList();
    base.equipment = base.equipmentIds.map((e) => findEquipmentById(e)).toList();

    exercises.forEach((e) {
      e.base = base;
      e.language = findLanguageById(e.languageId);
    });
    base.exercises = [];
    base.exercises = exercises;

    return base;
  }

  Future<void> fetchAndSetExercises() async {
    this.clear();
    print(Intl.getCurrentLocale());
    print(Intl.shortLocale(Intl.getCurrentLocale()));
    print('---------');
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(PREFS_EXERCISES)) {
      final cacheData = json.decode(prefs.getString(PREFS_EXERCISES)!);
      if (DateTime.parse(cacheData['expiresIn']).isAfter(DateTime.now())) {
        cacheData['equipment'].forEach((e) => _equipment.add(Equipment.fromJson(e)));
        cacheData['muscles'].forEach((e) => _muscles.add(Muscle.fromJson(e)));
        cacheData['categories'].forEach((e) => _categories.add(ExerciseCategory.fromJson(e)));
        cacheData['languages'].forEach((e) => _languages.add(Language.fromJson(e)));
        cacheData['exercise-translations'].forEach((e) => _exercises.add(Exercise.fromJson(e)));
        cacheData['bases'].forEach((e) {
          var base = setExerciseBaseData(
            ExerciseBase.fromJson(e),
            _exercises.where((element) => element.baseId == e['id']).toList(),
          );
          _exerciseBases.add(base);
        });
        log("Read ${_exerciseBases.length} exercises from cache. Valid till ${cacheData['expiresIn']}");
        return;
      }
    }

    // Load categories, muscles, equipment and languages
    await Future.wait([
      fetchAndSetCategories(),
      fetchAndSetMuscles(),
      fetchAndSetEquipment(),
      fetchAndSetLanguages(),
    ]);

    final exerciseBaseData = await baseProvider.fetch(
      baseProvider.makeUrl(_exerciseBaseUrlPath, query: {'limit': '1000'}),
    );
    final exerciseTranslationData = await baseProvider.fetch(
      baseProvider.makeUrl(
        _exerciseUrlPath,
        query: {'limit': '1000'},
      ),
    );

    List<Exercise> exerciseTranslation = exerciseTranslationData['results'].map<Exercise>((e) {
      return Exercise.fromJson(e);
    }).toList();

    for (var e in exerciseBaseData['results']) {
      var base = setExerciseBaseData(
        ExerciseBase.fromJson(e),
        exerciseTranslation.where((element) => element.baseId == e['id']).toList(),
      );
      _exerciseBases.add(base);
    }

    try {
      List<Exercise> exerciseTranslations = [];
      _exerciseBases.forEach((base) {
        base.exercises.forEach((exercise) {
          exerciseTranslations.add(exercise);
        });
      });

      // Save the result to the cache
      final cacheData = {
        'date': DateTime.now().toIso8601String(),
        'expiresIn': DateTime.now().add(Duration(days: EXERCISE_CACHE_DAYS)).toIso8601String(),
        'equipment': _equipment.map((e) => e.toJson()).toList(),
        'categories': _categories.map((e) => e.toJson()).toList(),
        'muscles': _muscles.map((e) => e.toJson()).toList(),
        'languages': _languages.map((e) => e.toJson()).toList(),
        'exercise-translations': exerciseTranslations.map((e) => e.toJson()).toList(),
        'bases': _exerciseBases.map((e) => e.toJson()).toList(),
      };
      log("Saved ${_exerciseBases.length} exercises to cache. Valid till ${cacheData['expiresIn']}");
      prefs.setString(PREFS_EXERCISES, json.encode(cacheData));
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
    final result = await baseProvider.fetch(
      baseProvider.makeUrl(
        _exerciseSearchPath,
        query: {'term': name, 'language': languageCode},
      ),
    );

    // Process the response
    for (var entry in result['suggestions']) {
      entry['exercise_obj'] = await fetchAndSetExercise(entry['data']['id']);
    }
    return result['suggestions'];
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
