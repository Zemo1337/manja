import '../l10n/l10n.dart';
import 'app_theme.dart';

extension AppThemeKindL10n on AppThemeKind {
  String labelIn(AppLocalizations l) => switch (this) {
    AppThemeKind.manja => l.themeManja,
    AppThemeKind.neutral => l.themeNeutral,
    AppThemeKind.dev => l.themeDev,
  };

  String descriptionIn(AppLocalizations l) => switch (this) {
    AppThemeKind.manja => l.themeManjaDescription,
    AppThemeKind.neutral => l.themeNeutralDescription,
    AppThemeKind.dev => l.themeDevDescription,
  };
}

extension AppBrightnessL10n on AppBrightness {
  String labelIn(AppLocalizations l) => switch (this) {
    AppBrightness.system => l.themeBrightnessSystem,
    AppBrightness.light => l.themeBrightnessLight,
    AppBrightness.dark => l.themeBrightnessDark,
  };
}
