import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/services/hydration_calculator_service.dart';
import '../../data/models/personal_data_model.dart';

class FirstLaunchSetupDialog extends StatefulWidget {
  final Function(PersonalDataModel personalData, bool allowNotifications)
  onComplete;

  const FirstLaunchSetupDialog({super.key, required this.onComplete});

  @override
  State<FirstLaunchSetupDialog> createState() => _FirstLaunchSetupDialogState();
}

class _FirstLaunchSetupDialogState extends State<FirstLaunchSetupDialog> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _allowNotifications = false;

  // Dados pessoais
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _customGoalController = TextEditingController();

  Gender? _selectedGender;
  ActivityLevel _activityLevel = ActivityLevel.moderate;
  bool _usePersonalizedGoal = true;
  int _calculatedGoal = 2000;

  @override
  void dispose() {
    _pageController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    _customGoalController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeSetup();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _calculateGoal() {
    final weight = double.tryParse(_weightController.text);
    final age = int.tryParse(_ageController.text);

    if (weight != null && age != null && _selectedGender != null) {
      final newGoal = HydrationCalculatorService.calculateDailyWaterIntake(
        weightKg: weight,
        ageYears: age,
        gender: _selectedGender!,
        activityLevel: _activityLevel,
      );

      setState(() {
        _calculatedGoal = newGoal;
      });
    }
  }

  void _completeSetup() {
    final weight = double.tryParse(_weightController.text);
    final age = int.tryParse(_ageController.text);
    final customGoal = int.tryParse(_customGoalController.text);

    final personalData = PersonalDataModel(
      weightKg: weight,
      ageYears: age,
      gender: _selectedGender,
      activityLevel: _activityLevel,
      customGoalMl: customGoal,
      useCustomGoal: !_usePersonalizedGoal,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    Navigator.of(context).pop();
    widget.onComplete(personalData, _allowNotifications);
  }

  Widget _buildGenderOption({
    required Gender gender,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _selectedGender == gender;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedGender = gender);
        _calculateGoal();
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.surface,
          border: Border.all(
            color:
                isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 28,
              color:
                  isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color:
                    isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;
    final availableHeight = screenHeight - keyboardHeight;

    return Dialog(
      insetPadding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 40,
        bottom: keyboardHeight > 0 ? 16 : 40,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.infinity,
        height:
            keyboardHeight > 0 ? availableHeight * 0.85 : availableHeight * 0.7,
        constraints: BoxConstraints(
          maxHeight: keyboardHeight > 0 ? availableHeight * 0.85 : 600,
          minHeight: 400,
        ),
        child: Column(
          children: [
            // Header fixo
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildProgressIndicator(),
                ],
              ),
            ),
            // Conteúdo scrollável
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (page) => setState(() => _currentPage = page),
                  children: [
                    _buildWelcomePage(),
                    _buildPersonalDataPage(),
                    _buildGoalConfigPage(),
                  ],
                ),
              ),
            ),
            // Botões de navegação fixos
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: _buildNavigationButtons(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          Icons.water_drop,
          color: Theme.of(context).colorScheme.primary,
          size: 28,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'Bem-vindo ao H2O Simple!',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      children: List.generate(3, (index) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
            height: 4,
            decoration: BoxDecoration(
              color:
                  index <= _currentPage
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(
                        context,
                      ).colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildWelcomePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vamos personalizar sua experiência!',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Text(
            'Para ajudá-lo a manter uma hidratação saudável, vamos configurar:',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          _buildFeatureItem(
            Icons.person_outline,
            'Meta personalizada',
            'Baseada em seu peso, idade e nível de atividade',
          ),
          _buildFeatureItem(
            Icons.notifications_outlined,
            'Lembretes inteligentes',
            'Notificações para manter você hidratado',
          ),
          _buildFeatureItem(
            Icons.analytics_outlined,
            'Acompanhamento',
            'Monitore seu progresso diário',
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(description, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalDataPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Dados pessoais', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 6),
          Text(
            'Para calcular sua meta de hidratação ideal',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),

          // Peso
          TextField(
            controller: _weightController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
            ],
            decoration: InputDecoration(
              labelText: 'Peso (kg)',
              border: const OutlineInputBorder(),
              suffixText: 'kg',
              helperText: _getWeightHelperText(),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 16,
              ),
            ),
            onChanged: (_) {
              _calculateGoal();
              setState(() {}); // Atualiza o helper text
            },
          ),
          const SizedBox(height: 12),

          // Idade
          TextField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: 'Idade',
              border: OutlineInputBorder(),
              suffixText: 'anos',
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 16,
              ),
            ),
            onChanged: (_) => _calculateGoal(),
          ),
          const SizedBox(height: 12),

          // Gênero
          Text('Gênero', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildGenderOption(
                  gender: Gender.male,
                  icon: Icons.male,
                  label: 'Masculino',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildGenderOption(
                  gender: Gender.female,
                  icon: Icons.female,
                  label: 'Feminino',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Nível de atividade
          Text(
            'Nível de atividade',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<ActivityLevel>(
            value: _activityLevel,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 16,
              ),
            ),
            items: const [
              DropdownMenuItem(
                value: ActivityLevel.sedentary,
                child: Text('Sedentário'),
              ),
              DropdownMenuItem(
                value: ActivityLevel.light,
                child: Text('Leve (1-3x/semana)'),
              ),
              DropdownMenuItem(
                value: ActivityLevel.moderate,
                child: Text('Moderado (3-5x/semana)'),
              ),
              DropdownMenuItem(
                value: ActivityLevel.intense,
                child: Text('Intenso (6-7x/semana)'),
              ),
              DropdownMenuItem(
                value: ActivityLevel.extreme,
                child: Text('Extremo (2x/dia)'),
              ),
            ],
            onChanged: (value) {
              setState(() => _activityLevel = value!);
              _calculateGoal();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGoalConfigPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Meta de hidratação',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),

          // Opção personalizada
          RadioListTile<bool>(
            title: const Text('Meta personalizada (recomendado)'),
            subtitle: Text('${_calculatedGoal}ml por dia'),
            value: true,
            groupValue: _usePersonalizedGoal,
            onChanged: (value) => setState(() => _usePersonalizedGoal = value!),
          ),

          if (_usePersonalizedGoal && _calculatedGoal > 0) ...[
            Container(
              margin: const EdgeInsets.only(left: 32, top: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                HydrationCalculatorService.getGoalDescription(_calculatedGoal),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Opção manual
          RadioListTile<bool>(
            title: const Text('Definir meta manualmente'),
            value: false,
            groupValue: _usePersonalizedGoal,
            onChanged: (value) => setState(() => _usePersonalizedGoal = value!),
          ),

          if (!_usePersonalizedGoal) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: TextField(
                controller: _customGoalController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Meta (ml)',
                  border: OutlineInputBorder(),
                  suffixText: 'ml',
                  helperText: 'Recomendado: 1500ml - 3000ml',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ],

          const SizedBox(height: 20),

          // Notificações
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.notifications_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Lembretes de hidratação',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Switch(
                        value: _allowNotifications,
                        onChanged:
                            (value) =>
                                setState(() => _allowNotifications = value),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Receba lembretes inteligentes para beber água ao longo do dia',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Retorna o texto helper para conversão de peso kg/lbs
  String? _getWeightHelperText() {
    final weightText = _weightController.text.trim();
    if (weightText.isEmpty) return null;

    final weightKg = double.tryParse(weightText);
    if (weightKg == null) return null;

    // Conversão: 1 kg = 2.20462 lbs
    final weightLbs = (weightKg * 2.20462).toStringAsFixed(1);
    return '≈ $weightLbs lbs';
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        if (_currentPage > 0)
          TextButton(onPressed: _previousPage, child: const Text('Voltar')),
        const Spacer(),
        ElevatedButton(
          onPressed: _nextPage,
          child: Text(_currentPage == 2 ? 'Finalizar' : 'Próximo'),
        ),
      ],
    );
  }
}
