/// Sistema de eventos para comunicação entre business logic e UI
/// sem acoplamento direto com BuildContext

enum WaterIntakeEventType { goalAchieved, goalProgressUpdated, errorOccurred }

class WaterIntakeEvent {
  final WaterIntakeEventType type;
  final Map<String, dynamic> data;
  final DateTime timestamp;

  WaterIntakeEvent({required this.type, this.data = const {}})
    : timestamp = DateTime.now();

  /// Factory para evento de meta alcançada
  factory WaterIntakeEvent.goalAchieved({
    required int totalAmount,
    required int goalAmount,
  }) {
    return WaterIntakeEvent(
      type: WaterIntakeEventType.goalAchieved,
      data: {'totalAmount': totalAmount, 'goalAmount': goalAmount},
    );
  }

  /// Factory para evento de progresso da meta
  factory WaterIntakeEvent.goalProgressUpdated({
    required int totalAmount,
    required int goalAmount,
    required double progress,
  }) {
    return WaterIntakeEvent(
      type: WaterIntakeEventType.goalProgressUpdated,
      data: {
        'totalAmount': totalAmount,
        'goalAmount': goalAmount,
        'progress': progress,
      },
    );
  }

  /// Factory para evento de erro
  factory WaterIntakeEvent.error({required String message, Object? error}) {
    return WaterIntakeEvent(
      type: WaterIntakeEventType.errorOccurred,
      data: {'message': message, 'error': error},
    );
  }

  @override
  String toString() {
    return 'WaterIntakeEvent(type: $type, data: $data, timestamp: $timestamp)';
  }
}
