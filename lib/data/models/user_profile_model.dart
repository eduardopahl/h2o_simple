import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_profile.dart';

part 'user_profile_model.g.dart';

@JsonSerializable()
class UserProfileModel {
  final String id;
  final String name;
  final int weight;
  final int defaultDailyGoal;
  final int wakeUpTime;
  final int sleepTime;
  final List<int> reminderIntervals;
  final bool notificationsEnabled;

  const UserProfileModel({
    required this.id,
    required this.name,
    required this.weight,
    required this.defaultDailyGoal,
    this.wakeUpTime = 420,
    this.sleepTime = 1380,
    this.reminderIntervals = const [60, 120, 180],
    this.notificationsEnabled = true,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);

  /// Converte o modelo para entidade de domínio
  UserProfile toEntity() {
    return UserProfile(
      id: id,
      name: name,
      weight: weight,
      defaultDailyGoal: defaultDailyGoal,
      wakeUpTime: wakeUpTime,
      sleepTime: sleepTime,
      reminderIntervals: reminderIntervals,
      notificationsEnabled: notificationsEnabled,
    );
  }

  /// Cria modelo a partir de entidade de domínio
  factory UserProfileModel.fromEntity(UserProfile entity) {
    return UserProfileModel(
      id: entity.id,
      name: entity.name,
      weight: entity.weight,
      defaultDailyGoal: entity.defaultDailyGoal,
      wakeUpTime: entity.wakeUpTime,
      sleepTime: entity.sleepTime,
      reminderIntervals: entity.reminderIntervals,
      notificationsEnabled: entity.notificationsEnabled,
    );
  }
}
