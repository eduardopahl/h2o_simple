import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../providers/history_water_intake_provider.dart';
import '../../widgets/period_selector.dart';
import '../../widgets/date_navigator.dart';
import '../../widgets/water_chart.dart';
import '../../widgets/daily_list_content.dart';
import '../../widgets/period_summary.dart';
import '../../widgets/contextual_ad_banner.dart';

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
      _loadDataForPeriod(selectedPeriod);
    });
  }

  void _loadDataForPeriod(TimePeriod period) {
    // Forçar estado de loading antes de carregar novos dados
    final notifier = ref.read(historyWaterIntakeProvider.notifier);

    switch (period) {
      case TimePeriod.day:
        notifier.loadIntakesByDate(selectedDate);
        break;
      case TimePeriod.week:
        notifier.loadWeekIntakes(selectedDate);
        break;
      case TimePeriod.month:
        notifier.loadMonthIntakes(selectedDate);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final waterIntakesAsync = ref.watch(historyWaterIntakeProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            Text(
              AppLocalizations.of(context).history,
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
                _loadDataForPeriod(period);
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
                      .read(historyWaterIntakeProvider.notifier)
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
                    (error, stack) => Center(
                      child: Text(
                        AppLocalizations.of(
                          context,
                        ).errorLoadingData(error.toString()),
                      ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<dynamic> waterIntakes) {
    if (selectedPeriod == TimePeriod.day) {
      // Para o período de dia, filtrar apenas os dados do dia selecionado
      final dayIntakes =
          waterIntakes
              .where(
                (intake) =>
                    intake.timestamp.day == selectedDate.day &&
                    intake.timestamp.month == selectedDate.month &&
                    intake.timestamp.year == selectedDate.year,
              )
              .toList();

      return SingleChildScrollView(
        child: Column(
          children: [
            // Gráfico do dia (com dados filtrados)
            WaterChart(
              chartType: selectedPeriod,
              waterIntakes: dayIntakes,
              selectedDate: selectedDate,
            ),
            const SizedBox(height: 5),

            // Banner contextual discreto (também na visualização diária)
            const ContextualAdBanner(context: 'history'),

            // Lista de registros do dia (com dados filtrados)
            DailyListContent(
              waterIntakes: dayIntakes,
              selectedDate: selectedDate,
              onDeleteIntake:
                  (intakeId) => _showDeleteConfirmation(context, ref, intakeId),
            ),
          ],
        ),
      );
    } else {
      // Para semana e mês, usar todos os dados carregados
      return SingleChildScrollView(
        child: Column(
          children: [
            // Gráfico do período
            WaterChart(
              chartType: selectedPeriod,
              waterIntakes: waterIntakes,
              selectedDate: selectedDate,
            ),
            const SizedBox(height: 5),

            // Banner contextual discreto
            const ContextualAdBanner(context: 'history'),

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
              AppLocalizations.of(context).confirmDeletion,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            content: Text(
              AppLocalizations.of(context).confirmDeleteWaterRecord,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  AppLocalizations.of(context).cancel,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  ref
                      .read(historyWaterIntakeProvider.notifier)
                      .removeWaterIntake(
                        intakeId,
                        reloadDate: selectedDate,
                        period: selectedPeriod,
                      );
                  Navigator.of(context).pop();
                },
                child: Text(
                  AppLocalizations.of(context).delete,
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
