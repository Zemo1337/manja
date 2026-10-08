import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../app_theme.dart';
import 'option_card.dart';

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appearance = AppScope.of(context).appearance;
    final platform = MediaQuery.platformBrightnessOf(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Appearance')),
      body: ListenableBuilder(
        listenable: appearance,
        builder: (context, _) {
          final previewBrightness = switch (appearance.brightness) {
            AppBrightness.system => platform,
            AppBrightness.light => Brightness.light,
            AppBrightness.dark => Brightness.dark,
          };
          return ListView(
            padding: const EdgeInsets.only(bottom: 32),
            children: [
              const SettingsSectionTitle('App theme'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final kind in AppThemeKind.values)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: OptionCard(
                            label: kind.label,
                            selected: appearance.theme == kind,
                            onTap: () => appearance.setTheme(kind),
                            preview: ThemePreview(scheme: appColorScheme(kind, previewBrightness)),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Text(appearance.theme.description, style: Theme.of(context).textTheme.bodySmall),
              ),
              const SettingsSectionTitle('Mode'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SegmentedButton<AppBrightness>(
                  segments: [for (final b in AppBrightness.values) ButtonSegment(value: b, label: Text(b.label))],
                  selected: {appearance.brightness},
                  onSelectionChanged: appearance.theme.alwaysDark ? null : (s) => appearance.setBrightness(s.single),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Text(
                  appearance.theme.alwaysDark
                      ? 'The Dev theme is always dark.'
                      : 'System follows the light or dark setting of your device.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ThemePreview extends StatelessWidget {
  const ThemePreview({super.key, required this.scheme});

  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    Widget bar(Color color, double width, {double height = 6}) => Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(height / 2)),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 84,
        height: 92,
        color: scheme.surface,
        child: Column(
          children: [
            Container(
              height: 18,
              color: scheme.surface,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              alignment: Alignment.centerLeft,
              child: bar(scheme.onSurface, 36),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: scheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(6)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  bar(scheme.onSurfaceVariant, 44, height: 4),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 26,
                        height: 12,
                        decoration: BoxDecoration(color: scheme.primary, borderRadius: BorderRadius.circular(6)),
                      ),
                      const SizedBox(width: 4),
                      CircleAvatar(radius: 5, backgroundColor: scheme.secondary),
                      const SizedBox(width: 3),
                      CircleAvatar(radius: 5, backgroundColor: scheme.tertiary),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            Container(
              height: 16,
              color: scheme.surfaceContainer,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  bar(scheme.primaryContainer, 16, height: 8),
                  bar(scheme.onSurfaceVariant, 8, height: 4),
                  bar(scheme.onSurfaceVariant, 8, height: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
