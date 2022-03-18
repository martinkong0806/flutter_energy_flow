part of 'energy_flows_icon.dart';

class EnergyFlowsIconPaint extends CustomPainter {
  final Color color;

  final double offsetDistanceRatio;

  final double offsetDirection;

  /// The size of the glow of the icon, this value will
  /// change constantly and contorlled by Animated Controller
  final double glow;
  final bool isActive;

  EnergyFlowsIconPaint(
      {required this.color,
      required this.offsetDistanceRatio,
      required this.offsetDirection,
      required this.glow,
      required this.isActive});

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.shortestSide / 2;
    final Offset center = size.toOffset() / 2;
    final Paint paint = Paint()..color = color;
    canvas.drawGlowCircle(center, radius, paint, glow, isActive);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

extension CutsomCanvasUtils on Canvas {
  void drawGlowCircle(Offset c, double radius, Paint paint, double glow, bool isActive) {
    if(isActive){
drawCircle(c, radius + 2, paint);
      drawCircle(
          c,
          radius * glow,
          paint
            ..color = paint.color.withOpacity(0.5)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5));
    }else{
      drawCircle(c, radius + 2, Paint()..color= Colors.grey);
    }
    
    drawCircle(c, radius, Paint()..color = Colors.white);
  }
}
