class DailyGoal {
  final int targetAmount; // em ml
  final DateTime date;
  final int currentAmount; // em ml
  final List<String> intakeIds; // IDs dos registros de água do dia

  const DailyGoal({
    required this.targetAmount,
    required this.date,
    this.currentAmount = 0,
    this.intakeIds = const [],
  });

  double get progressPercentage =>
      targetAmount > 0 ? (currentAmount / targetAmount).clamp(0.0, 1.0) : 0.0;

  bool get isCompleted => currentAmount >= targetAmount;

  int get remainingAmount =>
      targetAmount - currentAmount > 0 ? targetAmount - currentAmount : 0;

  DailyGoal copyWith({
    int? targetAmount,
    DateTime? date,
    int? currentAmount,
    List<String>? intakeIds,
  }) {
    return DailyGoal(
      targetAmount: targetAmount ?? this.targetAmount,
      date: date ?? this.date,
      currentAmount: currentAmount ?? this.currentAmount,
      intakeIds: intakeIds ?? this.intakeIds,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DailyGoal &&
        other.targetAmount == targetAmount &&
        other.date == date &&
        other.currentAmount == currentAmount &&
        other.intakeIds.length == intakeIds.length;
  }

  @override
  int get hashCode {
    return targetAmount.hashCode ^
        date.hashCode ^
        currentAmount.hashCode ^
        intakeIds.hashCode;
  }
}
