import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../domain/wheel_layout.dart';
import '../../domain/wheel_service.dart';
import '../wheel/wheel_painter.dart';
import '../wheel/wheel_themes.dart';
import 'option_card.dart';

class WheelLookScreen extends StatefulWidget {
  const WheelLookScreen({super.key});

  @override
  State<WheelLookScreen> createState() => _WheelLookScreenState();
}

class _WheelLookScreenState extends State<WheelLookScreen> {
  WheelAppearance? _look;

  static const _sample = [
    WheelSliceData(label: ''),
    WheelSliceData(label: ''),
    WheelSliceData(label: ''),
    WheelSliceData(label: ''),
    WheelSliceData(label: ''),
    WheelSliceData(label: ''),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_look == null) _load();
  }

  Future<void> _load() async {
    final look = await AppScope.of(context).wheel.loadAppearance();
    if (mounted) setState(() => _look = look);
  }

  void _change(WheelAppearance look) {
    setState(() => _look = look);
    AppScope.of(context).wheel.saveAppearance(look);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final look = _look;
    return Scaffold(
      appBar: AppBar(title: const Text('Wheel look')),
      body: look == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.only(bottom: 32),
              children: [
                const SettingsSectionTitle('Theme'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      for (final kind in WheelThemeKind.values)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: OptionCard(
                              label: kind.label,
                              selected: look.theme == kind,
                              onTap: () => _change(look.copyWith(theme: kind)),
                              preview: CustomPaint(
                                size: const Size.square(64),
                                painter: WheelPainter(
                                  slices: _sample,
                                  sweeps: sliceSweeps(_sample.length),
                                  rotation: 0,
                                  theme: WheelTheme.of(kind, theme.colorScheme),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SettingsSectionTitle('Show on the wheel'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SegmentedButton<WheelContent>(
                    segments: [for (final c in WheelContent.values) ButtonSegment(value: c, label: Text(c.label))],
                    selected: {look.content},
                    onSelectionChanged: (s) => _change(look.copyWith(content: s.single)),
                  ),
                ),
                const SettingsSectionTitle('Size'),
                ListTile(
                  title: Text('Recipes shown on the wheel: ${look.maxSlices}'),
                  subtitle: const Text(
                    'With more recipes, one "+n" slice stands for the rest. Every recipe still has the same chance.',
                  ),
                ),
                Slider(
                  value: look.maxSlices.toDouble(),
                  min: WheelAppearance.minSlices.toDouble(),
                  max: WheelAppearance.maxSlicesLimit.toDouble(),
                  divisions: WheelAppearance.maxSlicesLimit - WheelAppearance.minSlices,
                  label: '${look.maxSlices}',
                  onChanged: (v) => setState(() => _look = look.copyWith(maxSlices: v.round())),
                  onChangeEnd: (v) => _change(look.copyWith(maxSlices: v.round())),
                ),
                ListTile(title: Text('Winning dish takes ${look.winnerPercent}% of the wheel')),
                Slider(
                  value: look.winnerPercent.toDouble(),
                  min: WheelAppearance.minWinnerPercent.toDouble(),
                  max: 100,
                  divisions: (100 - WheelAppearance.minWinnerPercent) ~/ 10,
                  label: '${look.winnerPercent}%',
                  onChanged: (v) => setState(() => _look = look.copyWith(winnerPercent: v.round())),
                  onChangeEnd: (v) => _change(look.copyWith(winnerPercent: v.round())),
                ),
                const SettingsSectionTitle('Spin'),
                ListTile(
                  title: Text('Spin time: ${look.spinSeconds} s'),
                  subtitle: const Text('How long the wheel turns before it stops'),
                ),
                Slider(
                  value: look.spinSeconds.toDouble(),
                  min: WheelAppearance.minSpinSeconds.toDouble(),
                  max: WheelAppearance.maxSpinSeconds.toDouble(),
                  divisions: WheelAppearance.maxSpinSeconds - WheelAppearance.minSpinSeconds,
                  label: '${look.spinSeconds} s',
                  onChanged: (v) => setState(() => _look = look.copyWith(spinSeconds: v.round())),
                  onChangeEnd: (v) => _change(look.copyWith(spinSeconds: v.round())),
                ),
                const SettingsSectionTitle('Names'),
                SwitchListTile(
                  title: const Text('Keep names upright'),
                  subtitle: const Text('Turn names on the left half so they are never upside down'),
                  value: look.flipText,
                  onChanged: (v) => _change(look.copyWith(flipText: v)),
                ),
              ],
            ),
    );
  }
}
