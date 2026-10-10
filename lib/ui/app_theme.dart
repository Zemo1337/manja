import 'package:flutter/material.dart';

import '../data/database.dart';

enum AppThemeKind {
  manja('Manja', 'Paprika, basil and saffron'),
  neutral('Neutral', 'Calm slate and grey'),
  dev('Dev', 'Charcoal and yellow, always dark');

  const AppThemeKind(this.label, this.description);

  final String label;
  final String description;

  bool get alwaysDark => this == dev;
}

enum AppBrightness {
  system('System'),
  light('Light'),
  dark('Dark');

  const AppBrightness(this.label);

  final String label;
}

class AppearanceController extends ChangeNotifier {
  AppearanceController(this.db);

  static const _keyTheme = 'app.theme';
  static const _keyBrightness = 'app.brightness';

  final AppDatabase db;
  AppThemeKind _theme = AppThemeKind.manja;
  AppBrightness _brightness = AppBrightness.system;

  AppThemeKind get theme => _theme;
  AppBrightness get brightness => _brightness;

  ThemeMode get themeMode {
    if (_theme.alwaysDark) return ThemeMode.dark;
    return switch (_brightness) {
      AppBrightness.system => ThemeMode.system,
      AppBrightness.light => ThemeMode.light,
      AppBrightness.dark => ThemeMode.dark,
    };
  }

  Future<void> load() async {
    _theme = AppThemeKind.values.asNameMap()[await db.getSetting(_keyTheme)] ?? AppThemeKind.manja;
    _brightness = AppBrightness.values.asNameMap()[await db.getSetting(_keyBrightness)] ?? AppBrightness.system;
    notifyListeners();
  }

  Future<void> setTheme(AppThemeKind theme) async {
    _theme = theme;
    notifyListeners();
    await db.setSetting(_keyTheme, theme.name);
  }

  Future<void> setBrightness(AppBrightness brightness) async {
    _brightness = brightness;
    notifyListeners();
    await db.setSetting(_keyBrightness, brightness.name);
  }
}

ColorScheme appColorScheme(AppThemeKind kind, Brightness brightness) {
  final dark = brightness == Brightness.dark || kind.alwaysDark;
  return switch (kind) {
    AppThemeKind.manja => dark ? _manjaDark : _manjaLight,
    AppThemeKind.neutral => ColorScheme.fromSeed(
      seedColor: const Color(0xFF4F6D8F),
      brightness: dark ? Brightness.dark : Brightness.light,
      dynamicSchemeVariant: DynamicSchemeVariant.neutral,
    ),
    AppThemeKind.dev => _dev,
  };
}

({Color background, Color foreground, Color title}) appHeaderColors(AppThemeKind kind, ColorScheme scheme) =>
    switch (kind) {
      AppThemeKind.manja when scheme.brightness == Brightness.light => (
        background: scheme.primary,
        foreground: scheme.onPrimary,
        title: const Color(0xFFFFF4EC),
      ),
      AppThemeKind.manja => (
        background: const Color(0xFF5C1F05),
        foreground: const Color(0xFFFFDBCC),
        title: const Color(0xFFFFC94D),
      ),
      _ => (background: scheme.surface, foreground: scheme.onSurface, title: scheme.primary),
    };

const appTitleFont = 'Lobster';

({Color background, Color foreground}) appHighlightColors(AppThemeKind kind, ColorScheme scheme) => switch (kind) {
  AppThemeKind.manja => (background: scheme.tertiaryContainer, foreground: scheme.onTertiaryContainer),
  _ => (background: scheme.primaryContainer, foreground: scheme.onPrimaryContainer),
};

ThemeData appTheme(AppThemeKind kind, Brightness brightness) {
  final scheme = appColorScheme(kind, brightness);
  final header = appHeaderColors(kind, scheme);
  final highlight = appHighlightColors(kind, scheme);
  return ThemeData(
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: header.background,
      foregroundColor: header.foreground,
      titleTextStyle: TextStyle(fontFamily: appTitleFont, fontSize: 26, color: header.title),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: scheme.surfaceContainer,
      indicatorColor: highlight.background,
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected) ? highlight.foreground : scheme.onSurfaceVariant,
        ),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: scheme.secondaryContainer,
      foregroundColor: scheme.onSecondaryContainer,
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    extensions: [HighlightColors(background: highlight.background, foreground: highlight.foreground)],
  );
}

class HighlightColors extends ThemeExtension<HighlightColors> {
  const HighlightColors({required this.background, required this.foreground});

  final Color background;
  final Color foreground;

  static HighlightColors of(BuildContext context) {
    final theme = Theme.of(context);
    return theme.extension<HighlightColors>() ??
        HighlightColors(
          background: theme.colorScheme.primaryContainer,
          foreground: theme.colorScheme.onPrimaryContainer,
        );
  }

  @override
  HighlightColors copyWith({Color? background, Color? foreground}) =>
      HighlightColors(background: background ?? this.background, foreground: foreground ?? this.foreground);

  @override
  HighlightColors lerp(HighlightColors? other, double t) => other == null
      ? this
      : HighlightColors(
          background: Color.lerp(background, other.background, t)!,
          foreground: Color.lerp(foreground, other.foreground, t)!,
        );
}

const _paprika = Color(0xFFC2410C);
const _basil = Color(0xFF2E7D32);
const _saffron = Color(0xFFE9A000);

final _manjaLight = ColorScheme.fromSeed(
  seedColor: _paprika,
  dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
  primary: _paprika,
  onPrimary: Colors.white,
  primaryContainer: const Color(0xFFFFDBCC),
  onPrimaryContainer: const Color(0xFF5C1A00),
  secondary: _basil,
  onSecondary: Colors.white,
  secondaryContainer: const Color(0xFFCDE8CE),
  onSecondaryContainer: const Color(0xFF0B3D10),
  tertiary: _saffron,
  onTertiary: Colors.black,
  tertiaryContainer: const Color(0xFFFFE8A3),
  onTertiaryContainer: const Color(0xFF3D2C00),
  surface: const Color(0xFFFCFAF8),
  onSurface: const Color(0xFF1C1B1A),
  onSurfaceVariant: const Color(0xFF55504C),
  surfaceContainerLowest: Colors.white,
  surfaceContainerLow: const Color(0xFFF7F4F2),
  surfaceContainer: const Color(0xFFF2EFEC),
  surfaceContainerHigh: const Color(0xFFECE8E5),
  surfaceContainerHighest: const Color(0xFFE6E2DF),
  outline: const Color(0xFF857F7A),
  outlineVariant: const Color(0xFFD7D1CC),
);

final _manjaDark = ColorScheme.fromSeed(
  seedColor: _paprika,
  brightness: Brightness.dark,
  dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
  primary: const Color(0xFFFF8A5B),
  onPrimary: const Color(0xFF4A1500),
  primaryContainer: const Color(0xFF7A2A00),
  onPrimaryContainer: const Color(0xFFFFDBCC),
  secondary: const Color(0xFF81C784),
  onSecondary: const Color(0xFF0B3D10),
  secondaryContainer: const Color(0xFF1B5E20),
  onSecondaryContainer: const Color(0xFFCDE8CE),
  tertiary: const Color(0xFFFFC94D),
  onTertiary: const Color(0xFF3D2C00),
  tertiaryContainer: const Color(0xFF5C4300),
  onTertiaryContainer: const Color(0xFFFFE8A3),
  surface: const Color(0xFF1E1B19),
  onSurface: const Color(0xFFEDE7E3),
  onSurfaceVariant: const Color(0xFFCFC6C0),
  surfaceContainerLowest: const Color(0xFF191614),
  surfaceContainerLow: const Color(0xFF231F1D),
  surfaceContainer: const Color(0xFF262220),
  surfaceContainerHigh: const Color(0xFF2B2725),
  surfaceContainerHighest: const Color(0xFF36312E),
  outline: const Color(0xFF9A928D),
  outlineVariant: const Color(0xFF4A4542),
);

const _charcoal = Color(0xFF202020);
const _yellow = Color(0xFFFFD300);

final _dev = ColorScheme.fromSeed(
  seedColor: _yellow,
  brightness: Brightness.dark,
  dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
  primary: _yellow,
  onPrimary: _charcoal,
  primaryContainer: const Color(0xFF4D4000),
  onPrimaryContainer: const Color(0xFFFFE680),
  secondary: const Color(0xFFBDBDBD),
  onSecondary: _charcoal,
  secondaryContainer: const Color(0xFF3D3D3D),
  onSecondaryContainer: const Color(0xFFEDEDED),
  tertiary: _yellow,
  onTertiary: _charcoal,
  surface: _charcoal,
  onSurface: const Color(0xFFEDEDED),
  onSurfaceVariant: const Color(0xFFBDBDBD),
  surfaceContainerLowest: const Color(0xFF1A1A1A),
  surfaceContainerLow: const Color(0xFF262626),
  surfaceContainer: const Color(0xFF2B2B2B),
  surfaceContainerHigh: const Color(0xFF333333),
  surfaceContainerHighest: const Color(0xFF3D3D3D),
  outline: const Color(0xFF8A8A8A),
  outlineVariant: const Color(0xFF474747),
);

class HeaderTextButton extends StatelessWidget {
  const HeaderTextButton({super.key, required this.onPressed, required this.label});

  final VoidCallback? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).appBarTheme.foregroundColor ?? Theme.of(context).colorScheme.onSurface;
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: color,
        disabledForegroundColor: color.withValues(alpha: 0.5),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
      ),
      child: Text(label),
    );
  }
}
