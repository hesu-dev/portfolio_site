import 'package:flutter/material.dart';
import 'package:nell_weather/features/weather/domain/models/avatar_config.dart';
import 'pixel_avatar_assets.dart';

class AvatarPreviewWidget extends StatefulWidget {
  final AvatarConfig config;
  final double scale;

  const AvatarPreviewWidget({
    super.key,
    required this.config,
    this.scale = 1.0,
  });

  @override
  State<AvatarPreviewWidget> createState() => _AvatarPreviewWidgetState();
}

class _AvatarPreviewWidgetState extends State<AvatarPreviewWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Breathing animation: 0 -> 1 -> 0 loop
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // 1 breath cycle
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Pixel avatar is now 54x75 (3x Res).
    // Original was 18x25 -> size 6.0.
    // 3x Res -> size 2.0.

    final pixelSize = 2.0 * widget.scale;
    final width = PixelAvatarAssets.width * pixelSize;
    final height = PixelAvatarAssets.height * pixelSize;

    return SizedBox(
      width: width,
      height: height,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // Breathing offset: 0 or 1 pixel (visual step)
          // Since it's pixel art, we want strict steps, not smooth float.
          final breathVal = _controller.value;
          final offsetPixels = breathVal > 0.5 ? 1.0 : 0.0;

          return CustomPaint(
            painter: PixelAvatarPainter(
              config: widget.config,
              pixelSize: pixelSize,
              breathOffset: offsetPixels,
            ),
          );
        },
      ),
    );
  }
}

class PixelAvatarPainter extends CustomPainter {
  final AvatarConfig config;
  final double pixelSize;
  final double breathOffset;

  PixelAvatarPainter({
    required this.config,
    required this.pixelSize,
    required this.breathOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Color skinColor = PixelAvatarAssets.getSkinColor(config.skinColorIndex);

    Color darkenSkin(Color skin, {double lightnessFactor = 0.35}) {
      final hsl = HSLColor.fromColor(skin);
      return hsl
          .withLightness((hsl.lightness * lightnessFactor).clamp(0.0, 2.0))
          .toColor();
    }

    Color eyeColor(
      Color skin, {
      double lightnessFactor = 0.75,
      double redOpacity = 0.40,
    }) {
      // 1. 피부색을 먼저 어둡게
      final hsl = HSLColor.fromColor(skin);
      final darkened = hsl
          .withLightness((hsl.lightness * lightnessFactor).clamp(0.0, 1.0))
          .toColor();

      // 2. 붉은기 살짝 블렌드 (핑크/혈색)
      return Color.alphaBlend(
        const Color.fromARGB(
          255,
          255,
          204,
          204,
        ).withOpacity(redOpacity), // 연한 핑크 레드
        darkened,
      );
    }

    // 0. Draw Back Hair (Behind everything)
    if (config.hairBackIndex < PixelAvatarAssets.hairBack.length) {
      _drawLayer(
        canvas,
        PixelAvatarAssets.hairBack[config.hairBackIndex],
        offsetY: 0,
        colorPalette: _getHairPalette(config.hairColorIndex),
        applyBreath: true,
      );
    }

    // 1. Draw Body Base
    _drawLayer(
      canvas,
      PixelAvatarAssets.bodyBase,
      offsetY: 0,
      colorPalette: {
        'S': skinColor,
        'G': HSLColor.fromColor(skinColor)
            .withLightness(
              (HSLColor.fromColor(skinColor).lightness * 0.5).clamp(0.0, 1.0),
            )
            .toColor(),
        'O': const Color.fromARGB(255, 91, 91, 91).withOpacity(0.9),
        'W': Colors.white,
        'T': darkenSkin(skinColor),
      },
      applyBreath: true,
    );

    // 2. Draw Face
    if (config.faceStyleIndex < PixelAvatarAssets.faces.length) {
      _drawLayer(
        canvas,
        PixelAvatarAssets.faces[config.faceStyleIndex],
        offsetX: 3,
        offsetY: 5,
        colorPalette: {
          'W': Colors.white,
          'G': const Color.fromARGB(255, 156, 156, 156).withOpacity(0.2),
          'O': Colors.black.withOpacity(0.7),
          'T': darkenSkin(skinColor),
          'P': eyeColor(skinColor),
          // 'R': const Color.fromARGB(255, 255, 202, 202),
        },
        applyBreath: true,
      );
    }

    // 3. Draw Outfit
    if (config.outfitIndex < PixelAvatarAssets.outfits.length) {
      _drawLayer(
        canvas,
        PixelAvatarAssets.outfits[config.outfitIndex],
        offsetY: 10,
        colorPalette: {
          'O': PixelAvatarAssets.outlineColor,
          '1': Colors.white,
          '2': _getOutfitSecondaryColor(config.outfitIndex),
          '3': Colors.grey,
          '4': _getOutfitPrimaryColor(config.outfitIndex),
        },
        applyBreath: true,
      );
    }

    // 4. Draw Front Hair
    if (config.hairStyleIndex < PixelAvatarAssets.hairFront.length) {
      _drawLayer(
        canvas,
        PixelAvatarAssets.hairFront[config.hairStyleIndex],
        offsetY: 0,
        colorPalette: _getHairPalette(config.hairColorIndex),
        applyBreath: true,
      );
    }

    // 5. Draw Accessories (Hat)
    int accessoryIndex = config.accessoryIndex;
    if (accessoryIndex < PixelAvatarAssets.accessories.length) {
      _drawLayer(
        canvas,
        PixelAvatarAssets.accessories[accessoryIndex],
        offsetY: -3, // Raise hat position higher
        colorPalette: {
          'O': PixelAvatarAssets.outlineColor,
          '1': Colors.red, // Hat Color 1
          '2': Colors.white, // Hat Color 2
        },
        applyBreath: true,
      );
    }
  }

  Map<String, Color> _getHairPalette(int index) {
    Color base = PixelAvatarAssets.getHairColor(index);
    return {
      'O': base, // Remove outline (merge with base)
      'P': base,
      'L': base.withOpacity(0.8),
      'D': base.withOpacity(0.6),
    };
  }

  void _drawLayer(
    Canvas canvas,
    List<String> map, {
    double offsetX = 0,
    double offsetY = 0,
    required Map<String, Color> colorPalette,
    bool applyBreath = false,
  }) {
    for (int y = 0; y < map.length; y++) {
      String row = map[y];
      for (int x = 0; x < row.length; x++) {
        String char = row[x];
        if (char == '.') continue;

        Color? color = colorPalette[char];
        if (color == null) {
          if (char == 'O') color = PixelAvatarAssets.outlineColor;
        }

        if (color != null) {
          double drawY = (offsetY + y);
          double shift = 0;
          if (applyBreath) {
            // High Res (3x Chibi): Threshold Y approx 38 (Head + Neck)
            double absoluteY = offsetY + y;
            if (absoluteY < 38) {
              shift = breathOffset; // Positive = Down
            }
          }

          canvas.drawRect(
            Rect.fromLTWH(
              (offsetX + x) * pixelSize,
              (drawY + shift) * pixelSize,
              pixelSize,
              pixelSize,
            ),
            Paint()..color = color,
          );
        }
      }
    }
  }

  Color _getOutfitPrimaryColor(int index) {
    const colors = [
      Color(0xFFE57373), // Red/Pink
      Color(0xFF64B5F6), // Blue
      Color(0xFFFFB74D), // Orange
      Color(0xFFBA68C8), // Purple
    ];
    return colors[index % colors.length];
  }

  Color _getOutfitSecondaryColor(int index) {
    const colors = [
      Color(0xFF455A64), // Dark Grey
      Color(0xFF5D4037), // Brown
      Color(0xFF1976D2), // Dark Blue
      Color(0xFF388E3C), // Green
    ];
    return colors[index % colors.length];
  }

  @override
  bool shouldRepaint(covariant PixelAvatarPainter oldDelegate) {
    return oldDelegate.config != config ||
        oldDelegate.breathOffset != breathOffset ||
        oldDelegate.pixelSize != pixelSize;
  }
}
