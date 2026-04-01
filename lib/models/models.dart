import 'package:shadcn_flutter/shadcn_flutter.dart';

class KanbanData {
  final String id;
  final String title;
  final String description;
  final List<SortableData<KanbanColumnData>> columns;

  const KanbanData({
    required this.id,
    required this.title,
    required this.description,
    required this.columns,
  });

  KanbanData copyWith({
    String? id,
    String? title,
    String? description,
    List<SortableData<KanbanColumnData>>? columns,
  }) {
    return KanbanData(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      columns: columns ?? this.columns,
    );
  }
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

  KanbanColumnData copyWith({
    String? id,
    String? title,
    List<SortableData<KanbanTaskData>>? tasks,
  }) {
    return KanbanColumnData(
      id: id ?? this.id,
      title: title ?? this.title,
      tasks: tasks ?? this.tasks,
    );
  }
}

class KanbanTaskData {
  final String id;
  final String title;
  final String description;
  final TaskPriority priority;
  final Color? color; // Optional color override

  KanbanTaskData({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    this.color,
  });

  KanbanTaskData copyWith({
    String? id,
    String? title,
    String? description,
    TaskPriority? priority,
    Color? color,
  }) {
    return KanbanTaskData(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      color: color ?? this.color,
    );
  }

  Color get effectiveColor => color ?? priority.color;
}

enum TaskPriority { high, medium, low }

extension TaskPriorityExtension on TaskPriority {
  String get displayName {
    switch (this) {
      case TaskPriority.high:
        return "High";
      case TaskPriority.medium:
        return "Medium";
      case TaskPriority.low:
        return "Low";
    }
  }

  Color get color {
    switch (this) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
        return Colors.green;
    }
  }
}
