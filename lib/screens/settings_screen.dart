import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final state = AppScope.of(context);
    final theme = Theme.of(context);
    final p = Palette.of(context);

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        children: [
          Text(s.settings, style: theme.textTheme.headlineMedium),
          const SizedBox(height: 24),

          _SectionLabel(s.appearance),
          _Card(
            child: Row(children: [
              for (final (mode, icon, label) in [
                (ThemeMode.light, Icons.light_mode_rounded, s.light),
                (ThemeMode.dark, Icons.dark_mode_rounded, s.dark),
                (ThemeMode.system, Icons.brightness_auto_rounded, s.system),
              ])
                Expanded(
                  child: _ThemeOption(
                    icon: icon,
                    label: label,
                    mode: mode,
                    selected: state.themeMode == mode,
                    onTap: () => state.setThemeMode(mode),
                  ),
                ),
            ]),
          ),
          const SizedBox(height: 24),

          _SectionLabel(s.language),
          _Card(
            padding: EdgeInsets.zero,
            child: Column(children: [
              _LanguageTile(
                flag: '🇹🇭',
                title: 'ภาษาไทย',
                subtitle: 'Thai',
                selected: state.locale.languageCode == 'th',
                onTap: () => state.setLanguage('th'),
              ),
              Divider(indent: 72, color: p.surfaceAlt),
              _LanguageTile(
                flag: '🇬🇧',
                title: 'English',
                subtitle: 'อังกฤษ',
                selected: state.locale.languageCode == 'en',
                onTap: () => state.setLanguage('en'),
              ),
            ]),
          ),
          const SizedBox(height: 24),

          _SectionLabel(s.about),
          _Card(
            padding: EdgeInsets.zero,
            child: Column(children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.restaurant_rounded, color: Colors.white, size: 20),
                ),
                title: Text(s.appName, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(s.aboutText, style: TextStyle(color: p.muted)),
              ),
              Divider(indent: 72, color: p.surfaceAlt),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                leading: SizedBox(
                    width: 40, child: Icon(Icons.info_outline_rounded, color: p.muted)),
                title: Text(s.version),
                trailing: Text('1.0.0', style: TextStyle(color: p.muted)),
              ),
              Divider(indent: 72, color: p.surfaceAlt),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                enabled: state.favorites.isNotEmpty,
                leading: SizedBox(
                  width: 40,
                  child: Icon(Icons.delete_outline_rounded,
                      color: state.favorites.isNotEmpty ? Colors.redAccent : p.muted),
                ),
                title: Text(s.clearFavorites,
                    style: TextStyle(
                        color: state.favorites.isNotEmpty ? Colors.redAccent : p.muted)),
                onTap: () => _confirmClear(context, s, state),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmClear(BuildContext context, S s, AppState state) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(s.clearFavoritesConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(s.cancel)),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(s.clear)),
        ],
      ),
    );
    if (ok == true) state.clearFavorites();
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(text.toUpperCase(),
          style: TextStyle(
            color: Palette.of(context).muted,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          )),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, this.padding = const EdgeInsets.all(8)});

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(22),
      clipBehavior: Clip.antiAlias,
      child: Padding(padding: padding, child: child),
    );
  }
}

/// Mini phone-preview tile for picking a theme.
class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.mode,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final ThemeMode mode;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = Palette.of(context);
    final accent = theme.colorScheme.primary;

    Widget preview(Color bg, Color card) => Container(
          color: bg,
          padding: const EdgeInsets.all(6),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(width: 22, height: 4, color: accent),
            const SizedBox(height: 5),
            Expanded(
              child: Container(
                decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(4)),
              ),
            ),
          ]),
        );

    final lightPreview = preview(AppColors.lightBg, AppColors.lightSurfaceAlt);
    final darkPreview = preview(AppColors.darkBg, AppColors.darkSurfaceAlt);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selected ? accent.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? accent : Colors.transparent, width: 1.5),
        ),
        child: Column(children: [
          AspectRatio(
            aspectRatio: 0.8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: DecoratedBox(
                position: DecorationPosition.foreground,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: p.surfaceAlt),
                ),
                child: switch (mode) {
                  ThemeMode.light => lightPreview,
                  ThemeMode.dark => darkPreview,
                  ThemeMode.system => Row(children: [
                      Expanded(child: lightPreview),
                      Expanded(child: darkPreview),
                    ]),
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, size: 16, color: selected ? accent : p.muted),
            const SizedBox(width: 4),
            Flexible(
              child: Text(label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: selected ? accent : theme.colorScheme.onSurface,
                  )),
            ),
          ]),
        ]),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.flag,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String flag;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = Palette.of(context);
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: p.surfaceAlt, borderRadius: BorderRadius.circular(12)),
        child: Text(flag, style: const TextStyle(fontSize: 20)),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: TextStyle(color: p.muted)),
      trailing: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: selected
            ? Icon(Icons.check_circle_rounded, key: const ValueKey(1), color: theme.colorScheme.primary)
            : Icon(Icons.circle_outlined, key: const ValueKey(0), color: p.surfaceAlt),
      ),
    );
  }
}
