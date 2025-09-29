// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) =>
    UserProfileModel(
      id: json['id'] as String,
      name: json['name'] as String,
      weight: (json['weight'] as num).toInt(),
      defaultDailyGoal: (json['defaultDailyGoal'] as num).toInt(),
      wakeUpTime: (json['wakeUpTime'] as num?)?.toInt() ?? 420,
      sleepTime: (json['sleepTime'] as num?)?.toInt() ?? 1380,
      reminderIntervals:
          (json['reminderIntervals'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [60, 120, 180],
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
    );

Map<String, dynamic> _$UserProfileModelToJson(UserProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'weight': instance.weight,
      'defaultDailyGoal': instance.defaultDailyGoal,
      'wakeUpTime': instance.wakeUpTime,
      'sleepTime': instance.sleepTime,
      'reminderIntervals': instance.reminderIntervals,
      'notificationsEnabled': instance.notificationsEnabled,
    };
