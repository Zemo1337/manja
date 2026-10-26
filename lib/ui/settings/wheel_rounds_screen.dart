import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../domain/wheel_service.dart';
import '../../l10n/l10n.dart';
import '../wheel/wheel_labels.dart';
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
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.roundsTitle)),
      body: s == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                SettingsSectionTitle(l.roundsPutBack),
                RadioGroup<ResetMode>(
                  groupValue: s.mode,
                  onChanged: (m) => _change(m ?? s.mode, s.resetDays),
                  child: Column(
                    children: [
                      for (final mode in ResetMode.values)
                        RadioListTile<ResetMode>(value: mode, title: Text(mode.labelIn(l))),
                    ],
                  ),
                ),
                if (s.mode == ResetMode.afterDays)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Text(l.roundsResetEvery(s.resetDays)),
                        IconButton(
                          tooltip: l.roundsFewerDays,
                          onPressed: s.resetDays > 1 ? () => _change(s.mode, s.resetDays - 1) : null,
                          icon: const Icon(Icons.remove_circle_outline),
                        ),
                        Text('${s.resetDays}', style: theme.textTheme.titleMedium),
                        IconButton(
                          tooltip: l.roundsMoreDays,
                          onPressed: () => _change(s.mode, s.resetDays + 1),
                          icon: const Icon(Icons.add_circle_outline),
                        ),
                        Text(l.roundsDays(s.resetDays)),
                      ],
                    ),
                  ),
                Padding(padding: const EdgeInsets.all(16), child: Text(l.roundsHistoryKept)),
              ],
            ),
    );
  }
}
