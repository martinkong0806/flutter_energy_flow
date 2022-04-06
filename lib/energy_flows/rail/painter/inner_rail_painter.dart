part of '../inner_rail.dart';

class InnerRailPainter extends CustomPainter {
  final double offsetDistanceRatio;
  final double offsetDirection;
  final double progress;
  final Color? color;
  final double glowScale;
  final bool isActive;
  final EnergyFlowAppearance appearance;

  InnerRailPainter(
      {required this.offsetDistanceRatio,
      required this.offsetDirection,
      required this.progress,
      required this.color,
      required this.glowScale,
      required this.isActive,
      required this.appearance});

  @override
  void paint(Canvas canvas, Size size) {
    final Offset startOffset = size.toOffset() / 2;
    final Offset endOffset = startOffset.toDistance(
        offsetDirection, offsetDistanceRatio * size.shortestSide / 2);
    final Paint railPaint = Paint()
      ..color = isActive ? appearance.activeRailColor : appearance.inactiveRailColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    /// background Rail
    canvas.drawLine(startOffset, endOffset, railPaint);

    /// Highlighted Rail Section, this is the section of the rail, where the
    /// energy blob is around, and it the part of rail glows.

    /// This value show the fraction of the line path that is highlighted
    const double highlightRailProportion = 1 / 5;
    // Find the distance of the highlight rail
    final double highlightRailDistance =
        (startOffset + endOffset).distance * highlightRailProportion;
    // The progress offset is set to move the center highlight rail to the
    // center of the offset
    const double progressOffset = -0.5;
    final Offset highlightedRailStartOffset = startOffset.translate(
        math.cos(offsetDirection) *
            highlightRailDistance *
            (progress + progressOffset),
        math.sin(offsetDirection) *
            highlightRailDistance *
            (progress + progressOffset));

    final Offset highlightedRailEndOffset = endOffset.translate(
        math.cos(offsetDirection) *
            highlightRailDistance *
            (progress + progressOffset),
        math.sin(offsetDirection) *
            highlightRailDistance *
            (progress + progressOffset));
    if (isActive) {
      canvas.drawLine(
          highlightedRailStartOffset,
          highlightedRailEndOffset,
          railPaint
            ..shader = LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
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
                ]).createShader(Rect.fromPoints(
                highlightedRailStartOffset, highlightedRailEndOffset)));

      final double ballRadius = size.shortestSide / 75;
      final double glowRadius = size.shortestSide / 50;

      canvas.drawCircle(
          (highlightedRailStartOffset + highlightedRailEndOffset) / 2,
          glowRadius * glowScale,
          Paint()
            ..color = color ?? Colors.white
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, 5 * glowScale));

      canvas.drawCircle(
          (highlightedRailStartOffset + highlightedRailEndOffset) / 2,
          ballRadius,
          Paint()..color = color ?? Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
