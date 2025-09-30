import '../extensions/datetime_extensions.dart';
import '../../domain/entities/water_intake.dart';

extension WaterIntakeListExtensions on List<WaterIntake> {
  int get totalAmount => fold<int>(0, (sum, intake) => sum + intake.amount);

  List<WaterIntake> forDate(DateTime date) {
    final targetDate = date.dayOnly;
    return where(
      (intake) => intake.timestamp.dayOnly.isAtSameMomentAs(targetDate),
    ).toList();
  }

  List<WaterIntake> forPeriod(DayPeriod period) {
    return where((intake) => intake.timestamp.period == period).toList();
  }

  List<WaterIntake> forDateRange(DateTime startDate, DateTime endDate) {
    final start = startDate.dayOnly;
    final end = endDate.dayOnly.add(const Duration(days: 1));

    return where((intake) {
      final intakeDate = intake.timestamp.dayOnly;
      return !intakeDate.isBefore(start) && intakeDate.isBefore(end);
    }).toList();
  }

  List<WaterIntake> get today => forDate(DateTime.now());

  List<WaterIntake> get yesterday =>
      forDate(DateTime.now().subtract(const Duration(days: 1)));

  List<WaterIntake> get thisWeek {
    final now = DateTime.now();
    return forDateRange(now.weekStart, now.weekEnd);
  }

  List<WaterIntake> get thisMonth {
    final now = DateTime.now();
    return forDateRange(now.monthStart, now.monthEnd);
  }

  Map<DateTime, List<WaterIntake>> groupByDate() {
    final grouped = <DateTime, List<WaterIntake>>{};

    for (final intake in this) {
      final dateKey = intake.timestamp.dayOnly;
      grouped.putIfAbsent(dateKey, () => []).add(intake);
    }

    return grouped;
  }

  Map<DayPeriod, List<WaterIntake>> groupByPeriod() {
    final grouped = <DayPeriod, List<WaterIntake>>{};

    for (final period in DayPeriod.values) {
      grouped[period] = forPeriod(period);
    }

    return grouped;
  }

  double get averageAmount {
    if (isEmpty) return 0.0;
    return totalAmount / length;
  }

  WaterIntake? get maxIntake {
    if (isEmpty) return null;
    return reduce((a, b) => a.amount > b.amount ? a : b);
  }

  WaterIntake? get minIntake {
    if (isEmpty) return null;
    return reduce((a, b) => a.amount < b.amount ? a : b);
  }

  WaterIntake? get firstIntakeOfDay {
    if (isEmpty) return null;
    return reduce((a, b) => a.timestamp.isBefore(b.timestamp) ? a : b);
  }

  WaterIntake? get lastIntakeOfDay {
    if (isEmpty) return null;
    return reduce((a, b) => a.timestamp.isAfter(b.timestamp) ? a : b);
  }

  Map<DayPeriod, double> get periodDistribution {
    if (isEmpty) return {};

    final total = totalAmount;
    final byPeriod = groupByPeriod();

    return byPeriod.map(
      (period, intakes) =>
          MapEntry(period, (intakes.totalAmount / total) * 100),
    );
  }

  Map<DateTime, int> get dailyTotals {
    final grouped = groupByDate();
    return grouped.map((date, intakes) => MapEntry(date, intakes.totalAmount));
  }

  List<WaterIntake> aboveAmount(int minAmount) {
    return where((intake) => intake.amount >= minAmount).toList();
  }

  List<WaterIntake> belowAmount(int maxAmount) {
    return where((intake) => intake.amount <= maxAmount).toList();
  }

  List<WaterIntake> betweenAmounts(int minAmount, int maxAmount) {
    return where(
      (intake) => intake.amount >= minAmount && intake.amount <= maxAmount,
    ).toList();
  }

  bool hasIntakesOnDate(DateTime date) {
    return forDate(date).isNotEmpty;
  }

  int totalForDate(DateTime date) {
    return forDate(date).totalAmount;
  }

  List<WaterIntake> get sortedByTime {
    final sorted = List<WaterIntake>.from(this);
    sorted.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return sorted;
  }

  List<WaterIntake> get sortedByAmount {
    final sorted = List<WaterIntake>.from(this);
    sorted.sort((a, b) => b.amount.compareTo(a.amount));
    return sorted;
  }
}
