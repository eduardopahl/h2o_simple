import 'dart:math' as math;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/water_intake.dart';
import '../../providers/water_intake_provider.dart';
import '../../providers/daily_goal_provider.dart';

class DailyTab extends ConsumerStatefulWidget {
  const DailyTab({super.key});

  @override
  ConsumerState<DailyTab> createState() => _DailyTabState();
}

class _DailyTabState extends ConsumerState<DailyTab>
    with TickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Timer _timer;
  DateTime _currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFE),
      body: SafeArea(
        child: Consumer(
          builder: (context, ref, child) {
            final todayTotalAsync = ref.watch(waterIntakeProvider);
            final currentGoalAsync = ref.watch(dailyGoalProvider);

            return todayTotalAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error:
                  (error, stack) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 48),
                        const SizedBox(height: 16),
                        Text('Erro ao carregar dados: $error'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            ref.invalidate(waterIntakeProvider);
                            ref.invalidate(dailyGoalProvider);
                          },
                          child: const Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  ),
              data: (intakes) {
                final todayTotal = intakes.fold<int>(
                  0,
                  (total, intake) => total + intake.amount,
                );
                final currentGoal = currentGoalAsync.valueOrNull;
                final goalAmount =
                    currentGoal?.targetAmount.toDouble() ?? 2000.0;
                final progress = (todayTotal / goalAmount).clamp(0.0, 1.0);

                return Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (_isExpanded) {
                          _toggleExpanded();
                        }
                      },
                      child: _buildWaterFillEffect(
                        context,
                        progress,
                        todayTotal,
                        goalAmount.toInt(),
                      ),
                    ),

                    Positioned(top: 20, left: 20, child: _buildMiniCalendar()),
                    _buildFloatingButtons(context),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildMiniCalendar() {
    final now = _currentTime;
    final dayNames = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
    final monthNames = [
      'Jan',
      'Fev',
      'Mar',
      'Abr',
      'Mai',
      'Jun',
      'Jul',
      'Ago',
      'Set',
      'Out',
      'Nov',
      'Dez',
    ];

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF1565C0),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  monthNames[now.month - 1].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  now.day.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),
          Text(
            dayNames[now.weekday % 7],
            style: const TextStyle(
              color: Color(0xFF2C3E50),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
            style: const TextStyle(
              color: Color(0xFF7F8C8D),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaterFillEffect(
    BuildContext context,
    double progress,
    int todayTotal,
    int goalAmount,
  ) {
    final isOverGoal = todayTotal > goalAmount;
    final actualProgress = isOverGoal ? 1.0 : progress;

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenHeight = MediaQuery.of(context).size.height;
        final safeAreaTop = MediaQuery.of(context).padding.top;
        final safeAreaBottom = MediaQuery.of(context).padding.bottom;
        final bottomNavBarHeight = kBottomNavigationBarHeight + safeAreaBottom;
        final totalAvailableHeight =
            screenHeight - safeAreaTop - bottomNavBarHeight;
        final waterHeight = (totalAvailableHeight * actualProgress).clamp(
          0.0,
          totalAvailableHeight,
        );

        return Container(
          width: double.infinity,
          height: screenHeight - safeAreaTop,
          decoration: const BoxDecoration(color: Color(0xFFF8FAFE)),
          child: Stack(
            children: [
              if (actualProgress > 0)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: waterHeight,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF1565C0).withValues(alpha: 0.3),
                          const Color(0xFF1565C0).withValues(alpha: 0.8),
                          const Color(0xFF0D47A1),
                        ],
                      ),
                    ),
                    child: CustomPaint(
                      painter: WaterWavePainter(
                        animationValue: (_currentTime.millisecond / 1000.0)
                            .clamp(0.0, 1.0),
                        waveHeight: 20,
                      ),
                    ),
                  ),
                ),

              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${todayTotal}ml',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1565C0),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'de ${goalAmount}ml',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF7F8C8D),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isOverGoal
                            ? '🎉 Meta alcançada!'
                            : '${((actualProgress * 100).round())}% concluído',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color:
                              isOverGoal
                                  ? const Color(0xFF27AE60)
                                  : const Color(0xFF1565C0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (isOverGoal)
                ...List.generate(
                  10,
                  (index) => Positioned(
                    left: (index * 40.0) % MediaQuery.of(context).size.width,
                    top: (index * 60.0) % 200 + 50,
                    child: AnimatedOpacity(
                      opacity: (_currentTime.second % 2 == 0) ? 1.0 : 0.5,
                      duration: const Duration(milliseconds: 500),
                      child: const Icon(
                        Icons.water_drop,
                        color: Color(0xFF1565C0),
                        size: 16,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFloatingButtons(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Positioned(
          bottom:
              kBottomNavigationBarHeight +
              MediaQuery.of(context).padding.bottom +
              30,
          left: 0,
          right: 0,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                SizedBox(
                  height: _isExpanded ? 100 : 0,
                  width: 240,
                  child:
                      _isExpanded
                          ? Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                left: 15,
                                top: 45,
                                child: _buildRadialButton(
                                  250,
                                  '250ml',
                                  Icons.local_drink,
                                  0,
                                ),
                              ),
                              Positioned(
                                left: 95,
                                top: 25,
                                child: _buildRadialButton(
                                  500,
                                  '500ml',
                                  Icons.local_bar,
                                  1,
                                ),
                              ),
                              Positioned(
                                left: 175,
                                top: 45,
                                child: _buildRadialButton(
                                  750,
                                  '750ml',
                                  Icons.sports_bar,
                                  2,
                                ),
                              ),
                            ],
                          )
                          : const SizedBox.shrink(),
                ),

                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 40 + 16),
                    GestureDetector(
                      onTap: () {
                        _toggleExpanded();
                      },
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF1565C0),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: AnimatedRotation(
                          duration: const Duration(milliseconds: 300),
                          turns: _isExpanded ? 0.125 : 0,
                          child: const Icon(
                            Icons.add,
                            color: Color(0xFF1565C0),
                            size: 28,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),
                    _buildCustomFloatingButton(),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRadialButton(
    double amount,
    String label,
    IconData icon,
    int delayIndex,
  ) {
    return AnimatedScale(
      duration: Duration(milliseconds: 300 + (delayIndex * 100)),
      scale: _isExpanded ? 1.0 : 0.0,
      curve: Curves.elasticOut,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 200 + (delayIndex * 50)),
        opacity: _isExpanded ? 1.0 : 0.0,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF1565C0), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () {
                _addWater(amount);
                _toggleExpanded();
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: const Color(0xFF1565C0), size: 22),
                  const SizedBox(height: 2),
                  Text(
                    label.replaceAll('ml', ''),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1565C0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomFloatingButton() {
    return GestureDetector(
      onTap: () {
        _showCustomAmountDialog(context);
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF1565C0), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.edit, color: Color(0xFF1565C0), size: 16),
      ),
    );
  }

  void _addWater(double amount) {
    final waterIntake = WaterIntake(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: amount.toInt(),
      timestamp: DateTime.now(),
    );

    try {
      ref.read(waterIntakeProvider.notifier).addWaterIntake(waterIntake);
    } catch (e) {
      // Handle error silently or show user-friendly message
    }
  }

  void _showCustomAmountDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text('Quantidade Personalizada'),
            content: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              decoration: InputDecoration(
                labelText: 'Quantidade (ml)',
                hintText: 'Ex: 350',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(
                  Icons.water_drop,
                  color: Color(0xFF1565C0),
                ),
                suffixText: 'ml',
                counterText: '',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  final text = controller.text.trim();
                  if (text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Digite uma quantidade válida'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  final amount = int.tryParse(text);
                  if (amount != null && amount > 0 && amount <= 9999) {
                    _addWater(amount.toDouble());
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Digite um valor entre 1 e 9999 ml'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Adicionar'),
              ),
            ],
          ),
    );
  }
}

class WaterWavePainter extends CustomPainter {
  final double animationValue;
  final double waveHeight;

  WaterWavePainter({required this.animationValue, required this.waveHeight});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final paint =
        Paint()
          ..color = Colors.white.withValues(alpha: 0.3)
          ..style = PaintingStyle.fill;

    final path = Path();
    final waveLength = (size.width / 2).clamp(1.0, double.infinity);
    final waveSpeed = (animationValue * 2 * math.pi).clamp(-100.0, 100.0);

    path.moveTo(0, size.height);

    for (double x = 0; x <= size.width; x += 2) {
      final normalizedX = (x / waveLength) * 2 * math.pi;
      final y =
          math.sin(normalizedX + waveSpeed) *
          waveHeight.clamp(0.0, size.height / 4);
      path.lineTo(x, size.height - waveHeight.abs() + y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
