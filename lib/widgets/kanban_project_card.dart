import 'package:fl_kanban/providers/kanban_board_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class KanbanProjectCard extends ConsumerStatefulWidget {
  final String projectId;
  final VoidCallback onTap;
  final String title;
  final String description;

  const KanbanProjectCard({
    super.key,
    required this.projectId,
    required this.onTap,
    required this.title,
    required this.description,
  });

  @override
  ConsumerState<KanbanProjectCard> createState() => _KanbanProjectCard();
}

class _KanbanProjectCard extends ConsumerState<KanbanProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: SizedBox(
          width: 360,
          child: Card(
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.6)
                    : Colors.black.withValues(alpha: _hovered ? 0.15 : 0.1),
                blurRadius: _hovered ? 8 : 2,
                offset: const Offset(0, 4),
              ),
            ],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_buildHeader(), Text(widget.description)],
            ).gap(16),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(widget.title).semiBold],
        ),
        const Spacer(),
        Builder(
          builder: (context) {
            return IconButton.ghost(
              onPressed: () => _showProjectMenu(context),
              icon: const Icon(LucideIcons.ellipsis, size: 16),
            );
          },
        ),
      ],
    );
  }

  void _showProjectMenu(BuildContext context) {
    final notifier = ref.read(kanbanProvider.notifier);

    showDropdown(
      context: context,
      builder: (context) {
        return DropdownMenu(
          children: [
            MenuLabel(child: const Text("Actions")),
            MenuDivider(),
            MenuButton(onPressed: (_) {}, child: const Text("Edit")),
            MenuButton(
              onPressed: (_) {
                notifier.deleteProject(widget.projectId);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
