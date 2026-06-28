part of 'theme_cubit.dart';

enum AppThemeMode { light, dark, system }

class ThemeState extends Equatable {
  final AppThemeMode themeMode;
  final Brightness currentBrightness;

  const ThemeState({required this.themeMode, required this.currentBrightness});

  factory ThemeState.initial() {
    return const ThemeState(
      themeMode: AppThemeMode.system,
      currentBrightness: Brightness.light,
    );
  }

  ThemeState copyWith({
    AppThemeMode? themeMode,
    Brightness? currentBrightness,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      currentBrightness: currentBrightness ?? this.currentBrightness,
    );
  }

  @override
  List<Object> get props => [themeMode, currentBrightness];
}
