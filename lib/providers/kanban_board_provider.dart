import 'package:fl_kanban/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final kanbanBoardProvider =
    NotifierProvider<KanbanBoardNotifier, List<KanbanBoardData>>(
      KanbanBoardNotifier.new,
    );

class KanbanBoardNotifier extends Notifier<List<KanbanBoardData>> {
  @override
  List<KanbanBoardData> build() {
    return [
      KanbanBoardData(
        id: "1",
        title: "Project Velocity",
        description:
            "System architecture and interface modeling for the Q4 kinetic engine update.",
      ),
    ];
  }
}
