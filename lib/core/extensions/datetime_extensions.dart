extension DateTimeExtensions on DateTime {
  DateTime get dayOnly => DateTime(year, month, day);

  bool get isToday {
    final today = DateTime.now().dayOnly;
    return dayOnly.isAtSameMomentAs(today);
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1)).dayOnly;
    return dayOnly.isAtSameMomentAs(yesterday);
  }

  bool get isThisWeek {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1)).dayOnly;
    final weekEnd = weekStart.add(const Duration(days: 6));
    return isAfter(weekStart.subtract(const Duration(days: 1))) &&
        isBefore(weekEnd.add(const Duration(days: 1)));
  }

  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  DateTime get weekStart {
    return subtract(Duration(days: weekday - 1)).dayOnly;
  }

  DateTime get weekEnd {
    return weekStart.add(const Duration(days: 6));
  }

  DateTime get monthStart {
    return DateTime(year, month, 1);
  }

  DateTime get monthEnd {
    return DateTime(year, month + 1, 0);
  }

  int daysDifference(DateTime other) {
    return other.dayOnly.difference(dayOnly).inDays;
  }

  bool get isWeekend {
    return weekday == DateTime.saturday || weekday == DateTime.sunday;
  }

  String get friendlyFormat {
    if (isToday) return 'Hoje';
    if (isYesterday) return 'Ontem';

    if (isThisWeek) {
      const weekdays = [
        'Segunda-feira',
        'Terça-feira',
        'Quarta-feira',
        'Quinta-feira',
        'Sexta-feira',
        'Sábado',
        'Domingo',
      ];
      return weekdays[weekday - 1];
    }

    return '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}';
  }

  DayPeriod get period {
    if (hour >= 6 && hour < 12) return DayPeriod.morning;
    if (hour >= 12 && hour < 18) return DayPeriod.afternoon;
    if (hour >= 18 && hour < 24) return DayPeriod.evening;
    return DayPeriod.night;
  }

  DateTime addBusinessDays(int days) {
    var result = this;
    var remaining = days;

    while (remaining > 0) {
      result = result.add(const Duration(days: 1));
      if (!result.isWeekend) {
        remaining--;
      }
    }

    return result;
  }
}

enum DayPeriod { morning, afternoon, evening, night }

extension DayPeriodExtensions on DayPeriod {
  String get displayName {
    switch (this) {
      case DayPeriod.morning:
        return 'Manhã';
      case DayPeriod.afternoon:
        return 'Tarde';
      case DayPeriod.evening:
        return 'Noite';
      case DayPeriod.night:
        return 'Madrugada';
    }
  }

  int get startHour {
    switch (this) {
      case DayPeriod.morning:
        return 6;
      case DayPeriod.afternoon:
        return 12;
      case DayPeriod.evening:
        return 18;
      case DayPeriod.night:
        return 0;
    }
  }

  int get endHour {
    switch (this) {
      case DayPeriod.morning:
        return 12;
      case DayPeriod.afternoon:
        return 18;
      case DayPeriod.evening:
        return 24;
      case DayPeriod.night:
        return 6;
    }
  }
}
