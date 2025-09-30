import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/water_intake.dart';

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

    try {
      widget.onAddWater(waterIntake);
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
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Quantidade (ml)',
                border: OutlineInputBorder(),
                suffixText: 'ml',
              ),
              autofocus: true,
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

  @override
  Widget build(BuildContext context) {
    const containerSize = 300.0;
    const centerX = containerSize / 2;
    const centerY = containerSize / 2;
    const radius = 120.0; // Aumentado de 80 para 120
    const buttonSize = 60.0;
    const buttonOffset = buttonSize / 2;

    final buttonConfigs = [
      {'amount': 250.0, 'angle': math.pi}, // Esquerda
      {'amount': 0.0, 'angle': 0.0}, // Direita (personalizado)
      {'amount': 750.0, 'angle': -math.pi / 2}, // Cima
      {'amount': 500.0, 'angle': -math.pi * 3 / 4}, // Cima-esquerda diagonal
      {'amount': 1000.0, 'angle': -math.pi / 4}, // Cima-direita diagonal
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
              // Botões radiais
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
                        amount == 0 ? 'Personalizado' : '${amount.toInt()}ml',
                        amount == 0
                            ? () => _showCustomAmountDialog(context)
                            : () => _addWater(amount),
                        amount == 0 ? Icons.edit : Icons.local_drink,
                      ),
                    ),
                  ),
                );
              }),

              // Botão central "+"
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
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: AnimatedRotation(
                      turns: widget.isExpanded ? 0.125 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: const Icon(
                        Icons.add,
                        color: Color(0xFF1565C0),
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
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
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
              Icon(icon, color: const Color(0xFF1565C0), size: 18),
              if (label.length <= 6)
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1565C0),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
