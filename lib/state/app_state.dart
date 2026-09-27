import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App-wide settings and favorites, persisted with SharedPreferences.
class AppState extends ChangeNotifier {
  AppState._(this._prefs)
      : _themeMode = ThemeMode.values[_prefs.getInt(_kTheme) ?? ThemeMode.system.index],
        _locale = Locale(_prefs.getString(_kLang) ?? _defaultLang()),
        _favorites = {...?_prefs.getStringList(_kFavorites)};

  static const _kTheme = 'theme_mode';
  static const _kLang = 'language';
  static const _kFavorites = 'favorites';

  static Future<AppState> load() async =>
      AppState._(await SharedPreferences.getInstance());

  static String _defaultLang() {
    final code = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    return code == 'th' ? 'th' : 'en';
  }

  final SharedPreferences _prefs;
  ThemeMode _themeMode;
  Locale _locale;
  final Set<String> _favorites;

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  Set<String> get favorites => Set.unmodifiable(_favorites);

  void setThemeMode(ThemeMode mode) {
    if (mode == _themeMode) return;
    _themeMode = mode;
    _prefs.setInt(_kTheme, mode.index);
    notifyListeners();
  }

  void setLanguage(String code) {
    if (code == _locale.languageCode) return;
    _locale = Locale(code);
    _prefs.setString(_kLang, code);
    notifyListeners();
  }

  bool isFavorite(String id) => _favorites.contains(id);

  /// Returns true if the recipe is now a favorite.
  bool toggleFavorite(String id) {
    final added = _favorites.add(id);
    if (!added) _favorites.remove(id);
    _prefs.setStringList(_kFavorites, _favorites.toList());
    notifyListeners();
    return added;
  }

  void clearFavorites() {
    _favorites.clear();
    _prefs.remove(_kFavorites);
    notifyListeners();
  }
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
      : super(notifier: state);

  static AppState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;

  /// Access without subscribing to rebuilds (for callbacks).
  static AppState read(BuildContext context) =>
      context.getInheritedWidgetOfExactType<AppScope>()!.notifier!;
}
