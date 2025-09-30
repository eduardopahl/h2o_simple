import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'period_selector.dart';

class WaterChart extends StatelessWidget {
  final TimePeriod chartType;
  final List<dynamic> waterIntakes;
  final DateTime selectedDate;

  const WaterChart({
    super.key,
    required this.chartType,
    required this.waterIntakes,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getChartTitle(),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _getTotalForPeriod(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(height: 200, child: _buildChart(context)),
        ],
      ),
    );
  }

  String _getChartTitle() {
    switch (chartType) {
      case TimePeriod.day:
        return 'Consumo do Dia';
      case TimePeriod.week:
        return 'Consumo Semanal';
      case TimePeriod.month:
        return 'Consumo Mensal';
    }
  }

  Widget _buildChart(BuildContext context) {
    switch (chartType) {
      case TimePeriod.day:
        return _buildDayChart(context);
      case TimePeriod.week:
        return _buildWeekChart(context);
      case TimePeriod.month:
        return _buildMonthChart(context);
    }
  }

  Widget _buildDayChart(BuildContext context) {
    // Agrupa por períodos de 30 minutos (48 períodos no dia)
    final Map<int, int> periodData = {};
    for (int i = 0; i < 48; i++) {
      periodData[i] = 0;
    }

    for (final intake in waterIntakes) {
      if (intake.timestamp.day == selectedDate.day &&
          intake.timestamp.month == selectedDate.month &&
          intake.timestamp.year == selectedDate.year) {
        // Calcula o período de 30 min (0-47)
        final hour = intake.timestamp.hour;
        final minute = intake.timestamp.minute;
        final period = (hour * 2) + (minute >= 30 ? 1 : 0);
        periodData[period] = (periodData[period] ?? 0) + intake.amount as int;
      }
    }

    final maxValue =
        periodData.values.isNotEmpty
            ? periodData.values.reduce((a, b) => a > b ? a : b).toDouble()
            : 1000.0;

    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8, left: 8, right: 8),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxValue > 0 ? maxValue * 1.2 : 1000,
          minY: 0,
          groupsSpace: 1,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor:
                  (group) => Theme.of(context).colorScheme.inverseSurface,
              tooltipRoundedRadius: 8,
              tooltipPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final period = group.x;
                final hour = (period / 2).floor();
                final isSecondHalf = period % 2 == 1;
                final timeLabel = isSecondHalf ? '${hour}:30' : '${hour}:00';
                return BarTooltipItem(
                  '$timeLabel\n${rod.toY.toInt()}ml',
                  TextStyle(
                    color: Theme.of(context).colorScheme.onInverseSurface,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  final period = value.toInt();
                  final hour = (period / 2).floor();
                  // Mostrar apenas horas múltiplas de 4 (0, 4, 8, 12, 16, 20)
                  if (hour % 4 != 0 || period % 2 != 0) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '${hour}h',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 50,
                interval: maxValue > 0 ? maxValue / 4 : 250,
                getTitlesWidget: (value, meta) {
                  if (value == 0) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Text(
                      '${value.toInt()}ml',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 8,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                      ),
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                    ),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxValue > 0 ? maxValue / 4 : 250,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                strokeWidth: 1,
              );
            },
          ),
          borderData: FlBorderData(show: false),
          barGroups:
              periodData.entries.map((entry) {
                final value = entry.value.toDouble();
                final intensity =
                    maxValue > 0 ? (value / maxValue).clamp(0.0, 1.0) : 0.0;

                return BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      toY: value,
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors:
                            value > 0
                                ? [
                                  Theme.of(context).colorScheme.primary
                                      .withOpacity(0.3 + (intensity * 0.7)),
                                  Theme.of(context).colorScheme.primary
                                      .withOpacity(0.8 + (intensity * 0.2)),
                                ]
                                : [
                                  Theme.of(
                                    context,
                                  ).colorScheme.outline.withOpacity(0.1),
                                  Theme.of(
                                    context,
                                  ).colorScheme.outline.withOpacity(0.1),
                                ],
                      ),
                      width: 3,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(2),
                        bottom: Radius.circular(1),
                      ),
                    ),
                  ],
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildWeekChart(BuildContext context) {
    // Implementação simples - agrupa por dia da semana
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));

    final Map<int, int> weeklyData = {};
    for (int i = 0; i < 7; i++) {
      weeklyData[i] = 0;
    }

    for (final intake in waterIntakes) {
      final daysDiff = intake.timestamp.difference(weekStart).inDays;
      if (daysDiff >= 0 && daysDiff < 7) {
        weeklyData[daysDiff] =
            (weeklyData[daysDiff] ?? 0) + intake.amount as int;
      }
    }

    final maxValue =
        weeklyData.values.isNotEmpty
            ? weeklyData.values.reduce((a, b) => a > b ? a : b).toDouble()
            : 2000.0;

    const dayLabels = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];

    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8, left: 8, right: 8),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceEvenly,
          maxY: maxValue > 0 ? maxValue * 1.2 : 2000,
          minY: 0,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor:
                  (group) => Theme.of(context).colorScheme.inverseSurface,
              tooltipRoundedRadius: 8,
              tooltipPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final dayIndex = group.x;
                return BarTooltipItem(
                  '${dayLabels[dayIndex]}\n${rod.toY.toInt()}ml',
                  TextStyle(
                    color: Theme.of(context).colorScheme.onInverseSurface,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < dayLabels.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        dayLabels[index],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 11,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxValue > 0 ? maxValue / 4 : 500,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                strokeWidth: 1,
              );
            },
          ),
          borderData: FlBorderData(show: false),
          barGroups:
              weeklyData.entries.map((entry) {
                final value = entry.value.toDouble();
                final intensity =
                    maxValue > 0 ? (value / maxValue).clamp(0.0, 1.0) : 0.0;

                return BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      toY: value,
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors:
                            value > 0
                                ? [
                                  Theme.of(context).colorScheme.secondary
                                      .withOpacity(0.3 + (intensity * 0.7)),
                                  Theme.of(context).colorScheme.secondary
                                      .withOpacity(0.8 + (intensity * 0.2)),
                                ]
                                : [
                                  Theme.of(
                                    context,
                                  ).colorScheme.outline.withOpacity(0.1),
                                  Theme.of(
                                    context,
                                  ).colorScheme.outline.withOpacity(0.1),
                                ],
                      ),
                      width: 24,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                        bottom: Radius.circular(3),
                      ),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: maxValue > 0 ? maxValue * 1.2 : 2000,
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                      ),
                    ),
                  ],
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildMonthChart(BuildContext context) {
    // Implementação simples - agrupa por semana do mês
    final Map<int, int> monthlyData = {};
    for (int i = 0; i < 4; i++) {
      monthlyData[i] = 0;
    }

    final now = DateTime.now();

    for (final intake in waterIntakes) {
      if (intake.timestamp.year == now.year &&
          intake.timestamp.month == now.month) {
        final weekOfMonth = ((intake.timestamp.day - 1) / 7).floor();
        if (weekOfMonth < 4) {
          monthlyData[weekOfMonth] =
              (monthlyData[weekOfMonth] ?? 0) + intake.amount as int;
        }
      }
    }

    final maxValue =
        monthlyData.values.isNotEmpty
            ? monthlyData.values.reduce((a, b) => a > b ? a : b).toDouble()
            : 5000.0;

    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8, left: 8, right: 8),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceEvenly,
          maxY: maxValue > 0 ? maxValue * 1.2 : 5000,
          minY: 0,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor:
                  (group) => Theme.of(context).colorScheme.inverseSurface,
              tooltipRoundedRadius: 8,
              tooltipPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  'Semana ${group.x + 1}\n${rod.toY.toInt()}ml',
                  TextStyle(
                    color: Theme.of(context).colorScheme.onInverseSurface,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'S${(value.toInt() + 1)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxValue > 0 ? maxValue / 4 : 1250,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                strokeWidth: 1,
              );
            },
          ),
          borderData: FlBorderData(show: false),
          barGroups:
              monthlyData.entries.map((entry) {
                final value = entry.value.toDouble();
                final intensity =
                    maxValue > 0 ? (value / maxValue).clamp(0.0, 1.0) : 0.0;

                return BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      toY: value,
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors:
                            value > 0
                                ? [
                                  Theme.of(context).colorScheme.tertiary
                                      .withOpacity(0.3 + (intensity * 0.7)),
                                  Theme.of(context).colorScheme.tertiary
                                      .withOpacity(0.8 + (intensity * 0.2)),
                                ]
                                : [
                                  Theme.of(
                                    context,
                                  ).colorScheme.outline.withOpacity(0.1),
                                  Theme.of(
                                    context,
                                  ).colorScheme.outline.withOpacity(0.1),
                                ],
                      ),
                      width: 40,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(10),
                        bottom: Radius.circular(4),
                      ),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: maxValue > 0 ? maxValue * 1.2 : 5000,
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                      ),
                    ),
                  ],
                );
              }).toList(),
        ),
      ),
    );
  }

  String _getTotalForPeriod() {
    int total = 0;

    for (final intake in waterIntakes) {
      switch (chartType) {
        case TimePeriod.day:
          if (intake.timestamp.day == selectedDate.day &&
              intake.timestamp.month == selectedDate.month &&
              intake.timestamp.year == selectedDate.year) {
            total += intake.amount as int;
          }
          break;
        case TimePeriod.week:
        case TimePeriod.month:
          total += intake.amount as int;
          break;
      }
    }

    if (total >= 1000) {
      return '${(total / 1000).toStringAsFixed(1)}L';
    } else {
      return '${total}ml';
    }
  }
}
