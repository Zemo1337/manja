import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../app_scope.dart';
import '../../data/profile_backup.dart';
import 'option_card.dart';

typedef PickProfile = Future<List<int>?> Function();
typedef SaveProfile = Future<bool> Function(String fileName, Uint8List bytes);

Future<List<int>?> _pickProfile() async {
  final files = await FilePicker.pickFiles(dialogTitle: 'Open a Manja Manja profile');
  return files.isEmpty ? null : await files.first.readAsBytes();
}

Future<bool> _saveProfile(String fileName, Uint8List bytes) async =>
    await FilePicker.saveFile(fileName: fileName, bytes: bytes, dialogTitle: 'Save your profile') != null;

class BackupScreen extends StatefulWidget {
  const BackupScreen({super.key, this.pick = _pickProfile, this.save = _saveProfile});

  final PickProfile pick;
  final SaveProfile save;

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

enum _ImportMode { merge, replace }

class _BackupScreenState extends State<BackupScreen> {
  bool _busy = false;

  bool get _canShare => Platform.isAndroid || Platform.isIOS;

  ProfileBackup get _backup {
    final scope = AppScope.of(context);
    return ProfileBackup(scope.db, scope.photos);
  }

  void _show(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _busy = true);
    try {
      await action();
    } on FormatException catch (e) {
      _show(e.message);
    } on Exception catch (e) {
      _show('Something went wrong: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _export({required bool share}) => _run(() async {
    final backup = _backup;
    final bytes = await backup.export();
    final name = backup.fileName(DateTime.now());
    if (share) {
      final file = File(p.join((await getTemporaryDirectory()).path, name));
      await file.writeAsBytes(bytes, flush: true);
      await SharePlus.instance.share(ShareParams(files: [XFile(file.path)], subject: 'Manja Manja profile'));
    } else if (await widget.save(name, bytes)) {
      _show('Profile saved');
    }
  });

  Future<void> _import() async {
    final backup = _backup;
    final List<int> bytes;
    final ProfileSummary summary;
    try {
      final picked = await widget.pick();
      if (picked == null) return;
      bytes = picked;
      summary = backup.read(bytes);
    } on FormatException catch (e) {
      _show(e.message);
      return;
    }
    if (!mounted) return;
    final mode = await showDialog<_ImportMode>(
      context: context,
      builder: (context) => _ImportDialog(summary: summary),
    );
    if (mode == null || !mounted) return;
    if (mode == _ImportMode.replace && !await _confirmReplace()) return;
    if (!mounted) return;
    final scope = AppScope.of(context);
    await _run(() async {
      final result = await backup.import(bytes, replace: mode == _ImportMode.replace);
      scope.wheel.focus.value = null;
      await scope.appearance.load();
      final added = '${result.added} ${result.added == 1 ? 'recipe' : 'recipes'} added';
      _show(result.skipped == 0 ? added : '$added, ${result.skipped} already there');
    });
  }

  Future<bool> _confirmReplace() async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Replace everything?'),
          content: const Text(
            'All recipes, photos, meal history, own ingredients, pantry and settings on this device '
            'will be replaced by the profile. Your USDA key stays.',
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Replace everything'),
            ),
          ],
        ),
      ) ??
      false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Backup & move')),
      body: AbsorbPointer(
        absorbing: _busy,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            if (_busy) const LinearProgressIndicator(),
            const SettingsSectionTitle('Export'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Puts your recipes, photos, own ingredients, pantry, meal history and settings into one '
                '${ProfileBackup.extension} file. Use it as a backup or to move to another device. '
                'Your USDA key is never included.',
                style: theme.textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(
                    onPressed: () => _export(share: false),
                    icon: const Icon(Icons.save_alt),
                    label: const Text('Save to file'),
                  ),
                  if (_canShare)
                    OutlinedButton.icon(
                      onPressed: () => _export(share: true),
                      icon: const Icon(Icons.share_outlined),
                      label: const Text('Share'),
                    ),
                ],
              ),
            ),
            const SettingsSectionTitle('Import'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Open a ${ProfileBackup.extension} file. You can add its recipes to yours or replace everything.',
                style: theme.textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton.icon(
                  onPressed: _import,
                  icon: const Icon(Icons.file_open_outlined),
                  label: const Text('Open a profile'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImportDialog extends StatelessWidget {
  const _ImportDialog({required this.summary});

  final ProfileSummary summary;

  @override
  Widget build(BuildContext context) {
    final at = summary.exportedAt;
    String count(int n, String one, String many) => '$n ${n == 1 ? one : many}';
    return AlertDialog(
      title: const Text('Import profile'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (at != null)
            Text('Saved on ${at.day}.${at.month}.${at.year}', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          Text(count(summary.recipes, 'recipe', 'recipes')),
          if (summary.photos > 0) Text(count(summary.photos, 'photo', 'photos')),
          if (summary.meals > 0) Text(count(summary.meals, 'meal', 'meals')),
          if (summary.ownIngredients > 0) Text(count(summary.ownIngredients, 'own ingredient', 'own ingredients')),
          if (summary.pantry > 0) Text(count(summary.pantry, 'pantry item', 'pantry items')),
          const SizedBox(height: 12),
          const Text('When adding, recipes with a name you already have are skipped.'),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        TextButton(onPressed: () => Navigator.pop(context, _ImportMode.replace), child: const Text('Replace')),
        FilledButton(onPressed: () => Navigator.pop(context, _ImportMode.merge), child: const Text('Add')),
      ],
    );
  }
}
