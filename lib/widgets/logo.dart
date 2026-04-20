import 'package:shadcn_flutter/shadcn_flutter.dart';

class Logo extends StatelessWidget {
  final double width;
  final double height;
  final double size;

  const Logo({super.key, this.width = 52, this.height = 52, this.size = 28});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          LucideIcons.squareDashedKanban,
          size: size,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
