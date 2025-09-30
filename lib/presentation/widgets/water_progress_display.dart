import 'package:flutter/material.dart';
import 'dart:math' as math;

class WaterProgressDisplay extends StatefulWidget {
  final int todayTotal;
  final int goalAmount;
  final bool isOverGoal;

  const WaterProgressDisplay({
    super.key,
    required this.todayTotal,
    required this.goalAmount,
    required this.isOverGoal,
  });

  @override
  State<WaterProgressDisplay> createState() => _WaterProgressDisplayState();
}

class _WaterProgressDisplayState extends State<WaterProgressDisplay>
    with TickerProviderStateMixin {
  late AnimationController _dropletsController;
  late AnimationController _counterController;
  late Animation<double> _counterAnimation;

  int _previousTotal = 0;
  int _displayedTotal = 0;

  @override
  void initState() {
    super.initState();
    _dropletsController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _counterController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _counterAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _counterController, curve: Curves.easeOutCubic),
    );

    _previousTotal = widget.todayTotal;
    _displayedTotal = widget.todayTotal;

    _counterAnimation.addListener(() {
      setState(() {
        _displayedTotal =
            _previousTotal + ((widget.todayTotal - _previousTotal) * _counterAnimation.value).round();
      });
    });

    if (widget.isOverGoal) {
      _dropletsController.repeat();
    }
  }

  @override
  void dispose() {
    _dropletsController.dispose();
    _counterController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(WaterProgressDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.todayTotal != widget.todayTotal) {
      _previousTotal = _displayedTotal;
      _counterController.reset();
      _counterController.forward();
    }

    if (widget.isOverGoal && !oldWidget.isOverGoal) {
      _dropletsController.repeat();
    } else if (!widget.isOverGoal && oldWidget.isOverGoal) {
      _dropletsController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                // Título
                Text(
                  'Hidratação de hoje',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 12),
                // Total de água consumida
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$_displayedTotal',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3498DB),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text(
                        'ml',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF3498DB),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  'de ${widget.goalAmount}ml',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                if (widget.isOverGoal) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '+${_displayedTotal - widget.goalAmount}ml extra',
                      style: const TextStyle(
                        color: Color(0xFF4CAF50),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ] else if (_displayedTotal < widget.goalAmount) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Faltam ${widget.goalAmount - _displayedTotal}ml',
                    style: const TextStyle(
                      color: Color(0xFF95A5A6),
                      fontSize: 14,
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      '🎉 Meta atingida!',
                      style: TextStyle(
                        color: Color(0xFF4CAF50),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Efeito de gotas animadas quando ultrapassa a meta
          if (widget.isOverGoal)
            ...List.generate(
              6,
              (index) => AnimatedBuilder(
                animation: _dropletsController,
                builder: (context, child) {
                  final double rotation = (_dropletsController.value * 2 * math.pi) + (index * math.pi / 3);
                  final double radius = 60;
                  final double x = math.cos(rotation) * radius;
                  final double y = math.sin(rotation) * radius;
                  
                  return Transform.translate(
                    offset: Offset(x, y),
                    child: Opacity(
                      opacity: (math.sin(_dropletsController.value * 2 * math.pi) + 1) / 2,
                      child: const Icon(
                        Icons.water_drop,
                        color: Color(0xFF3498DB),
                        size: 16,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
