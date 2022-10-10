// Mocks generated by Mockito 5.3.2 from annotations
// in wger/test/workout/gym_mode_screen_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i9;
import 'dart:ui' as _i10;

import 'package:mockito/mockito.dart' as _i1;
import 'package:wger/models/exercises/base.dart' as _i3;
import 'package:wger/models/exercises/category.dart' as _i4;
import 'package:wger/models/exercises/equipment.dart' as _i5;
import 'package:wger/models/exercises/language.dart' as _i7;
import 'package:wger/models/exercises/muscle.dart' as _i6;
import 'package:wger/providers/base_provider.dart' as _i2;
import 'package:wger/providers/exercises.dart' as _i8;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeWgerBaseProvider_0 extends _i1.SmartFake
    implements _i2.WgerBaseProvider {
  _FakeWgerBaseProvider_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeExerciseBase_1 extends _i1.SmartFake implements _i3.ExerciseBase {
  _FakeExerciseBase_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeExerciseCategory_2 extends _i1.SmartFake
    implements _i4.ExerciseCategory {
  _FakeExerciseCategory_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeEquipment_3 extends _i1.SmartFake implements _i5.Equipment {
  _FakeEquipment_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeMuscle_4 extends _i1.SmartFake implements _i6.Muscle {
  _FakeMuscle_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeLanguage_5 extends _i1.SmartFake implements _i7.Language {
  _FakeLanguage_5(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [ExercisesProvider].
///
/// See the documentation for Mockito's code generation for more information.
class MockExercisesProvider extends _i1.Mock implements _i8.ExercisesProvider {
  MockExercisesProvider() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.WgerBaseProvider get baseProvider => (super.noSuchMethod(
        Invocation.getter(#baseProvider),
        returnValue: _FakeWgerBaseProvider_0(
          this,
          Invocation.getter(#baseProvider),
        ),
      ) as _i2.WgerBaseProvider);
  @override
  set exerciseBases(List<_i3.ExerciseBase>? exercisesBases) =>
      super.noSuchMethod(
        Invocation.setter(
          #exerciseBases,
          exercisesBases,
        ),
        returnValueForMissingStub: null,
      );
  @override
  List<_i3.ExerciseBase> get filteredExerciseBases => (super.noSuchMethod(
        Invocation.getter(#filteredExerciseBases),
        returnValue: <_i3.ExerciseBase>[],
      ) as List<_i3.ExerciseBase>);
  @override
  set filteredExerciseBases(List<_i3.ExerciseBase>? newFilteredExercises) =>
      super.noSuchMethod(
        Invocation.setter(
          #filteredExerciseBases,
          newFilteredExercises,
        ),
        returnValueForMissingStub: null,
      );
  @override
  Map<int, List<_i3.ExerciseBase>> get exerciseBasesByVariation =>
      (super.noSuchMethod(
        Invocation.getter(#exerciseBasesByVariation),
        returnValue: <int, List<_i3.ExerciseBase>>{},
      ) as Map<int, List<_i3.ExerciseBase>>);
  @override
  List<_i3.ExerciseBase> get bases => (super.noSuchMethod(
        Invocation.getter(#bases),
        returnValue: <_i3.ExerciseBase>[],
      ) as List<_i3.ExerciseBase>);
  @override
  List<_i4.ExerciseCategory> get categories => (super.noSuchMethod(
        Invocation.getter(#categories),
        returnValue: <_i4.ExerciseCategory>[],
      ) as List<_i4.ExerciseCategory>);
  @override
  List<_i6.Muscle> get muscles => (super.noSuchMethod(
        Invocation.getter(#muscles),
        returnValue: <_i6.Muscle>[],
      ) as List<_i6.Muscle>);
  @override
  List<_i5.Equipment> get equipment => (super.noSuchMethod(
        Invocation.getter(#equipment),
        returnValue: <_i5.Equipment>[],
      ) as List<_i5.Equipment>);
  @override
  List<_i7.Language> get languages => (super.noSuchMethod(
        Invocation.getter(#languages),
        returnValue: <_i7.Language>[],
      ) as List<_i7.Language>);
  @override
  set languages(List<_i7.Language>? languages) => super.noSuchMethod(
        Invocation.setter(
          #languages,
          languages,
        ),
        returnValueForMissingStub: null,
      );
  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
      ) as bool);
  @override
  _i9.Future<void> setFilters(_i8.Filters? newFilters) => (super.noSuchMethod(
        Invocation.method(
          #setFilters,
          [newFilters],
        ),
        returnValue: _i9.Future<void>.value(),
        returnValueForMissingStub: _i9.Future<void>.value(),
      ) as _i9.Future<void>);
  @override
  _i9.Future<void> findByFilters() => (super.noSuchMethod(
        Invocation.method(
          #findByFilters,
          [],
        ),
        returnValue: _i9.Future<void>.value(),
        returnValueForMissingStub: _i9.Future<void>.value(),
      ) as _i9.Future<void>);
  @override
  void clear() => super.noSuchMethod(
        Invocation.method(
          #clear,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i3.ExerciseBase findExerciseBaseById(int? id) => (super.noSuchMethod(
        Invocation.method(
          #findExerciseBaseById,
          [id],
        ),
        returnValue: _FakeExerciseBase_1(
          this,
          Invocation.method(
            #findExerciseBaseById,
            [id],
          ),
        ),
      ) as _i3.ExerciseBase);
  @override
  List<_i3.ExerciseBase> findExerciseBasesByVariationId(
    int? id, {
    int? exerciseBaseIdToExclude,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #findExerciseBasesByVariationId,
          [id],
          {#exerciseBaseIdToExclude: exerciseBaseIdToExclude},
        ),
        returnValue: <_i3.ExerciseBase>[],
      ) as List<_i3.ExerciseBase>);
  @override
  _i4.ExerciseCategory findCategoryById(int? id) => (super.noSuchMethod(
        Invocation.method(
          #findCategoryById,
          [id],
        ),
        returnValue: _FakeExerciseCategory_2(
          this,
          Invocation.method(
            #findCategoryById,
            [id],
          ),
        ),
      ) as _i4.ExerciseCategory);
  @override
  _i5.Equipment findEquipmentById(int? id) => (super.noSuchMethod(
        Invocation.method(
          #findEquipmentById,
          [id],
        ),
        returnValue: _FakeEquipment_3(
          this,
          Invocation.method(
            #findEquipmentById,
            [id],
          ),
        ),
      ) as _i5.Equipment);
  @override
  _i6.Muscle findMuscleById(int? id) => (super.noSuchMethod(
        Invocation.method(
          #findMuscleById,
          [id],
        ),
        returnValue: _FakeMuscle_4(
          this,
          Invocation.method(
            #findMuscleById,
            [id],
          ),
        ),
      ) as _i6.Muscle);
  @override
  _i7.Language findLanguageById(int? id) => (super.noSuchMethod(
        Invocation.method(
          #findLanguageById,
          [id],
        ),
        returnValue: _FakeLanguage_5(
          this,
          Invocation.method(
            #findLanguageById,
            [id],
          ),
        ),
      ) as _i7.Language);
  @override
  _i9.Future<void> fetchAndSetCategories() => (super.noSuchMethod(
        Invocation.method(
          #fetchAndSetCategories,
          [],
        ),
        returnValue: _i9.Future<void>.value(),
        returnValueForMissingStub: _i9.Future<void>.value(),
      ) as _i9.Future<void>);
  @override
  _i9.Future<void> fetchAndSetVariations() => (super.noSuchMethod(
        Invocation.method(
          #fetchAndSetVariations,
          [],
        ),
        returnValue: _i9.Future<void>.value(),
        returnValueForMissingStub: _i9.Future<void>.value(),
      ) as _i9.Future<void>);
  @override
  _i9.Future<void> fetchAndSetMuscles() => (super.noSuchMethod(
        Invocation.method(
          #fetchAndSetMuscles,
          [],
        ),
        returnValue: _i9.Future<void>.value(),
        returnValueForMissingStub: _i9.Future<void>.value(),
      ) as _i9.Future<void>);
  @override
  _i9.Future<void> fetchAndSetEquipment() => (super.noSuchMethod(
        Invocation.method(
          #fetchAndSetEquipment,
          [],
        ),
        returnValue: _i9.Future<void>.value(),
        returnValueForMissingStub: _i9.Future<void>.value(),
      ) as _i9.Future<void>);
  @override
  _i9.Future<void> fetchAndSetLanguages() => (super.noSuchMethod(
        Invocation.method(
          #fetchAndSetLanguages,
          [],
        ),
        returnValue: _i9.Future<void>.value(),
        returnValueForMissingStub: _i9.Future<void>.value(),
      ) as _i9.Future<void>);
  @override
  _i9.Future<_i3.ExerciseBase> fetchAndSetExerciseBase(int? exerciseBaseId) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchAndSetExerciseBase,
          [exerciseBaseId],
        ),
        returnValue: _i9.Future<_i3.ExerciseBase>.value(_FakeExerciseBase_1(
          this,
          Invocation.method(
            #fetchAndSetExerciseBase,
            [exerciseBaseId],
          ),
        )),
      ) as _i9.Future<_i3.ExerciseBase>);
  @override
  _i3.ExerciseBase readExerciseBaseFromBaseInfo(dynamic baseData) =>
      (super.noSuchMethod(
        Invocation.method(
          #readExerciseBaseFromBaseInfo,
          [baseData],
        ),
        returnValue: _FakeExerciseBase_1(
          this,
          Invocation.method(
            #readExerciseBaseFromBaseInfo,
            [baseData],
          ),
        ),
      ) as _i3.ExerciseBase);
  @override
  _i9.Future<void> checkExerciseCacheVersion() => (super.noSuchMethod(
        Invocation.method(
          #checkExerciseCacheVersion,
          [],
        ),
        returnValue: _i9.Future<void>.value(),
        returnValueForMissingStub: _i9.Future<void>.value(),
      ) as _i9.Future<void>);
  @override
  _i9.Future<void> fetchAndSetExercises() => (super.noSuchMethod(
        Invocation.method(
          #fetchAndSetExercises,
          [],
        ),
        returnValue: _i9.Future<void>.value(),
        returnValueForMissingStub: _i9.Future<void>.value(),
      ) as _i9.Future<void>);
  @override
  _i9.Future<List<_i3.ExerciseBase>> searchExercise(
    String? name, [
    String? languageCode = r'en',
  ]) =>
      (super.noSuchMethod(
        Invocation.method(
          #searchExercise,
          [
            name,
            languageCode,
          ],
        ),
        returnValue:
            _i9.Future<List<_i3.ExerciseBase>>.value(<_i3.ExerciseBase>[]),
      ) as _i9.Future<List<_i3.ExerciseBase>>);
  @override
  void addListener(_i10.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void removeListener(_i10.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #removeListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void notifyListeners() => super.noSuchMethod(
        Invocation.method(
          #notifyListeners,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
