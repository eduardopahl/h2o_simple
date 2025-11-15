// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_goal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyGoalModel _$DailyGoalModelFromJson(
  Map<String, dynamic> json,
) => DailyGoalModel(
  date: DailyGoalModel._dateTimeFromMilliseconds((json['date'] as num).toInt()),
  currentAmount: (json['currentAmount'] as num?)?.toInt() ?? 0,
  intakeIds:
      (json['intakeIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$DailyGoalModelToJson(DailyGoalModel instance) =>
    <String, dynamic>{
      'date': DailyGoalModel._dateTimeToMilliseconds(instance.date),
      'currentAmount': instance.currentAmount,
      'intakeIds': instance.intakeIds,
    };
