import 'package:shadcn_flutter/shadcn_flutter.dart';

class KanbanBoardData {
  final String id;
  final String title;
  final String description;

  const KanbanBoardData({
    required this.id,
    required this.title,
    required this.description,
  });
}

class KanbanColumnData {
  final String id;
  final String title;
  final List<SortableData<KanbanTaskData>> tasks;

  KanbanColumnData({
    required this.id,
    required this.title,
    required this.tasks,
  });
}

class KanbanTaskData {
  final String id;
  final String title;
  final String description;
  final String priority;
  final Color color;

  KanbanTaskData({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.color,
  });
}
