import 'package:shadcn_flutter/shadcn_flutter.dart';

class KanbanData {
  final String id;
  final String title;
  final String description;
  final ProjectStatus status;
  final Color backgroundColor;
  final Color foregroundColor;
  final String dueDate;
  final List<SortableData<KanbanColumnData>> columns;

  const KanbanData({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    this.backgroundColor = const Color(0xFFE0F2FE),
    this.foregroundColor = const Color(0xFF075985),
    required this.dueDate,
    required this.columns,
  });

  KanbanData copyWith({
    String? id,
    String? title,
    String? description,
    ProjectStatus? status,
    Color? backgroundColor,
    Color? foregroundColor,
    String? dueDate,
    List<SortableData<KanbanColumnData>>? columns,
  }) {
    return KanbanData(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      dueDate: dueDate ?? this.dueDate,
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
  final Color? color;
  final DateTime? dueDate;

  KanbanTaskData({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    this.color,
    this.dueDate,
  });

  KanbanTaskData copyWith({
    String? id,
    String? title,
    String? description,
    TaskPriority? priority,
    Color? color,
    DateTime? dueDate,
  }) {
    return KanbanTaskData(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      color: color ?? this.color,
      dueDate: dueDate ?? this.dueDate,
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

enum ProjectStatus { delayed, inProgress, completed }

extension ProjectStatusExtension on ProjectStatus {
  String get displayName {
    switch (this) {
      case ProjectStatus.delayed:
        return "Delayed";
      case ProjectStatus.inProgress:
        return "In Progress";
      case ProjectStatus.completed:
        return "Completed";
    }
  }
}
