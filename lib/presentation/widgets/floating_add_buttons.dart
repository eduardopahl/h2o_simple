import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../domain/entities/water_intake.dart';
import '../theme/app_theme.dart';
import '../dialogs/custom_amount_dialog.dart';

class FloatingAddButtons extends StatefulWidget {
  final bool isExpanded;
  final VoidCallback onToggle;
  final Function(WaterIntake) onAddWater;

  const FloatingAddButtons({
    super.key,
    required this.isExpanded,
    required this.onToggle,
    required this.onAddWater,
  });

  @override
  State<FloatingAddButtons> createState() => _FloatingAddButtonsState();
}

class _FloatingAddButtonsState extends State<FloatingAddButtons>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(FloatingAddButtons oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  void _addWater(double amount) {
    final waterIntake = WaterIntake(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: amount.toInt(),
      timestamp: DateTime.now(),
    );

    widget.onAddWater(waterIntake);
  }

  void _showCustomAmountDialog(BuildContext context) {
    showCustomAmountDialog(
      context,
      onAmountSelected: (amount) => _addWater(amount.toDouble()),
    );
  }

  @override
  Widget build(BuildContext context) {
    const containerSize = 300.0;
    const centerX = containerSize / 2;
    const centerY = containerSize / 2;
    const radius = 90.0; // distancia entre os botoes
    const buttonSize = 60.0;
    const buttonOffset = buttonSize / 2;

    final buttonConfigs = [
      {'amount': 250.0, 'angle': math.pi},
      {'amount': 0.0, 'angle': 0.0},
      {'amount': 750.0, 'angle': -math.pi / 2},
      {'amount': 500.0, 'angle': -math.pi * 3 / 4},
      {'amount': 1000.0, 'angle': -math.pi / 4},
    ];

    return Positioned(
      bottom: 10,
      left: 0,
      right: 0,
      child: Center(
        child: SizedBox(
          width: containerSize,
          height: containerSize,
          child: Stack(
            children: [
              ...buttonConfigs.asMap().entries.map((entry) {
                final index = entry.key;
                final config = entry.value;
                final amount = config['amount'] as double;
                final angle = config['angle'] as double;

                final x = centerX + radius * math.cos(angle) - buttonOffset;
                final y = centerY + radius * math.sin(angle) - buttonOffset;

                return AnimatedPositioned(
                  duration: Duration(milliseconds: 300 + (index * 50)),
                  curve: Curves.elasticOut,
                  left: widget.isExpanded ? x : centerX - buttonOffset,
                  top: widget.isExpanded ? y : centerY - buttonOffset,
                  child: AnimatedScale(
                    scale: widget.isExpanded ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 200 + (index * 30)),
                    curve: Curves.easeOutBack,
                    child: AnimatedOpacity(
                      opacity: widget.isExpanded ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 150 + (index * 25)),
                      child: _buildRadialButton(
                        amount == 0
                            ? AppLocalizations.of(context).custom
                            : '${amount.toInt()}ml',
                        amount == 0
                            ? () => _showCustomAmountDialog(context)
                            : () => _addWater(amount),
                        amount == 0 ? Icons.edit : Icons.local_drink,
                      ),
                    ),
                  ),
                );
              }),

              Positioned(
                left: centerX - buttonOffset,
                top: centerY - buttonOffset,
                child: GestureDetector(
                  onTap: widget.onToggle,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: buttonSize,
                    height: buttonSize,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.shadowColor,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: AnimatedRotation(
                      turns: widget.isExpanded ? 0.125 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        Icons.add,
                        color: AppTheme.lightBlue,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadialButton(
    String label,
    VoidCallback onPressed,
    IconData icon,
  ) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor,
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onPressed,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppTheme.lightBlue, size: 18),
              if (label.length <= 6)
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.lightBlue,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
