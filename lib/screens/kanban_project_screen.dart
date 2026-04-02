import 'package:fl_kanban/constants/kanban_constants.dart';
import 'package:fl_kanban/models/models.dart';
import 'package:fl_kanban/providers/kanban_board_provider.dart';
import 'package:fl_kanban/widgets/kanban_empty_project_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:go_router/go_router.dart';

class KanbanProjectScreen extends ConsumerWidget {
  const KanbanProjectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(kanbanProvider);
    final notifier = ref.read(kanbanProvider.notifier);

    final boards = notifier.searchQuery.isEmpty
        ? projects
        : projects.where((project) {
            final query = notifier.searchQuery.toLowerCase();
            return project.title.toLowerCase().contains(query) ||
                project.description.toLowerCase().contains(query);
          }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 250,
              child: TextField(
                placeholder: const Text("Search projects"),
                onChanged: (value) {
                  ref.read(kanbanProvider.notifier).updateSearchQuery(value);
                },
                features: [
                  // Leading icon only visible when the text is empty
                  InputFeature.leading(
                    StatedWidget.builder(
                      builder: (context, states) {
                        // Use a muted icon normally, switch to the full icon on hover
                        return states.hovered
                            ? const Icon(LucideIcons.search)
                            : const Icon(
                                LucideIcons.search,
                              ).iconMutedForeground;
                      },
                    ),
                    visibility: InputFeatureVisibility.textEmpty,
                  ),
                  // Clear button visible when there is text and the field is focused,
                  // or whenever the field is hovered
                  InputFeature.clear(
                    visibility:
                        (InputFeatureVisibility.textNotEmpty &
                            InputFeatureVisibility.focused) |
                        InputFeatureVisibility.hovered,
                  ),
                ],
              ),
            ),
          ],
        ),
        Wrap(
          spacing: KanbanConstants.gapSize,
          runSpacing: KanbanConstants.gapSize,
          children: [
            for (final board in boards)
              KanbanProjectCard(
                onTap: () => context.pushNamed(
                  "kanbanProjectDetail",
                  pathParameters: {"id": board.id},
                ),
                projectId: board.id,
                title: board.title,
                description: board.description,
              ),
            KanbanEmptyProjectCard(
              onTap: () => _showNewProjectDialog(context, ref),
            ),
          ],
        ),
      ],
    ).gap(16);
  }

  void _showNewProjectDialog(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("New Project"),
          content: NewProjectForm(
            formKey: formKey,
            titleController: titleController,
            descriptionController: descriptionController,
          ),
          actions: [
            OutlineButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            PrimaryButton(
              onPressed: () {
                final newProject = KanbanData(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text,
                  description: descriptionController.text,
                  columns: [],
                );

                ref.read(kanbanProvider.notifier).addProject(newProject);
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}

class NewProjectForm extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  const NewProjectForm({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.descriptionController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FormField(
              key: const FormKey(#title),
              label: const Text("Title"),
              child: TextField(controller: titleController),
            ),
            const Gap(KanbanConstants.gapSize),
            FormField(
              key: const FormKey(#description),
              label: const Text("Description"),
              child: TextArea(controller: descriptionController, maxLines: 3),
            ),
          ],
        ),
      ),
    );
  }
}

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
