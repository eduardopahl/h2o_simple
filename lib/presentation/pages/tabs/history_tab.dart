import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/water_intake_provider.dart';
import '../../widgets/period_selector.dart';
import '../../widgets/date_navigator.dart';
import '../../widgets/water_chart.dart';
import '../../widgets/daily_list_content.dart';
import '../../widgets/period_summary.dart';

class HistoryTab extends ConsumerStatefulWidget {
  const HistoryTab({super.key});

  @override
  ConsumerState<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends ConsumerState<HistoryTab> {
  TimePeriod selectedPeriod = TimePeriod.day;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Carregar dados da data atual após o primeiro frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(waterIntakeProvider.notifier).loadIntakesByDate(selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    final waterIntakesAsync = ref.watch(waterIntakeProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            Text(
              'Histórico',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Seletor de período
            PeriodSelector(
              selectedPeriod: selectedPeriod,
              onPeriodChanged: (period) {
                setState(() {
                  selectedPeriod = period;
                });
              },
            ),
            const SizedBox(height: 12),

            // Navegador de data (apenas para período de dia)
            if (selectedPeriod == TimePeriod.day) ...[
              DateNavigator(
                selectedDate: selectedDate,
                onDateChanged: (date) {
                  setState(() {
                    selectedDate = date;
                  });
                  ref
                      .read(waterIntakeProvider.notifier)
                      .loadIntakesByDate(date);
                },
              ),
              const SizedBox(height: 12),
            ],

            // Conteúdo baseado no período selecionado
            Expanded(
              child: waterIntakesAsync.when(
                data: (waterIntakes) => _buildContent(context, waterIntakes),
                loading: () => const Center(child: CircularProgressIndicator()),
                error:
                    (error, stack) =>
                        Center(child: Text('Erro ao carregar dados: $error')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<dynamic> waterIntakes) {
    if (selectedPeriod == TimePeriod.day) {
      // Para o período de dia, incluir gráfico e lista no scroll
      return SingleChildScrollView(
        child: Column(
          children: [
            // Gráfico do dia
            WaterChart(
              chartType: selectedPeriod,
              waterIntakes: waterIntakes,
              selectedDate: selectedDate,
            ),
            const SizedBox(height: 20),

            // Lista de registros do dia
            DailyListContent(
              waterIntakes: waterIntakes,
              selectedDate: selectedDate,
              onDeleteIntake:
                  (intakeId) => _showDeleteConfirmation(context, ref, intakeId),
            ),
          ],
        ),
      );
    } else {
      // Para semana e mês, mostrar apenas gráfico e resumo
      return SingleChildScrollView(
        child: Column(
          children: [
            // Gráfico do período
            WaterChart(
              chartType: selectedPeriod,
              waterIntakes: waterIntakes,
              selectedDate: selectedDate,
            ),
            const SizedBox(height: 20),

            // Resumo do período
            PeriodSummary(
              selectedPeriod: selectedPeriod,
              waterIntakes: waterIntakes,
            ),
          ],
        ),
      );
    }
  }

  void _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    String intakeId,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Confirmar exclusão',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            content: Text(
              'Deseja realmente excluir este registro de consumo de água?',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancelar',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  ref
                      .read(waterIntakeProvider.notifier)
                      .removeWaterIntake(intakeId, reloadDate: selectedDate);
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Excluir',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
