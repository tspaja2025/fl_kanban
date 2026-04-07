import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class CardContainer extends ConsumerStatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double width;
  final double height;

  const CardContainer({
    super.key,
    required this.child,
    this.onTap,
    this.width = 360,
    this.height = 220,
  });

  @override
  ConsumerState<CardContainer> createState() => _CardContainerState();
}

class _CardContainerState extends ConsumerState<CardContainer> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.card,
              border: Border.all(color: Theme.of(context).colorScheme.border),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.6)
                      : Colors.black.withValues(alpha: _hovered ? 0.15 : 0.1),
                  blurRadius: _hovered ? 12 : 0,
                  offset: _hovered ? const Offset(0, 6) : const Offset(0, 0),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
