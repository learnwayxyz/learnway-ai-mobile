import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:core/core.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  late SharedPreferences _prefs;

  ThemeCubit() : super(ThemeState.initial()) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      final savedTheme = _prefs.getString(themeKey);

      if (savedTheme != null) {
        final themeMode = AppThemeMode.values.firstWhere(
          (mode) => mode.name == savedTheme,
          orElse: () => AppThemeMode.system,
        );

        final brightness = _getCurrentBrightness(themeMode);
        emit(
          state.copyWith(themeMode: themeMode, currentBrightness: brightness),
        );
      }
    } catch (e) {
      debugPrint('Error loading theme: $e');
    }
  }

  Future<void> changeTheme(AppThemeMode newTheme) async {
    try {
      await _prefs.setString(themeKey, newTheme.name);

      final brightness = _getCurrentBrightness(newTheme);

      emit(state.copyWith(themeMode: newTheme, currentBrightness: brightness));

      _updateSystemUIOverlay(brightness);
    } catch (e) {
      debugPrint('Error saving theme: $e');
    }
  }

  void updateSystemBrightness(Brightness systemBrightness) {
    if (state.themeMode == AppThemeMode.system) {
      emit(state.copyWith(currentBrightness: systemBrightness));
      _updateSystemUIOverlay(systemBrightness);
    }
  }

  Brightness _getCurrentBrightness(AppThemeMode themeMode) {
    switch (themeMode) {
      case AppThemeMode.light:
        return Brightness.light;
      case AppThemeMode.dark:
        return Brightness.dark;
      case AppThemeMode.system:
        return WidgetsBinding.instance.platformDispatcher.platformBrightness;
    }
  }

  void _updateSystemUIOverlay(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: isDark
            ? const Color(0xFF111827)
            : Colors.white,
        systemNavigationBarIconBrightness: isDark
            ? Brightness.light
            : Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );
  }

  bool get isLightTheme => state.currentBrightness == Brightness.light;
  bool get isDarkTheme => state.currentBrightness == Brightness.dark;
  bool get isSystemTheme => state.themeMode == AppThemeMode.system;
}
