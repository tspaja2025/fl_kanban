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
    final boards = ref.watch(kanbanBoardProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 16,
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
              onTap: () => {
                showDialog(
                  context: context,
                  builder: (context) {
                    final FormController controller = FormController();

                    return AlertDialog(
                      title: const Text("New Project"),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 400),
                            child: Form(
                              controller: controller,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: const [
                                  FormField(
                                    key: FormKey(#title),
                                    label: Text("Title"),
                                    child: TextField(),
                                  ),
                                  FormField(
                                    key: FormKey(#description),
                                    label: Text("Description"),
                                    child: TextArea(maxLines: 3),
                                  ),
                                ],
                              ).gap(16),
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        OutlineButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"),
                        ),
                        OutlineButton(
                          onPressed: () {
                            Navigator.of(context).pop(controller.values);
                          },
                          child: const Text("Save"),
                        ),
                      ],
                    );
                  },
                ),
              },
            ),
          ],
        ),
      ],
    );
  }
}
