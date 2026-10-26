import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../nutrition/ingredients_screen.dart';
import '../tools/converter_screen.dart';
import 'about.dart';
import 'appearance_screen.dart';
import 'backup_screen.dart';
import 'option_card.dart';
import 'tags_screen.dart';
import 'wheel_look_screen.dart';
import 'wheel_rounds_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _open(BuildContext context, Widget page) => Navigator.push(context, MaterialPageRoute(builder: (_) => page));

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.settingsTitle)),
      body: ListView(
        children: [
          SettingsSectionTitle(l.settingsSectionApp),
          ListTile(
            leading: const Icon(Icons.brightness_6_outlined),
            title: Text(l.appearanceTitle),
            subtitle: Text(l.settingsAppearanceSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _open(context, const AppearanceScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.import_export),
            title: Text(l.backupTitle),
            subtitle: Text(l.settingsBackupSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _open(context, const BackupScreen()),
          ),
          SettingsSectionTitle(l.settingsSectionWheel),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: Text(l.wheelLookTitle),
            subtitle: Text(l.settingsWheelLookSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _open(context, const WheelLookScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.restart_alt),
            title: Text(l.roundsTitle),
            subtitle: Text(l.settingsRoundsSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _open(context, const WheelRoundsScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.label_outline),
            title: Text(l.tagsTitle),
            subtitle: Text(l.settingsTagsSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _open(context, const TagsScreen()),
          ),
          SettingsSectionTitle(l.settingsSectionKitchen),
          ListTile(
            leading: const Icon(Icons.scale_outlined),
            title: Text(l.settingsConverterTitle),
            subtitle: Text(l.settingsConverterSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _open(context, const ConverterScreen()),
          ),
          SettingsSectionTitle(l.settingsSectionIngredients),
          ListTile(
            leading: const Icon(Icons.kitchen_outlined),
            title: Text(l.settingsIngredientsTitle),
            subtitle: Text(l.settingsIngredientsSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _open(context, const IngredientsScreen()),
          ),
          SettingsSectionTitle(l.settingsSectionAbout),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l.settingsAboutTitle),
            subtitle: Text(l.settingsAboutSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => showManjaAbout(context),
          ),
        ],
      ),
    );
  }
}
