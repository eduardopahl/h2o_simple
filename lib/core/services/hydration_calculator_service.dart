/// Service para calcular metas de hidratação baseado em dados pessoais
/// Utiliza fórmulas reconhecidas internacionalmente

enum Gender { male, female }

enum ActivityLevel {
  sedentary, // Sedentário
  light, // Leve (1-3x por semana)
  moderate, // Moderado (3-5x por semana)
  intense, // Intenso (6-7x por semana)
  extreme, // Extremo (2x por dia)
}

class HydrationCalculatorService {
  /// Calcula a necessidade diária de água em ml
  /// Baseado nas diretrizes da Mayo Clinic e Institute of Medicine (IOM)
  static int calculateDailyWaterIntake({
    required double weightKg,
    required int ageYears,
    required Gender gender,
    ActivityLevel activityLevel = ActivityLevel.moderate,
  }) {
    // Fórmula base: 35ml por kg de peso corporal (adultos)
    // Ajustada por gênero, idade e nível de atividade

    double baseIntake = weightKg * 35; // ml base por kg

    // Ajuste por gênero (homens precisam de mais água)
    if (gender == Gender.male) {
      baseIntake *= 1.1; // +10% para homens
    }

    // Ajuste por idade
    if (ageYears >= 65) {
      baseIntake *= 0.9; // -10% para idosos (função renal reduzida)
    } else if (ageYears >= 50) {
      baseIntake *= 0.95; // -5% para 50-64 anos
    } else if (ageYears <= 25) {
      baseIntake *= 1.05; // +5% para jovens (metabolismo mais alto)
    }

    // Ajuste por nível de atividade
    switch (activityLevel) {
      case ActivityLevel.sedentary:
        baseIntake *= 0.9; // -10%
        break;
      case ActivityLevel.light:
        baseIntake *= 0.95; // -5%
        break;
      case ActivityLevel.moderate:
        // Sem ajuste (base)
        break;
      case ActivityLevel.intense:
        baseIntake *= 1.15; // +15%
        break;
      case ActivityLevel.extreme:
        baseIntake *= 1.3; // +30%
        break;
    }

    // Limites de segurança
    int result = baseIntake.round();

    // Mínimo: 1500ml (sobrevivência)
    // Máximo: 4000ml (limite seguro para pessoa saudável)
    return result.clamp(1500, 4000);
  }

  /// Calcula peso ideal aproximado baseado na altura (fórmula de Devine)
  static double calculateIdealWeight({
    required double heightCm,
    required Gender gender,
  }) {
    if (heightCm < 150 || heightCm > 220) {
      throw ArgumentError('Altura deve estar entre 150cm e 220cm');
    }

    // Fórmula de Devine (1974)
    if (gender == Gender.male) {
      return 50 + 2.3 * ((heightCm - 152.4) / 2.54); // kg
    } else {
      return 45.5 + 2.3 * ((heightCm - 152.4) / 2.54); // kg
    }
  }

  /// Retorna meta recomendada simplificada baseada apenas no peso
  static int getSimpleRecommendation(double weightKg) {
    // Fórmula simples: 35ml por kg
    return (weightKg * 35).clamp(1500, 4000).round();
  }

  /// Retorna recomendações por categoria
  static Map<String, int> getRecommendationsByCategory() {
    return {
      'Mulher adulta': 2000,
      'Homem adulto': 2500,
      'Atleta feminina': 2500,
      'Atleta masculino': 3000,
      'Idoso(a)': 1800,
      'Jovem ativo': 2200,
    };
  }

  /// Valida se uma meta está dentro dos limites seguros
  static bool isValidGoal(int goalMl) {
    return goalMl >= 1000 && goalMl <= 5000;
  }

  /// Retorna descrição da meta calculada
  static String getGoalDescription(int goalMl) {
    if (goalMl < 1500) return 'Meta muito baixa - considere aumentar';
    if (goalMl <= 2000) return 'Meta adequada para a maioria das pessoas';
    if (goalMl <= 2500) return 'Meta boa para pessoas ativas';
    if (goalMl <= 3000) return 'Meta elevada - ideal para atletas';
    return 'Meta muito alta - consulte um médico';
  }
}
