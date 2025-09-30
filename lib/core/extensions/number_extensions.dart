extension IntExtensions on int {
  String get formattedWaterAmount {
    if (this >= 1000) {
      final liters = this / 1000;
      if (liters == liters.round()) {
        return '${liters.round()}L';
      } else {
        return '${liters.toStringAsFixed(2).replaceAll('.', ',')}L';
      }
    }
    return '${this}ml';
  }

  double get toLiters => this / 1000.0;

  String get formattedWithSeparator {
    final str = toString();
    if (str.length <= 3) return str;

    final buffer = StringBuffer();
    final reversed = str.split('').reversed.toList();

    for (int i = 0; i < reversed.length; i++) {
      if (i != 0 && i % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(reversed[i]);
    }

    return buffer.toString().split('').reversed.join();
  }

  bool get isHealthyIntakeAmount => this >= 50 && this <= 500;

  bool get isReasonableDailyGoal => this >= 1000 && this <= 5000;

  double percentageOf(int goal) {
    if (goal == 0) return 0.0;
    return (this / goal) * 100;
  }

  int clampToRange(int min, int max) {
    if (this < min) return min;
    if (this > max) return max;
    return this;
  }

  String get toTimeString {
    final hours = this ~/ 60;
    final minutes = this % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  String get toByteSizeString {
    const units = ['B', 'KB', 'MB', 'GB'];
    double size = toDouble();
    int unitIndex = 0;

    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex++;
    }

    return '${size.toStringAsFixed(1)}${units[unitIndex]}';
  }
}

extension DoubleExtensions on double {
  String get toPercentageString {
    return '${(this).toStringAsFixed(1).replaceAll('.', ',')}%';
  }

  String get formattedLiters {
    return '${toStringAsFixed(2).replaceAll('.', ',')}L';
  }

  int get toMilliliters => (this * 1000).round();

  bool isCloseTo(double other, {double tolerance = 0.01}) {
    return (this - other).abs() <= tolerance;
  }

  String toStringWithComma([int decimals = 2]) {
    return toStringAsFixed(decimals).replaceAll('.', ',');
  }
}

extension StringExtensions on String {
  String get numbersOnly => replaceAll(RegExp(r'[^0-9]'), '');

  int toIntSafe([int defaultValue = 0]) {
    final parsed = int.tryParse(numbersOnly);
    return parsed ?? defaultValue;
  }

  double toDoubleSafe([double defaultValue = 0.0]) {
    final normalized = replaceAll(',', '.');
    final parsed = double.tryParse(normalized);
    return parsed ?? defaultValue;
  }

  String get titleCase {
    if (isEmpty) return this;

    return split(' ')
        .map(
          (word) =>
              word.isEmpty
                  ? word
                  : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
        )
        .join(' ');
  }

  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - 3)}...';
  }

  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  bool get isNumeric => RegExp(r'^[0-9]+$').hasMatch(this);

  String get normalized => trim().replaceAll(RegExp(r'\s+'), ' ');
}
