class UserProfile {
  final String id;
  final String name;
  final int weight;
  final int defaultDailyGoal;
  final int wakeUpTime;
  final int sleepTime;
  final List<int> reminderIntervals;
  final bool notificationsEnabled;

  const UserProfile({
    required this.id,
    required this.name,
    required this.weight,
    required this.defaultDailyGoal,
    this.wakeUpTime = 420,
    this.sleepTime = 1380,
    this.reminderIntervals = const [60, 120, 180],
    this.notificationsEnabled = true,
  });

  int get recommendedDailyGoal => weight * 35;

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
