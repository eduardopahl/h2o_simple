import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/water_intake.dart';

part 'water_intake_model.g.dart';

@JsonSerializable()
class WaterIntakeModel {
  final String id;
  final int amount;
  @JsonKey(
    name: 'timestamp',
    fromJson: _dateTimeFromMilliseconds,
    toJson: _dateTimeToMilliseconds,
  )
  final DateTime timestamp;
  final String? note;

  const WaterIntakeModel({
    required this.id,
    required this.amount,
    required this.timestamp,
    this.note,
  });

  factory WaterIntakeModel.fromJson(Map<String, dynamic> json) =>
      _$WaterIntakeModelFromJson(json);

  Map<String, dynamic> toJson() => _$WaterIntakeModelToJson(this);

  WaterIntake toEntity() {
    return WaterIntake(
      id: id,
      amount: amount,
      timestamp: timestamp,
      note: note,
    );
  }

  factory WaterIntakeModel.fromEntity(WaterIntake entity) {
    return WaterIntakeModel(
      id: entity.id,
      amount: entity.amount,
      timestamp: entity.timestamp,
      note: entity.note,
    );
  }

  static DateTime _dateTimeFromMilliseconds(int milliseconds) =>
      DateTime.fromMillisecondsSinceEpoch(milliseconds);

  static int _dateTimeToMilliseconds(DateTime dateTime) =>
      dateTime.millisecondsSinceEpoch;
}
