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

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wger/exceptions/http_exception.dart';
import 'package:wger/helpers/json.dart';
import 'package:wger/helpers/ui.dart';
import 'package:wger/models/measurements/measurement_category.dart';
import 'package:wger/models/measurements/measurement_entry.dart';
import 'package:wger/providers/measurement.dart';

class MeasurementCategoryForm extends StatelessWidget {
  final _form = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final unitController = TextEditingController();

  Map<String, dynamic> categoryData = {'id': null, 'name': '', 'unit': ''};

  MeasurementCategoryForm([MeasurementCategory? category]) {
    //this._category = category ?? MeasurementCategory();
    if (category != null) {
      categoryData['id'] = category.id;
      categoryData['unit'] = category.unit;
      categoryData['name'] = category.name;
    }

    unitController.text = categoryData['unit']!;
    nameController.text = categoryData['name']!;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Column(
        children: [
          // Name
          TextFormField(
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).name,
              helperText: AppLocalizations.of(context).measurementCategoriesHelpText,
            ),
            controller: nameController,
            onSaved: (newValue) {
              categoryData['name'] = newValue!;
            },
            validator: (value) {
              if (value!.isEmpty) {
                return AppLocalizations.of(context).enterValue;
              }
              return null;
            },
          ),

          // Unit
          TextFormField(
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).unit,
              helperText: AppLocalizations.of(context).measurementEntriesHelpText,
            ),
            controller: unitController,
            onSaved: (newValue) {
              categoryData['unit'] = newValue!;
            },
            validator: (value) {
              if (value!.isEmpty) {
                return AppLocalizations.of(context).enterValue;
              }
              return null;
            },
          ),
          ElevatedButton(
            child: Text(AppLocalizations.of(context).save),
            onPressed: () async {
              // Validate and save the current values to the weightEntry
              final isValid = _form.currentState!.validate();
              if (!isValid) {
                return;
              }
              _form.currentState!.save();

              // Save the entry on the server
              try {
                categoryData['id'] == null
                    ? await Provider.of<MeasurementProvider>(context, listen: false).addCategory(
                        MeasurementCategory(
                          id: categoryData['id'],
                          name: categoryData['name'],
                          unit: categoryData['unit'],
                        ),
                      )
                    : await Provider.of<MeasurementProvider>(context, listen: false).editCategory(
                        categoryData['id'], categoryData['name'], categoryData['unit']);
              } on WgerHttpException catch (error) {
                showHttpExceptionErrorDialog(error, context);
              } catch (error) {
                showErrorDialog(error, context);
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

class MeasurementEntryForm extends StatelessWidget {
  final _form = GlobalKey<FormState>();
  final int _categoryId;
  final _valueController = TextEditingController();
  final _dateController = TextEditingController();
  final _notesController = TextEditingController();

  late Map<String, dynamic> _entryData;

  MeasurementEntryForm(this._categoryId, [MeasurementEntry? entry]) {
    _entryData = {
      'id': null,
      'category': _categoryId,
      'date': DateTime.now(),
      'value': '',
      'notes': '',
    };

    if (entry != null) {
      _entryData['id'] = entry.id;
      _entryData['category'] = entry.category;
      _entryData['value'] = entry.value;
      _entryData['date'] = entry.date;
      _entryData['notes'] = entry.notes;
    }

    _dateController.text = toDate(_entryData['date'])!;
    _valueController.text = _entryData['value']!.toString();
    _notesController.text = _entryData['notes']!;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: AppLocalizations.of(context).date),
            readOnly: true, // Hide text cursor
            controller: _dateController,
            onTap: () async {
              // Stop keyboard from appearing
              FocusScope.of(context).requestFocus(new FocusNode());

              // Show Date Picker Here
              var pickedDate = await showDatePicker(
                context: context,
                initialDate: _entryData['date'],
                firstDate: DateTime(DateTime.now().year - 10),
                lastDate: DateTime.now(),

                // TODO: we need to filter out dates that already have an entry
                selectableDayPredicate: (day) {
                  // Always allow the current initial date
                  if (day == _entryData['date']) {
                    return true;
                  }
                  return true;
                },
              );

              _dateController.text = toDate(pickedDate)!;
            },
            onSaved: (newValue) {
              _entryData['date'] = DateTime.parse(newValue!);
            },
            validator: (value) {
              if (value!.isEmpty) {
                return AppLocalizations.of(context).enterValue;
              }
              return null;
            },
          ),
          // Value
          TextFormField(
            decoration: InputDecoration(labelText: AppLocalizations.of(context).value),
            controller: _valueController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return AppLocalizations.of(context).enterValue;
              }
              try {
                double.parse(value);
              } catch (error) {
                return AppLocalizations.of(context).enterValidNumber;
              }
              return null;
            },
            onSaved: (newValue) {
              _entryData['value'] = double.parse(newValue!);
            },
          ),
          // Value
          TextFormField(
            decoration: InputDecoration(labelText: AppLocalizations.of(context).notes),
            controller: _notesController,
            onSaved: (newValue) {
              _entryData['notes'] = newValue!;
            },
          ),

          ElevatedButton(
            child: Text(AppLocalizations.of(context).save),
            onPressed: () async {
              // Validate and save the current values to the weightEntry
              final isValid = _form.currentState!.validate();
              if (!isValid) {
                return;
              }
              _form.currentState!.save();

              // Save the entry on the server
              try {
                _entryData['id'] == null
                    ? await Provider.of<MeasurementProvider>(context, listen: false)
                        .addEntry(MeasurementEntry(
                        id: _entryData['id'],
                        category: _entryData['category'],
                        date: _entryData['date'],
                        value: _entryData['value'],
                        notes: _entryData['notes'],
                      ))
                    : await Provider.of<MeasurementProvider>(context, listen: false).editEntry(
                        _entryData['id'],
                        _entryData['category'],
                        _entryData['value'],
                        _entryData['notes'],
                        _entryData['date'],
                      );
              } on WgerHttpException catch (error) {
                showHttpExceptionErrorDialog(error, context);
              } catch (error) {
                showErrorDialog(error, context);
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
