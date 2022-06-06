part of '../outer_rail.dart';

class OuterRailPainter extends CustomPainter {
  final double rotation, startAngle, sweepAngle, glowScale;
  final bool isActive;
  final EnergyFlowAppearance appearance;

  Color? color;

  OuterRailPainter(
      {required this.startAngle,
      required this.sweepAngle,
      required this.rotation,
      required this.color,
      required this.glowScale,
      required this.isActive,
      required this.appearance});

  /// The size of the glow is measured in radians
  final double glowSize = math.pi / 4;
  final double glowOffset = -math.pi / 4 / 2;

  double t = 0.6;
  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.toOffset() / 2;
    final double railRadius = size.shortestSide / 2.5;

    final Paint railPaint = Paint()
      ..color =
          isActive ? appearance.activeRailColor : appearance.inactiveRailColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    //  Background Rail
    canvas.drawArc(Rect.fromCircle(center: center, radius: railRadius),
        startAngle, sweepAngle, false, railPaint);

    ///Highlighted Rail
    if (isActive) {
      canvas.drawArc(
          Rect.fromCircle(center: center, radius: railRadius),
          rotation + glowOffset,
          glowSize,
          false,
          railPaint
            ..shader = SweepGradient(
                tileMode: TileMode.repeated,
                startAngle: rotation + glowOffset,
                endAngle: rotation + glowSize + glowOffset,
                stops: const <double>[
                  0.25,
                  0.25,
                  0.5,
                  0.75,
                  0.75
                ],
                colors: [
                  Colors.transparent,
                  appearance.activeRailColor,
                  color ?? Colors.white,
                  appearance.activeRailColor,
                  Colors.transparent,
                ]).createShader(
                Rect.fromCircle(center: center, radius: railRadius)));
    }
    final double ballRadius = size.shortestSide / 75;
    final double glowRadius = size.shortestSide / 50;
    canvas.drawCircle(
        center.toDistance(rotation, railRadius),
        glowRadius * glowScale,
        Paint()
          ..color = color ?? Colors.white
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 5 * glowScale));
    canvas.drawCircle(center.toDistance(rotation, railRadius), ballRadius,
        Paint()..color = color ?? Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
