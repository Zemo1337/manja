import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_logo.dart';

const sourceUrl = 'https://github.com/Zemo1337/manja';

void registerAppLicenses() {
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks(['Lobster font'], await rootBundle.loadString('assets/fonts/Lobster-OFL.txt'));
    yield const LicenseEntryWithLineBreaks(
      ['Roboto font'],
      '''
Roboto by Google, licensed under the Apache License, Version 2.0.
https://www.apache.org/licenses/LICENSE-2.0''',
    );
    yield const LicenseEntryWithLineBreaks(
      ['USDA FoodData Central'],
      '''
Nutrition data from USDA FoodData Central (U.S. Department of Agriculture, Agricultural Research Service).
Public domain. https://fdc.nal.usda.gov/''',
    );
    yield const LicenseEntryWithLineBreaks(
      ['Open Food Facts'],
      '''
Product data from Open Food Facts, made available under the Open Database License (ODbL) v1.0.
© Open Food Facts contributors. https://world.openfoodfacts.org/''',
    );
  });
}

void showManjaAbout(BuildContext context) => showLicensePage(
  context: context,
  applicationName: 'Manja',
  applicationIcon: const Padding(padding: EdgeInsets.all(8), child: AppLogo(size: 72, background: true)),
  applicationLegalese:
      'Free software under the GNU Affero General Public License v3.0.\n'
      'Source code: $sourceUrl\n'
      'The name "Manja" and its logo are not covered by the license.',
);
