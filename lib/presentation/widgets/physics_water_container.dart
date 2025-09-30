import 'dart:math' as math;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class PhysicsWaterContainer extends StatefulWidget {
  final double progress;
  final Widget child;

  const PhysicsWaterContainer({
    super.key,
    required this.progress,
    required this.child,
  });

  @override
  State<PhysicsWaterContainer> createState() => _PhysicsWaterContainerState();
}

class _PhysicsWaterContainerState extends State<PhysicsWaterContainer>
    with TickerProviderStateMixin {
  late AnimationController _physicsController;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  late StreamSubscription<AccelerometerEvent> _accelerometerSubscription;

  // Física da água
  double _waterTiltX = 0.0;
  double _waterTiltY = 0.0;
  double _waterVelocityX = 0.0;
  double _waterVelocityY = 0.0;
  double _wavePhase = 0.0;
  double _waterLevel = 0.0;

  // Animação do progresso
  double _currentProgress = 0.0;
  double _targetProgress = 0.0;
  double _previousProgress = 0.0;

  @override
  void initState() {
    super.initState();

    _physicsController = AnimationController(
      duration: const Duration(milliseconds: 16), // 60 FPS
      vsync: this,
    )..repeat();

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1200), // Animação do progresso
      vsync: this,
    );

    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOutCubic),
    );

    _progressAnimation.addListener(() {
      setState(() {
        _currentProgress =
            _previousProgress +
            (_targetProgress - _previousProgress) * _progressAnimation.value;
      });
    });

    _physicsController.addListener(_updateWaterPhysics);
    _startAccelerometer();

    // Inicializar progresso
    _currentProgress = widget.progress;
    _targetProgress = widget.progress;
    _previousProgress = widget.progress;
  }

  @override
  void dispose() {
    _physicsController.dispose();
    _progressController.dispose();
    _accelerometerSubscription.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(PhysicsWaterContainer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.progress != widget.progress) {
      _previousProgress = _currentProgress; // Salvar o nível atual
      _targetProgress = widget.progress;
      _progressController.reset();
      _progressController.forward();
    }
  }

  void _startAccelerometer() {
    _accelerometerSubscription = accelerometerEvents.listen((
      AccelerometerEvent event,
    ) {
      setState(() {
        // Inclinar a água baseado na orientação do dispositivo
        final threshold = 0.3;
        _waterTiltX = math.max(
          -1.0,
          math.min(
            1.0,
            event.x > threshold || event.x < -threshold ? event.x : 0,
          ),
        );
        _waterTiltY = math.max(
          -1.0,
          math.min(
            1.0,
            event.y > threshold || event.y < -threshold ? event.y : 0,
          ),
        );
      });
    });
  }

  void _updateWaterPhysics() {
    setState(() {
      // Física de movimento da água com limites
      const damping = 0.95;
      const sensitivity = 0.08;

      // Movimentos mínimos e máximos para naturalidade
      const minWaveSpeed = 0.02; // Animação mínima quando parado
      const maxWaveSpeed = 0.06; // Animação máxima
      const minTiltEffect = 0.1; // Inclinação mínima
      const maxTiltEffect = 0.25; // Inclinação máxima

      // Atualizar velocidades baseado na inclinação
      _waterVelocityX += _waterTiltX * sensitivity;
      _waterVelocityY += _waterTiltY * sensitivity;

      // Aplicar amortecimento
      _waterVelocityX *= damping;
      _waterVelocityY *= damping;

      // Limitar velocidade máxima para manter naturalidade
      _waterVelocityX = _waterVelocityX.clamp(-0.5, 0.5);
      _waterVelocityY = _waterVelocityY.clamp(-0.5, 0.5);

      // Calcular nível da água baseado na inclinação com limites
      final tiltIntensity = _waterTiltX.abs().clamp(
        minTiltEffect,
        maxTiltEffect,
      );
      _waterLevel = (_waterTiltX.sign * tiltIntensity) * 0.15;

      // Calcular velocidade de onda com mínimo e máximo
      final movementIntensity = math.sqrt(
        _waterVelocityX * _waterVelocityX + _waterVelocityY * _waterVelocityY,
      );

      // Garantir animação mínima sempre + movimento baseado na física (limitado)
      final waveSpeed =
          minWaveSpeed +
          (movementIntensity * 0.3).clamp(0, maxWaveSpeed - minWaveSpeed);

      // Atualizar fase das ondas com velocidade controlada
      _wavePhase += waveSpeed;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Limitar progresso para não ultrapassar 85% da tela disponível
    final actualProgress = _currentProgress.clamp(0.0, 0.85);

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenHeight = MediaQuery.of(context).size.height;
        final safeAreaTop = MediaQuery.of(context).padding.top;
        final safeAreaBottom = MediaQuery.of(context).padding.bottom;
        final bottomNavBarHeight = kBottomNavigationBarHeight + safeAreaBottom;
        final totalAvailableHeight =
            screenHeight - safeAreaTop - bottomNavBarHeight;

        return Container(
          width: double.infinity,
          height: screenHeight - safeAreaTop,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: Stack(
            children: [
              // Água com física que representa o progresso
              if (actualProgress > 0)
                AnimatedBuilder(
                  animation: _physicsController,
                  builder: (context, child) {
                    return CustomPaint(
                      size: Size(constraints.maxWidth, constraints.maxHeight),
                      painter: RealisticWaterPainter(
                        tiltX: _waterTiltX,
                        tiltY: _waterTiltY,
                        velocityX: _waterVelocityX,
                        velocityY: _waterVelocityY,
                        wavePhase: _wavePhase,
                        waterLevel: _waterLevel,
                        progress: actualProgress,
                        totalHeight: screenHeight - safeAreaTop,
                        availableHeight: totalAvailableHeight,
                      ),
                    );
                  },
                ),

              // Child widget (como display de progresso)
              widget.child,
            ],
          ),
        );
      },
    );
  }
}

class RealisticWaterPainter extends CustomPainter {
  final double tiltX;
  final double tiltY;
  final double velocityX;
  final double velocityY;
  final double wavePhase;
  final double waterLevel;
  final double progress;
  final double totalHeight;
  final double availableHeight;

  RealisticWaterPainter({
    required this.tiltX,
    required this.tiltY,
    required this.velocityX,
    required this.velocityY,
    required this.wavePhase,
    required this.waterLevel,
    required this.progress,
    required this.totalHeight,
    required this.availableHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0 || progress <= 0) return;

    // Calcular altura da água baseada no progresso
    final waterHeight = availableHeight * progress;
    final waterBottom = size.height; // Fundo da tela
    final waterTop = waterBottom - waterHeight; // Topo da água

    // Desenhar o corpo da água (gradiente)
    _drawWaterBody(canvas, size, waterTop, waterBottom);

    // Desenhar superfície com física
    _drawWaterSurface(canvas, size, waterTop);

    // Ondas dinâmicas na superfície
    _drawDynamicWaves(canvas, size, waterTop);
  }

  void _drawWaterBody(
    Canvas canvas,
    Size size,
    double waterTop,
    double waterBottom,
  ) {
    final paint =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(
                0xFF42A5F5,
              ).withValues(alpha: 0.3), // Material Light Blue
              const Color(0xFF42A5F5).withValues(alpha: 0.8),
              const Color(0xFF1976D2), // Material Blue
            ],
          ).createShader(
            Rect.fromLTWH(0, waterTop, size.width, waterBottom - waterTop),
          );

    final path = Path();

    // Calcular inclinação da superfície baseada na física
    final leftSurfaceHeight = waterTop + (waterLevel * size.width * 0.2);
    final rightSurfaceHeight = waterTop - (waterLevel * size.width * 0.2);

    // Desenhar corpo da água com superfície inclinada
    path.moveTo(0, waterBottom);
    path.lineTo(0, leftSurfaceHeight);

    // Criar superfície suave da esquerda para direita
    const segments = 30;
    for (int i = 0; i <= segments; i++) {
      final x = (i / segments) * size.width;
      final progress = i / segments;

      // Interpolação linear da altura + ondas físicas controladas
      final baseHeight =
          leftSurfaceHeight +
          (rightSurfaceHeight - leftSurfaceHeight) * progress;

      // Ondas principais com amplitude controlada
      final waveHeight = 8 * math.sin((progress * 3 * math.pi) + wavePhase);

      // Agitação baseada no movimento, mas limitada
      final movementIntensity = math.sqrt(
        velocityX * velocityX + velocityY * velocityY,
      );
      final agitationMultiplier = (movementIntensity * 3).clamp(
        0.3,
        1.0,
      ); // Min 30%, Max 100%
      final agitationHeight =
          6 *
          agitationMultiplier *
          math.sin((progress * 6 * math.pi) + wavePhase * 1.5);

      final finalHeight = baseHeight + waveHeight + agitationHeight;
      path.lineTo(x, finalHeight);
    }

    path.lineTo(size.width, waterBottom);
    path.close();

    canvas.drawPath(path, paint);
  }

  void _drawWaterSurface(Canvas canvas, Size size, double waterTop) {
    final paint =
        Paint()
          ..color = const Color(0xFFFFFFFF).withValues(alpha: 0.1)
          ..style = PaintingStyle.fill;

    final path = Path();

    // Criar superfície brilhante na água
    final leftHeight = waterTop + (waterLevel * size.width * 0.2);
    final rightHeight = waterTop - (waterLevel * size.width * 0.2);

    path.moveTo(0, leftHeight);

    // Superfície com ondas sutis
    const segments = 15;
    for (int i = 0; i <= segments; i++) {
      final x = (i / segments) * size.width;
      final progress = i / segments;

      final baseHeight = leftHeight + (rightHeight - leftHeight) * progress;
      final waveHeight = 3 * math.sin((progress * 4 * math.pi) + wavePhase * 2);

      final finalHeight = baseHeight + waveHeight;
      path.lineTo(x, finalHeight);
    }

    path.lineTo(size.width, rightHeight + 15);
    path.lineTo(0, leftHeight + 15);
    path.close();

    canvas.drawPath(path, paint);
  }

  void _drawDynamicWaves(Canvas canvas, Size size, double waterTop) {
    // Ondas brancas na superfície para efeito controlado
    final wavePaint =
        Paint()
          ..color = const Color(0xFFFFFFFF).withValues(alpha: 0.25)
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke;

    final path = Path();

    for (double x = 0; x <= size.width; x += 4) {
      final progress = x / size.width;
      final baseY =
          waterTop + (waterLevel * size.width * 0.2 * (1 - 2 * progress));

      // Ondas com amplitude controlada
      final waveAmplitude = 6.0; // Amplitude fixa mais suave
      final waveY =
          baseY +
          waveAmplitude * math.sin((progress * 5 * math.pi) + wavePhase * 1.8);

      if (x == 0) {
        path.moveTo(x, waveY);
      } else {
        path.lineTo(x, waveY);
      }
    }

    canvas.drawPath(path, wavePaint);
  }

  @override
  bool shouldRepaint(covariant RealisticWaterPainter oldDelegate) {
    return oldDelegate.tiltX != tiltX ||
        oldDelegate.tiltY != tiltY ||
        oldDelegate.velocityX != velocityX ||
        oldDelegate.velocityY != velocityY ||
        oldDelegate.wavePhase != wavePhase ||
        oldDelegate.waterLevel != waterLevel ||
        oldDelegate.progress != progress;
  }
}
