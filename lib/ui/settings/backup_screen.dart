import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../app_scope.dart';
import '../../data/profile_backup.dart';
import '../../l10n/l10n.dart';
import 'option_card.dart';

typedef PickProfile = Future<List<int>?> Function();
typedef SaveProfile = Future<bool> Function(String fileName, Uint8List bytes);

AppLocalizations get _l10n {
  final locale = Locale(Intl.shortLocale(Intl.getCurrentLocale()));
  return lookupAppLocalizations(AppLocalizations.delegate.isSupported(locale) ? locale : const Locale('en'));
}

Future<List<int>?> _pickProfile() async {
  final files = await FilePicker.pickFiles(dialogTitle: _l10n.backupPickTitle);
  return files.isEmpty ? null : await files.first.readAsBytes();
}

Future<bool> _saveProfile(String fileName, Uint8List bytes) async =>
    await FilePicker.saveFile(fileName: fileName, bytes: bytes, dialogTitle: _l10n.backupSaveTitle) != null;

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

  static String _message(AppLocalizations l, FormatException e) => switch (e.message) {
    ProfileBackup.notAProfileMessage => l.backupNotAProfile,
    ProfileBackup.newerVersionMessage => l.backupNewerVersion,
    final message => message,
  };

  void _show(String Function(AppLocalizations l) message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message(context.l10n))));
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _busy = true);
    try {
      await action();
    } on FormatException catch (e) {
      _show((l) => _message(l, e));
    } on Exception catch (e) {
      _show((l) => l.backupError('$e'));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _export({required bool share}) => _run(() async {
    final backup = _backup;
    final subject = context.l10n.backupShareSubject;
    final bytes = await backup.export();
    final name = backup.fileName(DateTime.now());
    if (share) {
      final file = File(p.join((await getTemporaryDirectory()).path, name));
      await file.writeAsBytes(bytes, flush: true);
      await SharePlus.instance.share(ShareParams(files: [XFile(file.path)], subject: subject));
    } else if (await widget.save(name, bytes)) {
      _show((l) => l.backupSaved);
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
      _show((l) => _message(l, e));
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
      _show((l) {
        final added = l.backupRecipesAdded(result.added);
        return result.skipped == 0 ? added : l.backupAddedSkipped(added, result.skipped);
      });
    });
  }

  Future<bool> _confirmReplace() async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(context.l10n.backupReplaceTitle),
          content: Text(context.l10n.backupReplaceText),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: Text(context.l10n.backupCancel)),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: Text(context.l10n.backupReplaceEverything),
            ),
          ],
        ),
      ) ??
      false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.backupTitle)),
      body: AbsorbPointer(
        absorbing: _busy,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            if (_busy) const LinearProgressIndicator(),
            SettingsSectionTitle(l.backupExport),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(l.backupExportText(ProfileBackup.extension), style: theme.textTheme.bodyMedium),
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
                    label: Text(l.backupSaveToFile),
                  ),
                  if (_canShare)
                    OutlinedButton.icon(
                      onPressed: () => _export(share: true),
                      icon: const Icon(Icons.share_outlined),
                      label: Text(l.backupShare),
                    ),
                ],
              ),
            ),
            SettingsSectionTitle(l.backupImport),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(l.backupImportText(ProfileBackup.extension), style: theme.textTheme.bodyMedium),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton.icon(
                  onPressed: _import,
                  icon: const Icon(Icons.file_open_outlined),
                  label: Text(l.backupOpenProfile),
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
    final l = context.l10n;
    return AlertDialog(
      title: Text(l.backupImportTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (at != null)
            Text(l.backupSavedOn('${at.day}.${at.month}.${at.year}'), style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          Text(l.backupRecipeCount(summary.recipes)),
          if (summary.photos > 0) Text(l.backupPhotoCount(summary.photos)),
          if (summary.meals > 0) Text(l.backupMealCount(summary.meals)),
          if (summary.ownIngredients > 0) Text(l.backupOwnIngredientCount(summary.ownIngredients)),
          if (summary.pantry > 0) Text(l.backupPantryCount(summary.pantry)),
          const SizedBox(height: 12),
          Text(l.backupSkipHint),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l.backupCancel)),
        TextButton(onPressed: () => Navigator.pop(context, _ImportMode.replace), child: Text(l.backupReplace)),
        FilledButton(onPressed: () => Navigator.pop(context, _ImportMode.merge), child: Text(l.backupAdd)),
      ],
    );
  }
}
