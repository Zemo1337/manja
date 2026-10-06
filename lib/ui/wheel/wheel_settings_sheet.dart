import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../domain/wheel_service.dart';

Future<void> showWheelSettings(BuildContext context, WheelSettings settings) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _WheelSettingsSheet(settings: settings),
  );
}

class _WheelSettingsSheet extends StatefulWidget {
  const _WheelSettingsSheet({required this.settings});

  final WheelSettings settings;

  @override
  State<_WheelSettingsSheet> createState() => _WheelSettingsSheetState();
}

class _WheelSettingsSheetState extends State<_WheelSettingsSheet> {
  late ResetMode _mode = widget.settings.mode;
  late int _days = widget.settings.resetDays;

  Future<void> _save() async {
    await AppScope.of(context).wheel.saveSettings(_mode, _days);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Wheel settings', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            Text('Put eaten dishes back on the wheel', style: theme.textTheme.titleSmall),
            RadioGroup<ResetMode>(
              groupValue: _mode,
              onChanged: (m) => setState(() => _mode = m ?? _mode),
              child: Column(
                children: [
                  for (final mode in ResetMode.values)
                    RadioListTile<ResetMode>(value: mode, title: Text(mode.label), contentPadding: EdgeInsets.zero),
                ],
              ),
            ),
            if (_mode == ResetMode.afterDays)
              Row(
                children: [
                  const Text('Reset every'),
                  IconButton(
                    onPressed: _days > 1 ? () => setState(() => _days--) : null,
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Text('$_days', style: theme.textTheme.titleMedium),
                  IconButton(onPressed: () => setState(() => _days++), icon: const Icon(Icons.add_circle_outline)),
                  Text(_days == 1 ? 'day' : 'days'),
                ],
              ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(onPressed: _save, child: const Text('Save')),
            ),
          ],
        ),
      ),
    );
  }
}
