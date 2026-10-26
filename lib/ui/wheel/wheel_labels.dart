import '../../domain/wheel_service.dart';
import '../../l10n/l10n.dart';

extension ResetModeL10n on ResetMode {
  String labelIn(AppLocalizations l) => switch (this) {
    ResetMode.whenEmpty => l.wheelResetModeWhenEmpty,
    ResetMode.afterDays => l.wheelResetModeAfterDays,
    ResetMode.manual => l.wheelResetModeManual,
  };
}

extension WheelContentL10n on WheelContent {
  String labelIn(AppLocalizations l) => switch (this) {
    WheelContent.text => l.wheelContentText,
    WheelContent.photo => l.wheelContentPhoto,
    WheelContent.both => l.wheelContentBoth,
  };
}

extension WheelThemeKindL10n on WheelThemeKind {
  String labelIn(AppLocalizations l) => switch (this) {
    WheelThemeKind.classic => l.wheelThemeClassic,
    WheelThemeKind.pizza => l.wheelThemePizza,
    WheelThemeKind.burek => l.wheelThemeBurek,
    WheelThemeKind.sacher => l.wheelThemeSacher,
    WheelThemeKind.baklava => l.wheelThemeBaklava,
  };
}
