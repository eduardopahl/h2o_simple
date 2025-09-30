import '../entities/water_intake.dart';
import '../repositories/water_intake_repository.dart';

class AddWaterIntakeUseCase {
  final WaterIntakeRepository _repository;

  const AddWaterIntakeUseCase(this._repository);

  Future<WaterIntake> execute({
    required int amount,
    DateTime? timestamp,
    String? note,
  }) async {
    if (amount <= 0) {
      throw ArgumentError('Quantidade deve ser maior que zero');
    }

    if (amount > 2000) {
      throw ArgumentError('Quantidade não pode exceder 2000ml por ingestão');
    }

    final intakeTimestamp = timestamp ?? DateTime.now();
    if (intakeTimestamp.isAfter(DateTime.now())) {
      throw ArgumentError('Data não pode ser no futuro');
    }

    final intake = WaterIntake(
      id: _generateUniqueId(),
      amount: amount,
      timestamp: intakeTimestamp,
      note: note?.trim(),
    );

    await _repository.addWaterIntake(intake);

    return intake;
  }

  String _generateUniqueId() {
    return 'intake_${DateTime.now().microsecondsSinceEpoch}';
  }
}
