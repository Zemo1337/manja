import 'package:flutter/material.dart';

import '../nutrition/ingredients_screen.dart';
import '../tools/converter_screen.dart';
import 'appearance_screen.dart';
import 'backup_screen.dart';
import 'option_card.dart';
import 'wheel_look_screen.dart';
import 'wheel_rounds_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _open(BuildContext context, Widget page) => Navigator.push(context, MaterialPageRoute(builder: (_) => page));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const SettingsSectionTitle('App'),
          ListTile(
            leading: const Icon(Icons.brightness_6_outlined),
            title: const Text('Appearance'),
            subtitle: const Text('Theme, light and dark mode'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _open(context, const AppearanceScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.import_export),
            title: const Text('Backup & move'),
            subtitle: const Text('Export or import your whole profile'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _open(context, const BackupScreen()),
          ),
          const SettingsSectionTitle('Wheel'),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text('Wheel look'),
            subtitle: const Text('Theme, photos, size, names'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _open(context, const WheelLookScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.restart_alt),
            title: const Text('Wheel rounds'),
            subtitle: const Text('When eaten dishes come back'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _open(context, const WheelRoundsScreen()),
          ),
          const SettingsSectionTitle('Kitchen'),
          ListTile(
            leading: const Icon(Icons.scale_outlined),
            title: const Text('Unit converter'),
            subtitle: const Text('Cups, spoons, grams and millilitres'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _open(context, const ConverterScreen()),
          ),
          const SettingsSectionTitle('Ingredients'),
          ListTile(
            leading: const Icon(Icons.kitchen_outlined),
            title: const Text('Ingredients & USDA key'),
            subtitle: const Text('Own ingredients, built-in data, online lookup'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _open(context, const IngredientsScreen()),
          ),
        ],
      ),
    );
  }
}
