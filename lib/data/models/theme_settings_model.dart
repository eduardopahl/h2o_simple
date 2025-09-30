import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/theme_settings.dart';

part 'theme_settings_model.g.dart';

@JsonSerializable()
class ThemeSettingsModel {
  @JsonKey(name: 'theme_mode_index')
  final int themeModeIndex;

  const ThemeSettingsModel({
    this.themeModeIndex = 0, // ThemeMode.light por padrão
  });

  factory ThemeSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$ThemeSettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ThemeSettingsModelToJson(this);

  ThemeSettings toEntity() {
    return ThemeSettings(themeMode: ThemeMode.values[themeModeIndex]);
  }

  factory ThemeSettingsModel.fromEntity(ThemeSettings entity) {
    return ThemeSettingsModel(themeModeIndex: entity.themeMode.index);
  }
}
