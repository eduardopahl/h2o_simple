import '../../core/services/hydration_calculator_service.dart';

class PersonalDataModel {
  final double? weightKg;
  final int? ageYears;
  final Gender? gender;
  final ActivityLevel? activityLevel;
  final int? customGoalMl;
  final bool useCustomGoal;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PersonalDataModel({
    this.weightKg,
    this.ageYears,
    this.gender,
    this.activityLevel = ActivityLevel.moderate,
    this.customGoalMl,
    this.useCustomGoal = false,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Calcula a meta de hidratação baseada nos dados pessoais
  int calculateDailyGoal() {
    // Se tem meta customizada e escolheu usar, retorna ela
    if (useCustomGoal && customGoalMl != null) {
      return customGoalMl!;
    }

    // Se tem todos os dados necessários, calcula pela fórmula
    if (weightKg != null && ageYears != null && gender != null) {
      return HydrationCalculatorService.calculateDailyWaterIntake(
        weightKg: weightKg!,
        ageYears: ageYears!,
        gender: gender!,
        activityLevel: activityLevel ?? ActivityLevel.moderate,
      );
    }

    // Fallback para meta padrão
    return 2000;
  }

  /// Retorna descrição da meta atual
  String getGoalDescription() {
    final goal = calculateDailyGoal();
    return HydrationCalculatorService.getGoalDescription(goal);
  }

  /// Verifica se tem dados suficientes para cálculo personalizado
  bool get hasPersonalData =>
      weightKg != null && ageYears != null && gender != null;

  /// Cria cópia com dados atualizados
  PersonalDataModel copyWith({
    double? weightKg,
    int? ageYears,
    Gender? gender,
    ActivityLevel? activityLevel,
    int? customGoalMl,
    bool? useCustomGoal,
    DateTime? updatedAt,
  }) {
    return PersonalDataModel(
      weightKg: weightKg ?? this.weightKg,
      ageYears: ageYears ?? this.ageYears,
      gender: gender ?? this.gender,
      activityLevel: activityLevel ?? this.activityLevel,
      customGoalMl: customGoalMl ?? this.customGoalMl,
      useCustomGoal: useCustomGoal ?? this.useCustomGoal,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  /// Converte para Map para persistência
  Map<String, dynamic> toJson() {
    return {
      'weightKg': weightKg,
      'ageYears': ageYears,
      'gender': gender?.name,
      'activityLevel': activityLevel?.name,
      'customGoalMl': customGoalMl,
      'useCustomGoal': useCustomGoal,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Cria instância a partir de Map
  factory PersonalDataModel.fromJson(Map<String, dynamic> json) {
    return PersonalDataModel(
      weightKg: json['weightKg']?.toDouble(),
      ageYears: json['ageYears']?.toInt(),
      gender:
          json['gender'] != null
              ? Gender.values.firstWhere((e) => e.name == json['gender'])
              : null,
      activityLevel:
          json['activityLevel'] != null
              ? ActivityLevel.values.firstWhere(
                (e) => e.name == json['activityLevel'],
              )
              : ActivityLevel.moderate,
      customGoalMl: json['customGoalMl']?.toInt(),
      useCustomGoal: json['useCustomGoal'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  /// Instância vazia para primeira configuração
  factory PersonalDataModel.initial() {
    final now = DateTime.now();
    return PersonalDataModel(createdAt: now, updatedAt: now);
  }

  @override
  String toString() {
    return 'PersonalDataModel(weight: ${weightKg}kg, age: ${ageYears}y, '
        'gender: $gender, activity: $activityLevel, '
        'customGoal: ${customGoalMl}ml, useCustom: $useCustomGoal)';
  }
}
