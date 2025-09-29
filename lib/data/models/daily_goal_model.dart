import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/daily_goal.dart';

part 'daily_goal_model.g.dart';

@JsonSerializable()
class DailyGoalModel {
  final int targetAmount;
  @JsonKey(
    name: 'date',
    fromJson: _dateTimeFromMilliseconds,
    toJson: _dateTimeToMilliseconds,
  )
  final DateTime date;
  final int currentAmount;
  final List<String> intakeIds;

  const DailyGoalModel({
    required this.targetAmount,
    required this.date,
    this.currentAmount = 0,
    this.intakeIds = const [],
  });

  factory DailyGoalModel.fromJson(Map<String, dynamic> json) =>
      _$DailyGoalModelFromJson(json);

  Map<String, dynamic> toJson() => _$DailyGoalModelToJson(this);

  /// Converte o modelo para entidade de domínio
  DailyGoal toEntity() {
    return DailyGoal(
      targetAmount: targetAmount,
      date: date,
      currentAmount: currentAmount,
      intakeIds: intakeIds,
    );
  }

  /// Cria modelo a partir de entidade de domínio
  factory DailyGoalModel.fromEntity(DailyGoal entity) {
    return DailyGoalModel(
      targetAmount: entity.targetAmount,
      date: entity.date,
      currentAmount: entity.currentAmount,
      intakeIds: entity.intakeIds,
    );
  }

  static DateTime _dateTimeFromMilliseconds(int milliseconds) =>
      DateTime.fromMillisecondsSinceEpoch(milliseconds);

  static int _dateTimeToMilliseconds(DateTime dateTime) =>
      dateTime.millisecondsSinceEpoch;
}
