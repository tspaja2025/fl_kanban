import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class KanbanEmptyProjectCard extends ConsumerStatefulWidget {
  final VoidCallback onTap;

  const KanbanEmptyProjectCard({super.key, required this.onTap});

  @override
  ConsumerState<KanbanEmptyProjectCard> createState() =>
      _KanbanEmptyProjectCardState();
}

class _KanbanEmptyProjectCardState
    extends ConsumerState<KanbanEmptyProjectCard> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: SizedBox(
          width: 360,
          height: 125,
          child: Card(
            borderColor: Theme.of(context).colorScheme.border,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [const Text("Create New Project")],
            ).gap(16),
          ),
        ),
      ),
    );
  }
}
