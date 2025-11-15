class DailyGoal {
  final DateTime date;
  final int currentAmount;
  final List<String> intakeIds;

  const DailyGoal({
    required this.date,
    this.currentAmount = 0,
    this.intakeIds = const [],
  });

  DailyGoal copyWith({
    DateTime? date,
    int? currentAmount,
    List<String>? intakeIds,
  }) {
    return DailyGoal(
      date: date ?? this.date,
      currentAmount: currentAmount ?? this.currentAmount,
      intakeIds: intakeIds ?? this.intakeIds,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DailyGoal &&
        other.date == date &&
        other.currentAmount == currentAmount &&
        other.intakeIds.length == intakeIds.length;
  }

  @override
  int get hashCode {
    return date.hashCode ^ currentAmount.hashCode ^ intakeIds.hashCode;
  }
}
