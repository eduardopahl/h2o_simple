import 'package:flutter/material.dart';

class ThemeSettings {
  final ThemeMode themeMode;

  const ThemeSettings({this.themeMode = ThemeMode.light});

  ThemeSettings copyWith({ThemeMode? themeMode}) {
    return ThemeSettings(themeMode: themeMode ?? this.themeMode);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ThemeSettings && other.themeMode == themeMode;
  }

  @override
  int get hashCode => themeMode.hashCode;

  @override
  String toString() => 'ThemeSettings(themeMode: $themeMode)';
}
