import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../domain/wheel_service.dart';

Future<void> showWheelSettings(BuildContext context, WheelSettings settings, WheelAppearance appearance) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _WheelSettingsSheet(settings: settings, appearance: appearance),
  );
}

class _WheelSettingsSheet extends StatefulWidget {
  const _WheelSettingsSheet({required this.settings, required this.appearance});

  final WheelSettings settings;
  final WheelAppearance appearance;

  @override
  State<_WheelSettingsSheet> createState() => _WheelSettingsSheetState();
}

class _WheelSettingsSheetState extends State<_WheelSettingsSheet> {
  late ResetMode _mode = widget.settings.mode;
  late int _days = widget.settings.resetDays;
  late WheelAppearance _look = widget.appearance;

  Future<void> _save() async {
    final wheel = AppScope.of(context).wheel;
    await wheel.saveAppearance(_look);
    await wheel.saveSettings(_mode, _days);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.85),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Wheel settings', style: theme.textTheme.titleLarge),
              const SizedBox(height: 16),
              Text('Look', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Text('Show on the wheel', style: theme.textTheme.bodyMedium),
              const SizedBox(height: 8),
              SegmentedButton<WheelContent>(
                segments: [
                  for (final c in WheelContent.values) ButtonSegment(value: c, label: Text(c.label)),
                ],
                selected: {_look.content},
                onSelectionChanged: (s) => setState(() => _look = _look.copyWith(content: s.single)),
              ),
              const SizedBox(height: 16),
              Text('Recipes shown on the wheel: ${_look.maxSlices}', style: theme.textTheme.bodyMedium),
              Slider(
                value: _look.maxSlices.toDouble(),
                min: WheelAppearance.minSlices.toDouble(),
                max: WheelAppearance.maxSlicesLimit.toDouble(),
                divisions: WheelAppearance.maxSlicesLimit - WheelAppearance.minSlices,
                label: '${_look.maxSlices}',
                onChanged: (v) => setState(() => _look = _look.copyWith(maxSlices: v.round())),
              ),
              Text(
                'With more recipes, one "+n" slice stands for the rest. Every recipe still has the same chance.',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              Text('Winning dish takes ${_look.winnerPercent}% of the wheel', style: theme.textTheme.bodyMedium),
              Slider(
                value: _look.winnerPercent.toDouble(),
                min: WheelAppearance.minWinnerPercent.toDouble(),
                max: 100,
                divisions: (100 - WheelAppearance.minWinnerPercent) ~/ 10,
                label: '${_look.winnerPercent}%',
                onChanged: (v) => setState(() => _look = _look.copyWith(winnerPercent: v.round())),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Keep names upright'),
                subtitle: const Text('Turn names on the left half so they are never upside down'),
                value: _look.flipText,
                onChanged: (v) => setState(() => _look = _look.copyWith(flipText: v)),
              ),
              const Divider(height: 32),
              Text('Round', style: theme.textTheme.titleMedium),
              const SizedBox(height: 4),
              Text('Put eaten dishes back on the wheel', style: theme.textTheme.bodyMedium),
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
      ),
    );
  }
}
