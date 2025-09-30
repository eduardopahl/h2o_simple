import 'dart:math' as math;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../theme/app_theme.dart';

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
    // Throttle do acelerômetro para economizar bateria
    _accelerometerSubscription = accelerometerEvents.listen((
      AccelerometerEvent event,
    ) {
      if (!mounted) return;

      // Inclinar a água baseado na orientação do dispositivo
      final threshold = 0.3;
      final newTiltX = math.max(
        -1.0,
        math.min(
          1.0,
          event.x > threshold || event.x < -threshold ? event.x : 0,
        ),
      );
      final newTiltY = math.max(
        -1.0,
        math.min(
          1.0,
          event.y > threshold || event.y < -threshold ? event.y : 0,
        ),
      );

      // Só atualizar se houver mudança significativa
      if ((newTiltX - _waterTiltX).abs() > 0.1 ||
          (newTiltY - _waterTiltY).abs() > 0.1) {
        setState(() {
          _waterTiltX = newTiltX.toDouble();
          _waterTiltY = newTiltY.toDouble();
        });
      }
    });
  }

  void _updateWaterPhysics() {
    // Física de movimento da água com limites
    const damping = 0.95;
    const sensitivity = 0.08;

    // Movimentos mínimos e máximos para naturalidade
    const minWaveSpeed = 0.02; // Animação mínima quando parado
    const maxWaveSpeed = 0.06; // Animação máxima
    const minTiltEffect = 0.1; // Inclinação mínima
    const maxTiltEffect = 0.25; // Inclinação máxima

    // Salvar estado anterior para comparação
    final oldWavePhase = _wavePhase;
    final oldWaterLevel = _waterLevel;

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
    final tiltIntensity = _waterTiltX.abs().clamp(minTiltEffect, maxTiltEffect);
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

    // Só fazer setState se houve mudança significativa
    if ((oldWavePhase - _wavePhase).abs() > 0.01 ||
        (oldWaterLevel - _waterLevel).abs() > 0.01) {
      if (mounted) {
        setState(() {});
      }
    }
  }

  // Função para mapear progresso linear para visualização não-linear
  double _mapProgressToVisual(double progress) {
    progress = progress.clamp(0.0, 1.0);

    // Função que dá mais espaço visual para valores menores
    final mapped = math.pow(progress, 0.75) * 0.85;

    return mapped.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final mappedProgress = _mapProgressToVisual(_currentProgress);

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
              if (mappedProgress > 0)
                AnimatedBuilder(
                  animation: _physicsController,
                  builder: (context, child) {
                    final isDark =
                        Theme.of(context).brightness == Brightness.dark;

                    return CustomPaint(
                      size: Size(constraints.maxWidth, constraints.maxHeight),
                      painter: RealisticWaterPainter(
                        tiltX: _waterTiltX,
                        tiltY: _waterTiltY,
                        velocityX: _waterVelocityX,
                        velocityY: _waterVelocityY,
                        wavePhase: _wavePhase,
                        waterLevel: _waterLevel,
                        progress: mappedProgress,
                        totalHeight: screenHeight - safeAreaTop,
                        availableHeight: totalAvailableHeight,
                        lightBlue:
                            isDark
                                ? AppTheme.darkLightBlue
                                : AppTheme.lightBlue,
                        darkBlue:
                            isDark ? AppTheme.darkDarkBlue : AppTheme.darkBlue,
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
  final Color lightBlue;
  final Color darkBlue;

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
    required this.lightBlue,
    required this.darkBlue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0 || progress <= 0) return;

    // Calcular altura da água baseada no progresso
    final waterHeight = availableHeight * progress;
    final waterBottom = size.height; // Fundo da tela
    final waterTop = waterBottom - waterHeight; // Topo da água

    // Desenhar o corpo da água com ondas integradas
    _drawWaterBody(canvas, size, waterTop, waterBottom);
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
              lightBlue.withValues(alpha: 0.3),
              lightBlue.withValues(alpha: 0.8),
              darkBlue,
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

    // Calcular agitação uma vez fora do loop para performance
    final movementIntensity = math.sqrt(
      velocityX * velocityX + velocityY * velocityY,
    );
    final agitationMultiplier = (movementIntensity * 3).clamp(0.3, 1.0);

    // Criar superfície suave com múltiplas camadas de ondas integradas
    // Otimizar segmentos baseado no tamanho da tela
    final segments = (size.width / 10).round().clamp(30, 60); // 30-60 segmentos
    for (int i = 0; i <= segments; i++) {
      final x = (i / segments) * size.width;
      final progress = i / segments;

      // Interpolação linear da altura base
      final baseHeight =
          leftSurfaceHeight +
          (rightSurfaceHeight - leftSurfaceHeight) * progress;

      // Cache dos cálculos trigonométricos para performance
      final progressPi = progress * math.pi;
      final wavePhaseCache = wavePhase;

      // Ondas principais (grandes e lentas)
      final primaryWaveHeight =
          15 * math.sin((progressPi * 3) + wavePhaseCache);

      // Ondas secundárias (médias e rápidas) - integradas
      final secondaryWaveHeight =
          8 * math.sin((progressPi * 6) + wavePhaseCache * 1.5);

      // Ondas terciárias (pequenas e muito rápidas) - para textura
      final tertiaryWaveHeight =
          4 * math.sin((progressPi * 12) + wavePhaseCache * 2.5);

      // Agitação baseada no movimento (cache de intensity)
      final agitationHeight =
          6 *
          agitationMultiplier *
          math.sin((progressPi * 8) + wavePhaseCache * 2.0);

      // Combinar todas as ondas
      final finalHeight =
          baseHeight +
          primaryWaveHeight +
          (secondaryWaveHeight * 0.6) +
          (tertiaryWaveHeight * 0.4) +
          agitationHeight;

      path.lineTo(x, finalHeight);
    }

    path.lineTo(size.width, waterBottom);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant RealisticWaterPainter oldDelegate) {
    const tolerance = 0.01; // Tolerância para evitar redesenhos micro

    return (oldDelegate.tiltX - tiltX).abs() > tolerance ||
        (oldDelegate.tiltY - tiltY).abs() > tolerance ||
        (oldDelegate.velocityX - velocityX).abs() > tolerance ||
        (oldDelegate.velocityY - velocityY).abs() > tolerance ||
        (oldDelegate.wavePhase - wavePhase).abs() > tolerance ||
        (oldDelegate.waterLevel - waterLevel).abs() > tolerance ||
        (oldDelegate.progress - progress).abs() >
            0.001 || // Progresso mais sensível
        oldDelegate.lightBlue != lightBlue ||
        oldDelegate.darkBlue != darkBlue;
  }
}
