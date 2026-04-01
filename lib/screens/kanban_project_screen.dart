import 'package:fl_kanban/constants/kanban_constants.dart';
import 'package:fl_kanban/models/models.dart';
import 'package:fl_kanban/providers/kanban_board_provider.dart';
import 'package:fl_kanban/widgets/kanban_empty_project_card.dart';
import 'package:fl_kanban/widgets/kanban_project_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:go_router/go_router.dart';

class KanbanProjectScreen extends ConsumerWidget {
  const KanbanProjectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boards = ref.watch(kanbanProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                title: board.title,
                description: board.description,
              ),
            KanbanEmptyProjectCard(
              onTap: () => _showNewProjectDialog(context, ref),
            ),
          ],
        ),
      ],
    );
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
