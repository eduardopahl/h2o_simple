import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/daily_goal.dart';
import '../../domain/repositories/daily_goal_repository.dart';
import '../models/daily_goal_model.dart';

class DailyGoalRepositoryImpl implements DailyGoalRepository {
  static const String _keyPrefix = 'daily_goals';
  static const String _allGoalsKey = 'all_daily_goals_dates';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  String _dateToKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Future<void> saveDailyGoal(DailyGoal goal) async {
    final prefs = await _prefs;
    final model = DailyGoalModel.fromEntity(goal);
    final dateKey = _dateToKey(goal.date);

    // Salva goal individual
    await prefs.setString('${_keyPrefix}_$dateKey', jsonEncode(model.toJson()));

    // Atualiza lista de todas as datas
    final allDates = await _getAllGoalDates();
    if (!allDates.contains(dateKey)) {
      allDates.add(dateKey);
      await prefs.setStringList(_allGoalsKey, allDates);
    }
  }

  @override
  Future<DailyGoal?> getDailyGoalByDate(DateTime date) async {
    final prefs = await _prefs;
    final dateKey = _dateToKey(date);
    final jsonString = prefs.getString('${_keyPrefix}_$dateKey');

    if (jsonString == null) return null;

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final model = DailyGoalModel.fromJson(json);
      return model.toEntity();
    } catch (e) {
      // Remove entrada inválida
      await removeDailyGoal(date);
      return null;
    }
  }

  @override
  Future<List<DailyGoal>> getDailyGoalsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final allDates = await _getAllGoalDates();
    final goals = <DailyGoal>[];

    for (final dateKey in allDates) {
      final parts = dateKey.split('-');
      if (parts.length == 3) {
        final date = DateTime(
          int.parse(parts[0]),
          int.parse(parts[1]),
          int.parse(parts[2]),
        );

        if (date.isAfter(startDate.subtract(const Duration(days: 1))) &&
            date.isBefore(endDate.add(const Duration(days: 1)))) {
          final goal = await getDailyGoalByDate(date);
          if (goal != null) {
            goals.add(goal);
          }
        }
      }
    }

    goals.sort((a, b) => a.date.compareTo(b.date));
    return goals;
  }

  @override
  Future<void> updateDailyGoalProgress(DateTime date, int currentAmount) async {
    final existingGoal = await getDailyGoalByDate(date);
    if (existingGoal != null) {
      final updatedGoal = existingGoal.copyWith(currentAmount: currentAmount);
      await saveDailyGoal(updatedGoal);
    }
  }

  @override
  Future<void> addIntakeIdToGoal(DateTime date, String intakeId) async {
    final existingGoal = await getDailyGoalByDate(date);
    if (existingGoal != null) {
      final updatedIds = List<String>.from(existingGoal.intakeIds);
      if (!updatedIds.contains(intakeId)) {
        updatedIds.add(intakeId);
        final updatedGoal = existingGoal.copyWith(intakeIds: updatedIds);
        await saveDailyGoal(updatedGoal);
      }
    }
  }

  @override
  Future<void> removeIntakeIdFromGoal(DateTime date, String intakeId) async {
    final existingGoal = await getDailyGoalByDate(date);
    if (existingGoal != null) {
      final updatedIds = List<String>.from(existingGoal.intakeIds);
      updatedIds.remove(intakeId);
      final updatedGoal = existingGoal.copyWith(intakeIds: updatedIds);
      await saveDailyGoal(updatedGoal);
    }
  }

  @override
  Future<void> removeDailyGoal(DateTime date) async {
    final prefs = await _prefs;
    final dateKey = _dateToKey(date);

    // Remove goal individual
    await prefs.remove('${_keyPrefix}_$dateKey');

    // Atualiza lista de datas
    final allDates = await _getAllGoalDates();
    allDates.remove(dateKey);
    await prefs.setStringList(_allGoalsKey, allDates);
  }

  @override
  Future<void> clearAllDailyGoals() async {
    final prefs = await _prefs;
    final allDates = await _getAllGoalDates();

    // Remove todos os goals individuais
    for (final dateKey in allDates) {
      await prefs.remove('${_keyPrefix}_$dateKey');
    }

    // Limpa lista de datas
    await prefs.remove(_allGoalsKey);
  }

  Future<List<String>> _getAllGoalDates() async {
    final prefs = await _prefs;
    return prefs.getStringList(_allGoalsKey) ?? [];
  }
}
