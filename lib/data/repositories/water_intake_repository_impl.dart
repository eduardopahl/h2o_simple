import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/water_intake.dart';
import '../../domain/repositories/water_intake_repository.dart';
import '../models/water_intake_model.dart';

class WaterIntakeRepositoryImpl implements WaterIntakeRepository {
  static const String _keyPrefix = 'water_intakes';
  static const String _allIntakesKey = 'all_water_intakes';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  @override
  Future<void> addWaterIntake(WaterIntake intake) async {
    final prefs = await _prefs;
    final model = WaterIntakeModel.fromEntity(intake);

    await prefs.setString(
      '${_keyPrefix}_${intake.id}',
      jsonEncode(model.toJson()),
    );

    final allIds = await _getAllIntakeIds();
    allIds.add(intake.id);
    await prefs.setStringList(_allIntakesKey, allIds);
  }

  @override
  Future<void> removeWaterIntake(String id) async {
    final prefs = await _prefs;

    await prefs.remove('${_keyPrefix}_$id');

    final allIds = await _getAllIntakeIds();
    allIds.remove(id);
    await prefs.setStringList(_allIntakesKey, allIds);
  }

  @override
  Future<List<WaterIntake>> getWaterIntakesByDate(DateTime date) async {
    final allIntakes = await getAllWaterIntakes();

    return allIntakes.where((intake) {
      final intakeDate = DateTime(
        intake.timestamp.year,
        intake.timestamp.month,
        intake.timestamp.day,
      );
      final targetDate = DateTime(date.year, date.month, date.day);
      return intakeDate.isAtSameMomentAs(targetDate);
    }).toList();
  }

  @override
  Future<List<WaterIntake>> getWaterIntakesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final allIntakes = await getAllWaterIntakes();

    return allIntakes.where((intake) {
      return intake.timestamp.isAfter(
            startDate.subtract(const Duration(days: 1)),
          ) &&
          intake.timestamp.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  @override
  Future<List<WaterIntake>> getAllWaterIntakes() async {
    final prefs = await _prefs;
    final allIds = await _getAllIntakeIds();
    final intakes = <WaterIntake>[];

    for (final id in allIds) {
      final jsonString = prefs.getString('${_keyPrefix}_$id');
      if (jsonString != null) {
        try {
          final json = jsonDecode(jsonString) as Map<String, dynamic>;
          final model = WaterIntakeModel.fromJson(json);
          intakes.add(model.toEntity());
        } catch (e) {
          await removeWaterIntake(id);
        }
      }
    }

    //TODO Remover essa parte, só mockado
    // Adicionando dados mockados para teste
    intakes.addAll(_generateMockData());

    intakes.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return intakes;
  }

  //TODO Mockados
  List<WaterIntake> _generateMockData() {
    final mockIntakes = <WaterIntake>[];
    final random = Random();

    // Gerar dados para os últimos 7 dias
    for (int dayOffset = 1; dayOffset <= 7; dayOffset++) {
      final date = DateTime.now().subtract(Duration(days: dayOffset));

      // Número aleatório de registros por dia (3-8)
      final recordsCount = 3 + random.nextInt(6);

      for (int i = 0; i < recordsCount; i++) {
        // Horários distribuídos durante o dia (6h às 22h)
        final hour = 6 + random.nextInt(17);
        final minute = random.nextInt(60);

        final timestamp = DateTime(
          date.year,
          date.month,
          date.day,
          hour,
          minute,
        );

        // Volumes variados
        final amounts = [150, 200, 250, 300, 500];
        final amount = amounts[random.nextInt(amounts.length)];

        // ID único para dados mockados
        final id = 'mock_${timestamp.millisecondsSinceEpoch}_$i';

        mockIntakes.add(
          WaterIntake(
            id: id,
            amount: amount,
            timestamp: timestamp,
            note: 'Dados de teste',
          ),
        );
      }
    }

    return mockIntakes;
  }

  @override
  Future<int> getTotalWaterIntakeByDate(DateTime date) async {
    final intakes = await getWaterIntakesByDate(date);
    return intakes.fold<int>(0, (total, intake) => total + intake.amount);
  }

  @override
  Future<void> clearAllWaterIntakes() async {
    final prefs = await _prefs;
    final allIds = await _getAllIntakeIds();

    for (final id in allIds) {
      await prefs.remove('${_keyPrefix}_$id');
    }

    await prefs.remove(_allIntakesKey);
  }

  Future<List<String>> _getAllIntakeIds() async {
    final prefs = await _prefs;
    return prefs.getStringList(_allIntakesKey) ?? [];
  }
}
