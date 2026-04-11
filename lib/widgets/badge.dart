import 'package:shadcn_flutter/shadcn_flutter.dart';

class Badge extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color foregroundColor;
  final EdgeInsets padding;
  final double borderRadius;
  final double fontSize;

  const Badge({
    super.key,
    required this.text,
    this.backgroundColor = const Color(0xFFE5E7EB),
    this.foregroundColor = const Color(0xFF111827),
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.borderRadius = 6,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryBadge(
      style:
          ButtonStyle.primary(
                size: ButtonSize.small,
                density: ButtonDensity.dense,
                shape: ButtonShape.rectangle,
              )
              .withBackgroundColor(
                color: backgroundColor,
                hoverColor: backgroundColor,
              )
              .withForegroundColor(
                color: foregroundColor,
                hoverColor: foregroundColor,
              ),
      child: Text(text),
    );
  }
}
