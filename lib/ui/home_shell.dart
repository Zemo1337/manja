import 'dart:io';

import 'package:flutter/material.dart';

import '../l10n/l10n.dart';

import 'history/history_screen.dart';
import 'opened_files.dart';
import 'recipes/recipe_list_screen.dart';
import 'settings/backup_screen.dart';
import 'settings/settings_screen.dart';
import 'wheel/wheel_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    OpenedFiles.listen(_openFile);
  }

  Future<void> _openFile(String path) async {
    final file = File(path);
    final List<int> bytes;
    try {
      bytes = await file.readAsBytes();
      await file.delete();
    } on FileSystemException {
      return;
    }
    if (!mounted) return;
    setState(() => _index = 3);
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => BackupScreen(opened: bytes)));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [WheelScreen(), RecipeListScreen(), HistoryScreen(), SettingsScreen()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.casino_outlined),
            selectedIcon: const Icon(Icons.casino),
            label: l.navWheel,
          ),
          NavigationDestination(
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon: const Icon(Icons.menu_book),
            label: l.navRecipes,
          ),
          NavigationDestination(icon: const Icon(Icons.history), label: l.navHistory),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l.navSettings,
          ),
        ],
      ),
    );
  }
}
