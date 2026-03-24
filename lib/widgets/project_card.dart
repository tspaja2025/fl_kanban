import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class ProjectCard extends ConsumerStatefulWidget {
  final VoidCallback onTap;
  final String title;
  final String description;

  const ProjectCard({
    super.key,
    required this.onTap,
    required this.title,
    required this.description,
  });

  @override
  ConsumerState<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends ConsumerState<ProjectCard> {
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          transform: Matrix4.identity()..scale(_hovered ? 1.02 : 1.0),
          width: 360,
          decoration: BoxDecoration(
            color: theme.colorScheme.card,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.6)
                    : Colors.black.withValues(alpha: _hovered ? 0.15 : 0.1),
                blurRadius: _hovered ? 8 : 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(widget.title).semiBold],
                  ),
                  const Spacer(),
                  Builder(
                    builder: (context) {
                      return IconButton.ghost(
                        onPressed: () {
                          showDropdown(
                            context: context,
                            builder: (context) {
                              return const DropdownMenu(
                                children: [
                                  MenuLabel(child: Text("Actions")),
                                  MenuDivider(),
                                  MenuButton(child: Text("Edit")),
                                  MenuButton(child: Text("Delete")),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(LucideIcons.ellipsis, size: 16),
                      );
                    },
                  ),
                ],
              ),

              Text(widget.description).muted.small,
            ],
          ).gap(16),
        ),
      ),
    );
  }
}
