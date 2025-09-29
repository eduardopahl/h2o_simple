class WaterIntake {
  final String id;
  final int amount;
  final DateTime timestamp;
  final String? note;

  const WaterIntake({
    required this.id,
    required this.amount,
    required this.timestamp,
    this.note,
  });

  WaterIntake copyWith({
    String? id,
    int? amount,
    DateTime? timestamp,
    String? note,
  }) {
    return WaterIntake(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      timestamp: timestamp ?? this.timestamp,
      note: note ?? this.note,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WaterIntake &&
        other.id == id &&
        other.amount == amount &&
        other.timestamp == timestamp &&
        other.note == note;
  }

  @override
  int get hashCode {
    return id.hashCode ^ amount.hashCode ^ timestamp.hashCode ^ note.hashCode;
  }
}
