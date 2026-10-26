import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../domain/wheel_layout.dart';
import '../../domain/units.dart';
import '../../domain/wheel_service.dart';
import '../../l10n/l10n.dart';
import '../wheel/wheel_labels.dart';
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
    final l = context.l10n;
    String seconds(int millis) => (millis / 1000).toStringAsFixed(1).replaceFirst('.', decimalSeparator);
    return Scaffold(
      appBar: AppBar(title: Text(l.wheelLookTitle)),
      body: look == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.only(bottom: 32),
              children: [
                SettingsSectionTitle(l.wheelLookTheme),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      const spacing = 8.0;
                      final width = (constraints.maxWidth - 2 * spacing) / 3;
                      return Wrap(
                        spacing: spacing,
                        runSpacing: spacing,
                        children: [
                          for (final kind in WheelThemeKind.values)
                            SizedBox(
                              width: width,
                              child: OptionCard(
                                label: kind.labelIn(l),
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
                        ],
                      );
                    },
                  ),
                ),
                SettingsSectionTitle(l.wheelLookShow),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SegmentedButton<WheelContent>(
                    segments: [for (final c in WheelContent.values) ButtonSegment(value: c, label: Text(c.labelIn(l)))],
                    selected: {look.content},
                    onSelectionChanged: (s) => _change(look.copyWith(content: s.single)),
                  ),
                ),
                SettingsSectionTitle(l.wheelLookSize),
                ListTile(title: Text(l.wheelLookMaxSlices(look.maxSlices)), subtitle: Text(l.wheelLookMaxSlicesHint)),
                Slider(
                  value: look.maxSlices.toDouble(),
                  min: WheelAppearance.minSlices.toDouble(),
                  max: WheelAppearance.maxSlicesLimit.toDouble(),
                  divisions: WheelAppearance.maxSlicesLimit - WheelAppearance.minSlices,
                  label: '${look.maxSlices}',
                  onChanged: (v) => setState(() => _look = look.copyWith(maxSlices: v.round())),
                  onChangeEnd: (v) => _change(look.copyWith(maxSlices: v.round())),
                ),
                ListTile(title: Text(l.wheelLookWinnerPercent(look.winnerPercent))),
                Slider(
                  value: look.winnerPercent.toDouble(),
                  min: WheelAppearance.minWinnerPercent.toDouble(),
                  max: 100,
                  divisions: (100 - WheelAppearance.minWinnerPercent) ~/ 10,
                  label: l.wheelLookPercent(look.winnerPercent),
                  onChanged: (v) => setState(() => _look = look.copyWith(winnerPercent: v.round())),
                  onChangeEnd: (v) => _change(look.copyWith(winnerPercent: v.round())),
                ),
                SettingsSectionTitle(l.wheelLookSpin),
                ListTile(
                  title: Text(l.wheelLookSpinTime('${look.spinSeconds}')),
                  subtitle: Text(l.wheelLookSpinTimeHint),
                ),
                Slider(
                  value: look.spinSeconds.toDouble(),
                  min: WheelAppearance.minSpinSeconds.toDouble(),
                  max: WheelAppearance.maxSpinSeconds.toDouble(),
                  divisions: WheelAppearance.maxSpinSeconds - WheelAppearance.minSpinSeconds,
                  label: l.wheelLookSeconds('${look.spinSeconds}'),
                  onChanged: (v) => setState(() => _look = look.copyWith(spinSeconds: v.round())),
                  onChangeEnd: (v) => _change(look.copyWith(spinSeconds: v.round())),
                ),
                ListTile(
                  title: Text(l.wheelLookReveal(seconds(look.revealMillis))),
                  subtitle: Text(l.wheelLookRevealHint),
                ),
                Slider(
                  value: look.revealMillis.toDouble(),
                  min: WheelAppearance.minRevealMillis.toDouble(),
                  max: WheelAppearance.maxRevealMillis.toDouble(),
                  divisions: (WheelAppearance.maxRevealMillis - WheelAppearance.minRevealMillis) ~/ 100,
                  label: l.wheelLookSeconds(seconds(look.revealMillis)),
                  onChanged: (v) => setState(() => _look = look.copyWith(revealMillis: (v / 100).round() * 100)),
                  onChangeEnd: (v) => _change(look.copyWith(revealMillis: (v / 100).round() * 100)),
                ),
                SettingsSectionTitle(l.wheelLookNames),
                SwitchListTile(
                  title: Text(l.wheelLookUpright),
                  subtitle: Text(l.wheelLookUprightHint),
                  value: look.flipText,
                  onChanged: (v) => _change(look.copyWith(flipText: v)),
                ),
              ],
            ),
    );
  }
}
