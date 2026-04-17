import 'package:shadcn_flutter/shadcn_flutter.dart';

class KanbanData {
  final String id;
  final String title;
  final String description;
  final ProjectStatus status;
  final Color backgroundColor;
  final Color foregroundColor;
  final String? dueDate;
  final List<TeamMember> teamMembers;
  final List<SortableData<KanbanColumnData>> columns;

  const KanbanData({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    this.backgroundColor = const Color(0xFFE0F2FE),
    this.foregroundColor = const Color(0xFF075985),
    this.dueDate,
    this.teamMembers = const [],
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
    List<TeamMember>? teamMembers,
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
      teamMembers: teamMembers ?? this.teamMembers,
      columns: columns ?? this.columns,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "status": status.index,
      "backgroundColor": backgroundColor.toARGB32(),
      "foregroundColor": foregroundColor.toARGB32(),
      "dueDate": dueDate,
      "teamMembers": teamMembers.map((member) => member.toJson()).toList(),
      "columns": columns.map((col) => col.data.toJson()).toList(),
    };
  }

  static KanbanData fromJson(Map<String, dynamic> json) {
    return KanbanData(
      id: json["id"] as String,
      title: json["title"] as String,
      description: json["description"] as String,
      status: ProjectStatus.values[json["status"] as int],
      backgroundColor: Color(json["backgroundColor"] as int),
      foregroundColor: Color(json["foregroundColor"] as int),
      dueDate: json["dueDate"] as String,
      teamMembers: (json["teamMembers"] as List)
          .map(
            (memberJson) =>
                TeamMember.fromJson(memberJson as Map<String, dynamic>),
          )
          .toList(),
      columns: (json["columns"] as List)
          .map((colJson) => SortableData(KanbanColumnData.fromJson(colJson)))
          .toList(),
    );
  }

  bool hasTeamMember(String memberId) {
    return teamMembers.any((member) => member.id == memberId);
  }

  int get teamMemberCount => teamMembers.length;

  // String getFormattedDueDate() {
  //   if (dueDate == null) return "No due date";

  //   final now = DateTime.now();
  //   final difference = dueDate.difference(now).inDays;

  //   if (difference < 0) {
  //     final daysLate = -difference;
  //     return "$daysLate day${daysLate == 1 ? '' : 's'} late";
  //   } else if (difference == 0) {
  //     return "Due today";
  //   } else if (difference == 1) {
  //     return "Due tomorrow";
  //   } else {
  //     return "$difference days left";
  //   }
  // }
}

class TeamMember {
  final String id;
  final String name;
  final String email;
  final Color avatarColor;

  const TeamMember({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarColor,
  });

  String get initials {
    final parts = name.split(" ");
    if (parts.length >= 2) {
      return "${parts[0][0]}${parts[1][0]}".toUpperCase();
    }
    return name.substring(0, 2).toUpperCase();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarColor': avatarColor.toARGB32(),
    };
  }

  static TeamMember fromJson(Map<String, dynamic> json) {
    return TeamMember(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarColor: Color(json['avatarColor'] as int),
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

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "tasks": tasks.map((task) => task.data.toJson()).toList(),
    };
  }

  static KanbanColumnData fromJson(Map<String, dynamic> json) {
    return KanbanColumnData(
      id: json['id'] as String,
      title: json['title'] as String,
      tasks: (json['tasks'] as List)
          .map((taskJson) => SortableData(KanbanTaskData.fromJson(taskJson)))
          .toList(),
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority.index,
      'color': color?.toARGB32(),
      'dueDate': dueDate?.toIso8601String(),
    };
  }

  static KanbanTaskData fromJson(Map<String, dynamic> json) {
    return KanbanTaskData(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      priority: TaskPriority.values[json['priority'] as int],
      color: json['color'] != null ? Color(json['color'] as int) : null,
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
    );
  }
}

enum TaskPriority {
  high,
  medium,
  low;

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
        return const Color(0xFFFCA5A5);
      case TaskPriority.medium:
        return const Color(0xFFFCD34D);
      case TaskPriority.low:
        return const Color(0xFF86EFAC);
    }
  }

  String toJson() => name;

  static TaskPriority fromJson(String json) {
    return values.firstWhere((e) => e.name == json, orElse: () => medium);
  }
}

enum ProjectStatus {
  delayed,
  inProgress,
  completed;

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

  String toJson() => name;

  static ProjectStatus fromJson(String json) {
    return values.firstWhere((e) => e.name == json, orElse: () => inProgress);
  }
}
