import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../l10n/l10n.dart';
import '../app_theme.dart';
import '../app_theme_labels.dart';
import 'option_card.dart';

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appearance = AppScope.of(context).appearance;
    final platform = MediaQuery.platformBrightnessOf(context);
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.appearanceTitle)),
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
              SettingsSectionTitle(l.appearanceAppTheme),
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
                            label: kind.labelIn(l),
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
                child: Text(appearance.theme.descriptionIn(l), style: Theme.of(context).textTheme.bodySmall),
              ),
              SettingsSectionTitle(l.appearanceMode),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SegmentedButton<AppBrightness>(
                  segments: [for (final b in AppBrightness.values) ButtonSegment(value: b, label: Text(b.labelIn(l)))],
                  selected: {appearance.brightness},
                  onSelectionChanged: appearance.theme.alwaysDark ? null : (s) => appearance.setBrightness(s.single),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Text(
                  appearance.theme.alwaysDark ? l.appearanceDevAlwaysDark : l.appearanceSystemHint,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              SettingsSectionTitle(l.languageTitle),
              RadioGroup<String?>(
                groupValue: appearance.language,
                onChanged: appearance.setLanguage,
                child: Column(
                  children: [
                    RadioListTile<String?>(value: null, title: Text(l.languagePhone)),
                    for (final locale in AppLocalizations.supportedLocales)
                      RadioListTile<String?>(
                        value: locale.languageCode,
                        title: Text(lookupAppLocalizations(locale).languageName),
                      ),
                  ],
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
