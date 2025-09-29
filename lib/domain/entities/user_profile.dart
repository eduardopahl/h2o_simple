class UserProfile {
  final String id;
  final String name;
  final int weight; // em kg
  final int defaultDailyGoal; // em ml
  final int wakeUpTime; // hora em minutos (ex: 7:00 = 420)
  final int sleepTime; // hora em minutos (ex: 23:00 = 1380)
  final List<int> reminderIntervals; // intervalos em minutos
  final bool notificationsEnabled;

  const UserProfile({
    required this.id,
    required this.name,
    required this.weight,
    required this.defaultDailyGoal,
    this.wakeUpTime = 420, // 7:00 AM
    this.sleepTime = 1380, // 11:00 PM
    this.reminderIntervals = const [60, 120, 180], // 1h, 2h, 3h
    this.notificationsEnabled = true,
  });

  /// Calcula meta de água baseada no peso (35ml por kg)
  int get recommendedDailyGoal => weight * 35;

  /// Converte minutos para hora formatada (ex: 420 -> "07:00")
  String minutesToTimeString(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}';
  }

  String get wakeUpTimeString => minutesToTimeString(wakeUpTime);
  String get sleepTimeString => minutesToTimeString(sleepTime);

  UserProfile copyWith({
    String? id,
    String? name,
    int? weight,
    int? defaultDailyGoal,
    int? wakeUpTime,
    int? sleepTime,
    List<int>? reminderIntervals,
    bool? notificationsEnabled,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      weight: weight ?? this.weight,
      defaultDailyGoal: defaultDailyGoal ?? this.defaultDailyGoal,
      wakeUpTime: wakeUpTime ?? this.wakeUpTime,
      sleepTime: sleepTime ?? this.sleepTime,
      reminderIntervals: reminderIntervals ?? this.reminderIntervals,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile &&
        other.id == id &&
        other.name == name &&
        other.weight == weight &&
        other.defaultDailyGoal == defaultDailyGoal &&
        other.wakeUpTime == wakeUpTime &&
        other.sleepTime == sleepTime &&
        other.notificationsEnabled == notificationsEnabled;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        weight.hashCode ^
        defaultDailyGoal.hashCode ^
        wakeUpTime.hashCode ^
        sleepTime.hashCode ^
        notificationsEnabled.hashCode;
  }
}
