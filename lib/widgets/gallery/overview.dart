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
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wger/providers/gallery.dart';
import 'package:wger/screens/form_screen.dart';

import 'forms.dart';

class Gallery extends StatelessWidget {
  const Gallery();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GalleryProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(5),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        children: List.generate(provider.images.length, (index) {
          final currentImage = provider.images[index];

          return GestureDetector(
            onTap: () {
              showModalBottomSheet(
                builder: (context) => Material(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.white,
                    child: Column(
                      children: [
                        Text(
                          DateFormat.yMd(Localizations.localeOf(context).languageCode)
                              .format(currentImage.date),
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        Expanded(
                          child: Image.network(currentImage.url!),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(currentImage.description),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  Provider.of<GalleryProvider>(context, listen: false)
                                      .deleteImage(currentImage);
                                  Navigator.of(context).pop();
                                }),
                            IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    FormScreen.routeName,
                                    arguments: FormScreenArguments(
                                      AppLocalizations.of(context)!.edit,
                                      ImageForm(currentImage),
                                      true,
                                    ),
                                  );
                                }),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                context: context,
              );
            },
            child: FadeInImage(
              placeholder: AssetImage('assets/images/placeholder.png'),
              image: NetworkImage(provider.images[index].url!),
              fit: BoxFit.cover,
            ),
          );
        }),
      ),
    );
  }
}
