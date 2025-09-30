import '../entities/water_intake.dart';
import '../repositories/water_intake_repository.dart';

class CalculateHydrationStatsUseCase {
  final WaterIntakeRepository _repository;

  const CalculateHydrationStatsUseCase(this._repository);

  Future<HydrationStats> calculateDailyStats(DateTime date) async {
    final intakes = await _repository.getWaterIntakesByDate(date);

    if (intakes.isEmpty) {
      return HydrationStats.empty(date);
    }

    final totalAmount = intakes.fold<int>(
      0,
      (sum, intake) => sum + intake.amount,
    );
    final averagePerIntake = (totalAmount / intakes.length).round();

    final sortedIntakes = List<WaterIntake>.from(intakes)
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return HydrationStats(
      date: date,
      totalAmount: totalAmount,
      intakeCount: intakes.length,
      averagePerIntake: averagePerIntake,
      firstIntake: sortedIntakes.first.timestamp,
      lastIntake: sortedIntakes.last.timestamp,
      morningAmount: _calculatePeriodAmount(intakes, 6, 12),
      afternoonAmount: _calculatePeriodAmount(intakes, 12, 18),
      eveningAmount: _calculatePeriodAmount(intakes, 18, 24),
      nightAmount: _calculatePeriodAmount(intakes, 0, 6),
    );
  }

  Future<WeeklyHydrationStats> calculateWeeklyStats(
    DateTime weekStartDate,
  ) async {
    final weekStart = _getWeekStart(weekStartDate);
    final weekEnd = weekStart.add(const Duration(days: 6));

    final intakes = await _repository.getWaterIntakesByDateRange(
      weekStart,
      weekEnd,
    );

    final dailyTotals = <DateTime, int>{};
    for (int i = 0; i < 7; i++) {
      final day = weekStart.add(Duration(days: i));
      final dayKey = DateTime(day.year, day.month, day.day);
      dailyTotals[dayKey] = 0;
    }

    for (final intake in intakes) {
      final dayKey = DateTime(
        intake.timestamp.year,
        intake.timestamp.month,
        intake.timestamp.day,
      );
      dailyTotals[dayKey] = (dailyTotals[dayKey] ?? 0) + intake.amount;
    }

    final totalWeekAmount = dailyTotals.values.fold<int>(
      0,
      (sum, amount) => sum + amount,
    );
    final daysWithIntake =
        dailyTotals.values.where((amount) => amount > 0).length;
    final averagePerDay =
        daysWithIntake > 0 ? (totalWeekAmount / daysWithIntake).round() : 0;

    return WeeklyHydrationStats(
      weekStart: weekStart,
      weekEnd: weekEnd,
      totalAmount: totalWeekAmount,
      averagePerDay: averagePerDay,
      daysWithIntake: daysWithIntake,
      dailyTotals: dailyTotals,
      bestDay: _getBestDay(dailyTotals),
      consistency: _calculateConsistency(dailyTotals),
    );
  }

  int _calculatePeriodAmount(
    List<WaterIntake> intakes,
    int startHour,
    int endHour,
  ) {
    return intakes
        .where((intake) {
          final hour = intake.timestamp.hour;
          return hour >= startHour && hour < endHour;
        })
        .fold<int>(0, (sum, intake) => sum + intake.amount);
  }

  DateTime _getWeekStart(DateTime date) {
    final weekday = date.weekday;
    return date.subtract(Duration(days: weekday - 1));
  }

  DateTime? _getBestDay(Map<DateTime, int> dailyTotals) {
    if (dailyTotals.isEmpty) return null;

    final maxAmount = dailyTotals.values.reduce((a, b) => a > b ? a : b);
    return dailyTotals.entries
        .firstWhere((entry) => entry.value == maxAmount)
        .key;
  }

  double _calculateConsistency(Map<DateTime, int> dailyTotals) {
    if (dailyTotals.isEmpty) return 0.0;

    final daysWithIntake =
        dailyTotals.values.where((amount) => amount > 0).length;
    return (daysWithIntake / dailyTotals.length) * 100;
  }
}

class HydrationStats {
  final DateTime date;
  final int totalAmount;
  final int intakeCount;
  final int averagePerIntake;
  final DateTime? firstIntake;
  final DateTime? lastIntake;
  final int morningAmount;
  final int afternoonAmount;
  final int eveningAmount;
  final int nightAmount;

  const HydrationStats({
    required this.date,
    required this.totalAmount,
    required this.intakeCount,
    required this.averagePerIntake,
    this.firstIntake,
    this.lastIntake,
    required this.morningAmount,
    required this.afternoonAmount,
    required this.eveningAmount,
    required this.nightAmount,
  });

  factory HydrationStats.empty(DateTime date) {
    return HydrationStats(
      date: date,
      totalAmount: 0,
      intakeCount: 0,
      averagePerIntake: 0,
      morningAmount: 0,
      afternoonAmount: 0,
      eveningAmount: 0,
      nightAmount: 0,
    );
  }

  String get peakPeriod {
    final periods = {
      'Manhã': morningAmount,
      'Tarde': afternoonAmount,
      'Noite': eveningAmount,
      'Madrugada': nightAmount,
    };

    final maxAmount = periods.values.reduce((a, b) => a > b ? a : b);
    return periods.entries.firstWhere((entry) => entry.value == maxAmount).key;
  }
}

class WeeklyHydrationStats {
  final DateTime weekStart;
  final DateTime weekEnd;
  final int totalAmount;
  final int averagePerDay;
  final int daysWithIntake;
  final Map<DateTime, int> dailyTotals;
  final DateTime? bestDay;
  final double consistency;

  const WeeklyHydrationStats({
    required this.weekStart,
    required this.weekEnd,
    required this.totalAmount,
    required this.averagePerDay,
    required this.daysWithIntake,
    required this.dailyTotals,
    this.bestDay,
    required this.consistency,
  });
}
