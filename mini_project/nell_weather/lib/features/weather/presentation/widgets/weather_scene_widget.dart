import 'dart:math' as math;
import 'package:flutter/material.dart';

enum WeatherType { clear, rain, snow, wind }

class WeatherSceneWidget extends StatefulWidget {
  final WeatherType weatherType;
  final double width;
  final double height;
  final Widget child; // Character widget to be placed on top

  const WeatherSceneWidget({
    super.key,
    required this.weatherType,
    required this.width,
    required this.height,
    required this.child,
  });

  @override
  State<WeatherSceneWidget> createState() => _WeatherSceneWidgetState();
}

class _WeatherSceneWidgetState extends State<WeatherSceneWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<WeatherParticle> _particles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    // Use a simpler logical loop logic: 0.0 to 1.0 repeats
    // The painter needs to handle continuous motion using this value.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20), // Long cycle for smooth looping
    )..repeat();

    _initParticles();
  }

  @override
  void didUpdateWidget(WeatherSceneWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.weatherType != widget.weatherType) {
      _initParticles();
    }
  }

  void _initParticles() {
    _particles.clear();
    int count = 0;

    switch (widget.weatherType) {
      case WeatherType.rain:
        count = 40 + _random.nextInt(21); // 40-60
        break;
      case WeatherType.snow:
        count = 25 + _random.nextInt(11); // 25-35
        break;
      case WeatherType.wind:
        count = 5 + _random.nextInt(4); // 5-8 wind lines
        break;
      case WeatherType.clear:
      default:
        count =
            0; // Sun is drawn procedurally, no multi-particles needed usually, or just 1 sun obj
        break;
    }

    for (int i = 0; i < count; i++) {
      _particles.add(
        WeatherParticle.random(
          _random,
          widget.weatherType,
          widget.width,
          widget.height,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background & Weather Effects
          Positioned.fill(
            child: CustomPaint(
              painter: WeatherScenePainter(
                weatherType: widget.weatherType,
                animation: _controller,
                particles: _particles,
              ),
            ),
          ),

          // Character Layer (passed as child)
          // We align it to bottom center, sitting on the ground
          // Ground height is 80px.
          Positioned(
            bottom:
                60, // Sits on top of 80px ground? No, let's adjust visually.
            // Ground top is at height - 80.
            // Character should stand on height - 80.
            left: 0,
            right: 0,
            child: Center(child: widget.child),
          ),
        ],
      ),
    );
  }
}

class WeatherParticle {
  double x;
  double y;
  double speed;
  double opacity;
  double size; // length for rain/wind, radius for snow
  double offset; // for wavy motion

  WeatherParticle({
    required this.x,
    required this.y,
    required this.speed,
    required this.opacity,
    required this.size,
    required this.offset,
  });

  factory WeatherParticle.random(
    math.Random rng,
    WeatherType type,
    double w,
    double h,
  ) {
    final x = rng.nextDouble() * w;
    final y = rng.nextDouble() * h;

    if (type == WeatherType.rain) {
      // Speed: 180-260 px/sec
      // We normalize this relative to animation controller if needed,
      // but simpler to use constant speed in logic.
      // Storing abstract speed factor here.
      return WeatherParticle(
        x: x,
        y: y,
        speed: 180 + rng.nextDouble() * 80,
        opacity: 0.6 + rng.nextDouble() * 0.4,
        size: 6 + rng.nextDouble() * 4, // length
        offset: rng.nextDouble() * 2 * math.pi,
      );
    } else if (type == WeatherType.snow) {
      // Speed: 20-40 px/sec
      return WeatherParticle(
        x: x,
        y: y,
        speed: 20 + rng.nextDouble() * 20,
        opacity: 0.8 + rng.nextDouble() * 0.2,
        size: 1 + rng.nextDouble() * 2, // radius
        offset: rng.nextDouble() * 2 * math.pi,
      );
    } else if (type == WeatherType.wind) {
      // Wind lines
      return WeatherParticle(
        x: rng.nextDouble() * w * 0.5, // Start mostly left
        y: rng.nextDouble() * (h * 0.6), // Sky area
        speed: 80 + rng.nextDouble() * 40,
        opacity: 0.3 + rng.nextDouble() * 0.3,
        size: 40 + rng.nextDouble() * 60, // length of wind line
        offset: rng.nextDouble(), // Normalized delay
      );
    }

    return WeatherParticle(
      x: 0,
      y: 0,
      speed: 0,
      opacity: 0,
      size: 0,
      offset: 0,
    );
  }
}

class WeatherScenePainter extends CustomPainter {
  final WeatherType weatherType;
  final Animation<double> animation;
  final List<WeatherParticle> particles;

  WeatherScenePainter({
    required this.weatherType,
    required this.animation,
    required this.particles,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    _drawSky(canvas, size);
    _drawWeatherEffects(canvas, size);
    _drawGround(canvas, size);
  }

  void _drawSky(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    List<Color> colors;

    switch (weatherType) {
      case WeatherType.rain:
        colors = [const Color(0xFF455A64), const Color(0xFF263238)];
        break;
      case WeatherType.snow:
        colors = [const Color(0xFFECEFF1), const Color(0xFFCFD8DC)];
        break;
      case WeatherType.wind:
        colors = [const Color(0xFF90A4AE), const Color(0xFFCFD8DC)];
        break;
      case WeatherType.clear:
      default:
        colors = [const Color(0xFF81D4FA), const Color(0xFFE3F2FD)];
        break;
    }

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: const [
          0.0,
          0.6,
        ], // Only top 60% effectively gradiented usually, but fill all
        colors: colors,
      ).createShader(rect);

    canvas.drawRect(rect, paint);
  }

  void _drawGround(Canvas canvas, Size size) {
    const groundHeight = 80.0;
    final groundTop = size.height - groundHeight;
    const pixelSize = 6.0; // Base pixel unit size

    // 1. Soil Background (Base Brown)
    final soilPaint = Paint()..color = const Color(0xFF795548); // Darker soil
    canvas.drawRect(
      Rect.fromLTWH(0, groundTop, size.width, groundHeight),
      soilPaint,
    );

    // 2. Soil Details (Pixel Noise)
    final soilDarkPaint = Paint()..color = const Color(0xFF5D4037); // Even darker spots
    final soilLightPaint = Paint()..color = const Color(0xFF8D6E63); // Lighter spots

    // Deterministic loop for soil texture
    for (double y = groundTop + pixelSize * 4; y < size.height; y += pixelSize) {
      for (double x = 0; x < size.width; x += pixelSize) {
        // Pseudo-random pattern based on coordinates
        int sum = (x + y).toInt();
        if ((sum / pixelSize).floor() % 7 == 0 || (x * y).toInt() % 13 == 0) {
           canvas.drawRect(Rect.fromLTWH(x, y, pixelSize, pixelSize), soilDarkPaint);
        } else if ((sum / pixelSize).floor() % 11 == 0) {
           canvas.drawRect(Rect.fromLTWH(x, y, pixelSize, pixelSize), soilLightPaint);
        }
      }
    }

    // 3. Grass Layer (Jagged Bottom)
    final grassMainPaint = Paint()..color = const Color(0xFF4CAF50); // Main Green
    final grassLightPaint = Paint()..color = const Color(0xFF81C784); // Top Highlight
    final grassShadowPaint = Paint()..color = const Color(0xFF388E3C); // Bottom Shadow/Edge

    // Iterate horizontally by pixelSize to draw grass columns
    for (double x = 0; x < size.width; x += pixelSize) {
      // Determine interlocking depth pattern
      // Pattern: Deep, Shallow, Medium, Deep... 
      // Like: [3, 2, 2, 3, 2, 4, 2] blocks deep
      int colIndex = (x / pixelSize).floor();
      int depthBlocks = 2; // Min depth
      
      // Create jagged pattern
      if (colIndex % 2 == 0) depthBlocks += 1;
      if (colIndex % 5 == 0) depthBlocks += 1;
      
      double grassDepth = depthBlocks * pixelSize;

      // Draw Main Grass Column
      canvas.drawRect(
        Rect.fromLTWH(x, groundTop, pixelSize, grassDepth),
        grassMainPaint,
      );

      // Draw Top Highlight (First block)
      canvas.drawRect(
        Rect.fromLTWH(x, groundTop, pixelSize, pixelSize),
        grassLightPaint,
      );

      // Draw Shadow (Bottom-most block of the grass column)
      // This gives the "edge" feeling where it meets soil
      canvas.drawRect(
        Rect.fromLTWH(x, groundTop + grassDepth - pixelSize, pixelSize, pixelSize),
        grassShadowPaint,
      );
    }
  }

  void _drawWeatherEffects(Canvas canvas, Size size) {
    final t = animation.value; // 0.0 to 1.0 (loops over 20 sec)
    final timeSec = t * 20.0;

    if (weatherType == WeatherType.clear) {
      _drawSun(canvas, size, timeSec);
    } else if (weatherType == WeatherType.rain) {
      _drawRain(canvas, size, timeSec);
    } else if (weatherType == WeatherType.snow) {
      _drawSnow(canvas, size, timeSec);
    } else if (weatherType == WeatherType.wind) {
      _drawWind(canvas, size, timeSec);
    }
  }

  void _drawSun(Canvas canvas, Size size, double time) {
    final sunCenter = Offset(size.width - 60, 60);
    final sunRadius = 18.0;

    final paintSun = Paint()
      ..color = const Color(0xFFFFEB3B)
      ..style = PaintingStyle.fill;

    // Circle
    canvas.drawCircle(sunCenter, sunRadius, paintSun);

    // Rays
    final paintRay = Paint()
      ..color = const Color(0xFFFFEB3B)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.square; // Hard edge

    final rayCount = 8;
    final rotation = time * 0.5; // Slow rotation

    for (int i = 0; i < rayCount; i++) {
      final angle = (2 * math.pi * i / rayCount) + rotation;
      final rayStart = Offset(
        sunCenter.dx + math.cos(angle) * (sunRadius + 4),
        sunCenter.dy + math.sin(angle) * (sunRadius + 4),
      );
      final rayEnd = Offset(
        sunCenter.dx + math.cos(angle) * (sunRadius + 14),
        sunCenter.dy + math.sin(angle) * (sunRadius + 14),
      );
      canvas.drawLine(rayStart, rayEnd, paintRay);
    }
  }

  void _drawRain(Canvas canvas, Size size, double time) {
    final paintRain = Paint()
      ..color = const Color(0xFFB3E5FC)
      ..strokeWidth = 2; // Pixel rain

    for (var p in particles) {
      // Calculate current position based on time
      // y = initial + speed * time
      // Modulo height to loop
      double currentY = (p.y + p.speed * time) % (size.height + 20);
      double currentX =
          (p.x + (currentY - p.y) * 0.2) % size.width; // Slight diagonal

      // Reset to top visually if passed bottom
      if (currentY > size.height) {
        currentY -= size.height + 20;
      }

      final p1 = Offset(currentX, currentY);
      final p2 = Offset(currentX - 2, currentY - p.size); // Diagonal line

      canvas.drawLine(p1, p2, paintRain);
    }
  }

  void _drawSnow(Canvas canvas, Size size, double time) {
    final paintSnow = Paint()..color = Colors.white;

    for (var p in particles) {
      double currentY = (p.y + p.speed * time) % (size.height + 10);

      // Horizontal drift (Sine wave)
      double drift = math.sin(time * 2 + p.offset) * 10;
      double currentX = (p.x + drift) % size.width;
      if (currentX < 0) currentX += size.width;

      canvas.drawCircle(Offset(currentX, currentY), p.size, paintSnow);
    }
  }

  void _drawWind(Canvas canvas, Size size, double time) {
    final paintWind = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (var p in particles) {
      // Move horizontally
      double currentX = (p.x + p.speed * time) % (size.width + 100);
      double currentY = p.y;

      // Reset if offscreen
      if (currentX > size.width + 50) currentX -= (size.width + 150);

      // Draw curved line
      final path = Path();
      path.moveTo(currentX - p.size, currentY);
      path.quadraticBezierTo(
        currentX - p.size / 2,
        currentY - 10,
        currentX,
        currentY,
      );

      canvas.drawPath(path, paintWind);
    }
  }

  @override
  bool shouldRepaint(covariant WeatherScenePainter oldDelegate) {
    return true; // Always repaint for animation
  }
}
