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
              onTap: () => context.pushNamed("createProject"),
            ),
          ],
        ),
      ],
    );
  }
}
