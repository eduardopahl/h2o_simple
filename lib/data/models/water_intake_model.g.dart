// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_intake_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WaterIntakeModel _$WaterIntakeModelFromJson(Map<String, dynamic> json) =>
    WaterIntakeModel(
      id: json['id'] as String,
      amount: (json['amount'] as num).toInt(),
      timestamp: WaterIntakeModel._dateTimeFromMilliseconds(
        (json['timestamp'] as num).toInt(),
      ),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$WaterIntakeModelToJson(WaterIntakeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'timestamp': WaterIntakeModel._dateTimeToMilliseconds(instance.timestamp),
      'note': instance.note,
    };
