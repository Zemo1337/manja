import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../domain/wheel_service.dart';
import 'option_card.dart';

class WheelRoundsScreen extends StatefulWidget {
  const WheelRoundsScreen({super.key});

  @override
  State<WheelRoundsScreen> createState() => _WheelRoundsScreenState();
}

class _WheelRoundsScreenState extends State<WheelRoundsScreen> {
  WheelSettings? _settings;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_settings == null) _load();
  }

  Future<void> _load() async {
    final settings = await AppScope.of(context).wheel.loadSettings();
    if (mounted) setState(() => _settings = settings);
  }

  void _change(ResetMode mode, int days) {
    final current = _settings!;
    setState(() => _settings = WheelSettings(mode: mode, resetDays: days, cycleStartedAt: current.cycleStartedAt));
    AppScope.of(context).wheel.saveSettings(mode, days);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = _settings;
    return Scaffold(
      appBar: AppBar(title: const Text('Wheel rounds')),
      body: s == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                const SettingsSectionTitle('Put eaten dishes back on the wheel'),
                RadioGroup<ResetMode>(
                  groupValue: s.mode,
                  onChanged: (m) => _change(m ?? s.mode, s.resetDays),
                  child: Column(
                    children: [
                      for (final mode in ResetMode.values)
                        RadioListTile<ResetMode>(value: mode, title: Text(mode.label)),
                    ],
                  ),
                ),
                if (s.mode == ResetMode.afterDays)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Text('Reset every'),
                        IconButton(
                          tooltip: 'Fewer days',
                          onPressed: s.resetDays > 1 ? () => _change(s.mode, s.resetDays - 1) : null,
                          icon: const Icon(Icons.remove_circle_outline),
                        ),
                        Text('${s.resetDays}', style: theme.textTheme.titleMedium),
                        IconButton(
                          tooltip: 'More days',
                          onPressed: () => _change(s.mode, s.resetDays + 1),
                          icon: const Icon(Icons.add_circle_outline),
                        ),
                        Text(s.resetDays == 1 ? 'day' : 'days'),
                      ],
                    ),
                  ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Your meal history is always kept. A new round only puts the dishes back on the wheel.'),
                ),
              ],
            ),
    );
  }
}
