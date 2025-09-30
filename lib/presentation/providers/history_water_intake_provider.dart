import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/water_intake.dart';
import '../../domain/repositories/water_intake_repository.dart';
import 'repository_providers.dart';
import '../widgets/period_selector.dart';
import 'daily_water_intake_provider.dart';

class HistoryWaterIntakeNotifier
    extends StateNotifier<AsyncValue<List<WaterIntake>>> {
  HistoryWaterIntakeNotifier(this._repository, this._ref)
    : super(const AsyncValue.loading());

  final WaterIntakeRepository _repository;
  final Ref _ref;

  /// Carrega ingestões de água para uma data específica
  ///
  /// [date] - Data para buscar as ingestões
  ///
  /// Usado na visualização diária do histórico
  /// Pattern: Single Responsibility - carrega apenas um dia
  Future<void> loadIntakesByDate(DateTime date) async {
    state = const AsyncValue.loading();
    try {
      final intakes = await _repository.getWaterIntakesByDate(date);
      state = AsyncValue.data(intakes);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Carrega ingestões de uma semana completa
  ///
  /// [date] - Qualquer data dentro da semana desejada
  ///
  /// Algoritmo:
  /// 1. Calcula início da semana (segunda-feira)
  /// 2. Itera pelos 7 dias
  /// 3. Agrega todos os dados em uma lista única
  ///
  /// Performance: Otimizada para visualização de gráficos semanais
  Future<void> loadWeekIntakes(DateTime date) async {
    state = const AsyncValue.loading();
    try {
      // Calcular início da semana baseado na data fornecida
      final weekStart = date.subtract(Duration(days: date.weekday - 1));

      List<WaterIntake> allIntakes = [];
      for (int i = 0; i < 7; i++) {
        final dayDate = weekStart.add(Duration(days: i));
        final dayIntakes = await _repository.getWaterIntakesByDate(dayDate);
        allIntakes.addAll(dayIntakes);
      }

      state = AsyncValue.data(allIntakes);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Carrega ingestões de um mês completo
  ///
  /// [date] - Qualquer data dentro do mês desejado
  ///
  /// Implementação:
  /// - Calcula automaticamente dias no mês (28-31)
  /// - Carrega todos os dias do mês sequencialmente
  /// - Agrega em lista única para análise mensal
  ///
  /// Use Case: Relatórios mensais e gráficos de tendência
  Future<void> loadMonthIntakes(DateTime date) async {
    state = const AsyncValue.loading();
    try {
      final monthEnd = DateTime(date.year, date.month + 1, 0);

      List<WaterIntake> allIntakes = [];
      for (int day = 1; day <= monthEnd.day; day++) {
        final dayDate = DateTime(date.year, date.month, day);
        final dayIntakes = await _repository.getWaterIntakesByDate(dayDate);
        allIntakes.addAll(dayIntakes);
      }

      state = AsyncValue.data(allIntakes);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Remove uma ingestão com sincronização cross-provider inteligente
  ///
  /// [id] - Identificador único da ingestão
  /// [reloadDate] - Data para recarregar após remoção
  /// [period] - Período atual (dia/semana/mês) para recarregamento apropriado
  ///
  /// Funcionalidades avançadas:
  /// 1. **Detecção de Cross-Provider**: Verifica se item deletado afeta Daily tab
  /// 2. **Invalidação Seletiva**: Invalida [dailyWaterIntakeProvider] apenas se necessário
  /// 3. **Recarregamento Contextual**: Recarrega dados baseado no período ativo
  ///
  /// Design Pattern: Observer + Strategy
  /// - Observer: Detecta mudanças que afetam outros providers
  /// - Strategy: Escolhe método de recarregamento baseado no período
  Future<void> removeWaterIntake(
    String id, {
    DateTime? reloadDate,
    TimePeriod? period,
  }) async {
    try {
      // Primeiro, verificar se o item sendo deletado é do dia atual
      final today = DateTime.now();
      bool shouldInvalidateDaily = false;

      // Verificar se temos dados carregados e se o item existe
      final currentData = state.valueOrNull;
      if (currentData != null) {
        final itemToDelete = currentData.firstWhere(
          (intake) => intake.id == id,
          orElse:
              () => WaterIntake(
                id: '',
                amount: 0,
                timestamp: DateTime(2000), // Data dummy para não dar match
              ),
        );

        // Se o item é do dia atual, marcar para invalidar
        if (itemToDelete.id.isNotEmpty &&
            itemToDelete.timestamp.day == today.day &&
            itemToDelete.timestamp.month == today.month &&
            itemToDelete.timestamp.year == today.year) {
          shouldInvalidateDaily = true;
        }
      }

      await _repository.removeWaterIntake(id);

      // Invalidar o provider da Daily se necessário
      if (shouldInvalidateDaily) {
        _ref.invalidate(dailyWaterIntakeProvider);
      }

      // Recarregar dados baseado no período e data atual
      if (reloadDate != null && period != null) {
        switch (period) {
          case TimePeriod.day:
            await loadIntakesByDate(reloadDate);
            break;
          case TimePeriod.week:
            await loadWeekIntakes(reloadDate);
            break;
          case TimePeriod.month:
            await loadMonthIntakes(reloadDate);
            break;
        }
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Busca total de água para uma data específica
  ///
  /// [date] - Data para calcular o total
  ///
  /// Método utilitário para cálculos rápidos sem alterar estado
  /// Usado principalmente para exibições de resumo
  Future<int> getTotalForDate(DateTime date) async {
    return await _repository.getTotalWaterIntakeByDate(date);
  }
}

/// Provider principal para a aba History
///
/// Características arquiteturais:
/// - **Escopo Separado**: Independente do [dailyWaterIntakeProvider]
/// - **Cross-Provider Sync**: Pode invalidar outros providers quando necessário
/// - **Injeção de Dependência**: Recebe repositório e referência Riverpod
/// - **Multi-Period Support**: Suporta visualização por dia/semana/mês
///
/// Benefícios:
/// - Isolamento de responsabilidades (SOLID)
/// - Sincronização bidirecional automática
/// - Performance otimizada para dados históricos
final historyWaterIntakeProvider = StateNotifierProvider<
  HistoryWaterIntakeNotifier,
  AsyncValue<List<WaterIntake>>
>((ref) {
  final repository = ref.watch(waterIntakeRepositoryProvider);
  return HistoryWaterIntakeNotifier(repository, ref);
});

/// Provider derivado que expõe lista segura de ingestões históricas
///
/// Funcionalidades:
/// - **Fallback Safety**: Retorna lista vazia se dados não disponíveis
/// - **Reactive UI**: Atualiza automaticamente quando dados mudam
/// - **Type Safety**: Garante tipo List<WaterIntake> não-nullable
///
/// Usado por: Widgets de lista, gráficos, componentes de visualização
final historyWaterIntakeListProvider = Provider<List<WaterIntake>>((ref) {
  return ref.watch(historyWaterIntakeProvider).valueOrNull ?? [];
});
