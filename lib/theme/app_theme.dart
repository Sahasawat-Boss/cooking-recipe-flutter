import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Warm, editorial palette: cream + charcoal with a saffron-terracotta accent.
class AppColors {
  static const accent = Color(0xFFE8663D);
  static const accentDark = Color(0xFFFF8A5B);
  static const gold = Color(0xFFF2B541);

  static const lightBg = Color(0xFFF8F5F0);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightSurfaceAlt = Color(0xFFF0EBE3);
  static const lightText = Color(0xFF1C1A17);
  static const lightMuted = Color(0xFF8A847B);

  static const darkBg = Color(0xFF0E0E0F);
  static const darkSurface = Color(0xFF19191B);
  static const darkSurfaceAlt = Color(0xFF242427);
  static const darkText = Color(0xFFF5F2EC);
  static const darkMuted = Color(0xFF9A958D);
}

/// Extra semantic colors not covered by ColorScheme.
class Palette extends ThemeExtension<Palette> {
  const Palette({required this.surfaceAlt, required this.muted, required this.gold});

  final Color surfaceAlt;
  final Color muted;
  final Color gold;

  static Palette of(BuildContext context) => Theme.of(context).extension<Palette>()!;

  @override
  Palette copyWith({Color? surfaceAlt, Color? muted, Color? gold}) => Palette(
        surfaceAlt: surfaceAlt ?? this.surfaceAlt,
        muted: muted ?? this.muted,
        gold: gold ?? this.gold,
      );

  @override
  Palette lerp(Palette? other, double t) {
    if (other == null) return this;
    return Palette(
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      gold: Color.lerp(gold, other.gold, t)!,
    );
  }
}

class AppTheme {
  static ThemeData light() => _build(
        brightness: Brightness.light,
        accent: AppColors.accent,
        bg: AppColors.lightBg,
        surface: AppColors.lightSurface,
        surfaceAlt: AppColors.lightSurfaceAlt,
        text: AppColors.lightText,
        muted: AppColors.lightMuted,
      );

  static ThemeData dark() => _build(
        brightness: Brightness.dark,
        accent: AppColors.accentDark,
        bg: AppColors.darkBg,
        surface: AppColors.darkSurface,
        surfaceAlt: AppColors.darkSurfaceAlt,
        text: AppColors.darkText,
        muted: AppColors.darkMuted,
      );

  static ThemeData _build({
    required Brightness brightness,
    required Color accent,
    required Color bg,
    required Color surface,
    required Color surfaceAlt,
    required Color text,
    required Color muted,
  }) {
    final scheme = ColorScheme.fromSeed(
      seedColor: accent,
      brightness: brightness,
    ).copyWith(
      primary: accent,
      onPrimary: Colors.white,
      surface: surface,
      onSurface: text,
      onSurfaceVariant: muted,
      surfaceContainerHighest: surfaceAlt,
      outlineVariant: surfaceAlt,
    );

    final base = ThemeData(brightness: brightness, useMaterial3: true);
    final textTheme = GoogleFonts.promptTextTheme(base.textTheme).apply(
      bodyColor: text,
      displayColor: text,
    );

    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: bg,
      textTheme: textTheme.copyWith(
        headlineLarge: textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w600, height: 1.2, letterSpacing: -0.5),
        headlineMedium: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600, height: 1.2, letterSpacing: -0.3),
        titleLarge: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        titleMedium: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      extensions: [Palette(surfaceAlt: surfaceAlt, muted: muted, gold: AppColors.gold)],
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        foregroundColor: text,
        titleTextStyle: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: accent.withValues(alpha: 0.14),
        elevation: 0,
        height: 68,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (s) => GoogleFonts.prompt(
            fontSize: 12,
            fontWeight: s.contains(WidgetState.selected) ? FontWeight.w600 : FontWeight.w400,
            color: s.contains(WidgetState.selected) ? accent : muted,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (s) => IconThemeData(color: s.contains(WidgetState.selected) ? accent : muted),
        ),
      ),
      dividerTheme: DividerThemeData(color: surfaceAlt, thickness: 1, space: 1),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: brightness == Brightness.light ? AppColors.lightText : surfaceAlt,
        contentTextStyle: GoogleFonts.prompt(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
      }),
    );
  }
}
