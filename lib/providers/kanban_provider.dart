import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

// class ColumnData {
//   final String title;
//   final List<SortableData<TaskData>> tasks;

//   ColumnData({required this.title, required this.tasks});
// }

// class TaskData {
//   final String title;
//   final String description;
//   final List<Widget> tags;
//   final String priority;
//   final Color priorityColor;

//   TaskData({
//     required this.title,
//     required this.description,
//     required this.tags,
//     required this.priority,
//     required this.priorityColor,
//   });
// }

// final kanbanProvider =
//     NotifierProvider<KanbanNotifier, List<SortableData<ColumnData>>>(
//       KanbanNotifier.new,
//     );

// class KanbanNotifier extends Notifier<List<SortableData<ColumnData>>> {
//   @override
//   List<SortableData<ColumnData>> build() {
//     return [
//       SortableData(
//         ColumnData(
//           title: "To Do",
//           tasks: [
//             SortableData(
//               TaskData(
//                 title: "Competitor Spatial Analysis",
//                 description:
//                     "Benchmarking the ease of movement in competing architect platforms.",
//                 tags: [const PrimaryBadge(child: Text("Research"))],
//                 priority: "High",
//                 priorityColor: Colors.red,
//               ),
//             ),
//             SortableData(
//               TaskData(
//                 title: "V3 Iconography Pack",
//                 description:
//                     "Exporting all stroke-based icons for the new shadcn library.",
//                 tags: [const PrimaryBadge(child: Text("Asset"))],
//                 priority: "Medium",
//                 priorityColor: Colors.orange,
//               ),
//             ),
//           ],
//         ),
//       ),
//       SortableData(
//         ColumnData(
//           title: "In Progress",
//           tasks: [
//             SortableData(
//               TaskData(
//                 title: "Kinetic Physics Engine",
//                 description:
//                     "Refining the spring animations for the dashboard cards transitions.",
//                 tags: [const PrimaryBadge(child: Text("Engineering"))],
//                 priority: "Low",
//                 priorityColor: Colors.green,
//               ),
//             ),
//           ],
//         ),
//       ),
//       SortableData(
//         ColumnData(
//           title: "Review",
//           tasks: [
//             SortableData(
//               TaskData(
//                 title: "Auth Flow Refactor",
//                 description:
//                     "Security audit and 2FA implementation for enterprise users.",
//                 tags: [const PrimaryBadge(child: Text("Security"))],
//                 priority: "High",
//                 priorityColor: Colors.red,
//               ),
//             ),
//           ],
//         ),
//       ),
//     ];
//   }

//   void moveTask(
//     SortableData<TaskData> task,
//     List<SortableData<TaskData>> targetList,
//     int index,
//   ) {
//     final newState = [...state];

//     // Find and remove from source column
//     SortableData<ColumnData>? sourceColumn;
//     for (var col in newState) {
//       if (col.data.tasks.contains(task)) {
//         sourceColumn = col;

//         break;
//       }
//     }

//     if (sourceColumn != null) {
//       sourceColumn.data.tasks.remove(task);
//     }

//     final safeIndex = index.clamp(0, targetList.length);
//     targetList.insert(safeIndex, task);

//     state = newState;
//   }

//   void addTask() {
//     // TODO:
//   }

//   void updateTask() {
//     // TODO:
//   }

//   void deleteTask() {
//     // TODO:
//   }
// }

// class ProjectBoardData {
//   final String id;
//   final String title;
//   final String description;
//   final List<SortableData<ProjectColumnData>> columns;

//   ProjectBoardData({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.columns,
//   });
// }

// class ProjectColumnData {
//   final String title;
//   final List<SortableData<ProjectTaskData>> tasks;

//   ProjectColumnData({required this.title, required this.tasks});
// }

// class ProjectTaskData {
//   final String title;
//   final String description;
//   final List<Widget> tags;
//   final String priority;
//   final Color priorityColor;

//   ProjectTaskData({
//     required this.title,
//     required this.description,
//     required this.tags,
//     required this.priority,
//     required this.priorityColor,
//   });
// }

// final projectBoardProvider =
//     NotifierProvider<
//       ProjectBoardNotifier,
//       List<SortableData<ProjectBoardData>>
//     >(ProjectBoardNotifier.new);

// class ProjectBoardNotifier
//     extends Notifier<List<SortableData<ProjectBoardData>>> {
//   @override
//   List<SortableData<ProjectBoardData>> build() {
//     return [
//       SortableData(
//         ProjectBoardData(
//           id: "1",
//           title: "Project Velocity",
//           description:
//               "System architecture and interface modeling for the Q4 kinetic engine update.",
//           columns: [
//             SortableData(
//               ProjectColumnData(
//                 title: "To Do",
//                 tasks: [
//                   SortableData(
//                     ProjectTaskData(
//                       title: "Competitor Spatial Analysis",
//                       description:
//                           "Benchmarking the ease of movement in competing architect platforms.",
//                       tags: [const PrimaryBadge(child: Text("Research"))],
//                       priority: "High",
//                       priorityColor: Colors.red,
//                     ),
//                   ),
//                   SortableData(
//                     ProjectTaskData(
//                       title: "V3 Iconography Pack",
//                       description:
//                           "Exporting all stroke-based icons for the new shadcn library.",
//                       tags: [const PrimaryBadge(child: Text("Asset"))],
//                       priority: "Medium",
//                       priorityColor: Colors.orange,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SortableData(
//               ProjectColumnData(
//                 title: "In Progress",
//                 tasks: [
//                   SortableData(
//                     ProjectTaskData(
//                       title: "Kinetic Physics Engine",
//                       description:
//                           "Refining the spring animations for the dashboard cards transitions.",
//                       tags: [const PrimaryBadge(child: Text("Engineering"))],
//                       priority: "Low",
//                       priorityColor: Colors.green,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SortableData(
//               ProjectColumnData(
//                 title: "Review",
//                 tasks: [
//                   SortableData(
//                     ProjectTaskData(
//                       title: "Auth Flow Refactor",
//                       description:
//                           "Security audit and 2FA implementation for enterprise users.",
//                       tags: [const PrimaryBadge(child: Text("Security"))],
//                       priority: "High",
//                       priorityColor: Colors.red,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       SortableData(
//         ProjectBoardData(
//           id: "2",
//           title: "Project Velocity 2",
//           description:
//               "System architecture and interface modeling for the Q4 kinetic engine update.",
//           columns: [
//             SortableData(
//               ProjectColumnData(
//                 title: "To Do",
//                 tasks: [
//                   SortableData(
//                     ProjectTaskData(
//                       title: "Competitor Spatial Analysis",
//                       description:
//                           "Benchmarking the ease of movement in competing architect platforms.",
//                       tags: [const PrimaryBadge(child: Text("Research"))],
//                       priority: "High",
//                       priorityColor: Colors.red,
//                     ),
//                   ),
//                   SortableData(
//                     ProjectTaskData(
//                       title: "V3 Iconography Pack",
//                       description:
//                           "Exporting all stroke-based icons for the new shadcn library.",
//                       tags: [const PrimaryBadge(child: Text("Asset"))],
//                       priority: "Medium",
//                       priorityColor: Colors.orange,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SortableData(
//               ProjectColumnData(
//                 title: "In Progress",
//                 tasks: [
//                   SortableData(
//                     ProjectTaskData(
//                       title: "Kinetic Physics Engine",
//                       description:
//                           "Refining the spring animations for the dashboard cards transitions.",
//                       tags: [const PrimaryBadge(child: Text("Engineering"))],
//                       priority: "Low",
//                       priorityColor: Colors.green,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SortableData(
//               ProjectColumnData(
//                 title: "Review",
//                 tasks: [
//                   SortableData(
//                     ProjectTaskData(
//                       title: "Auth Flow Refactor",
//                       description:
//                           "Security audit and 2FA implementation for enterprise users.",
//                       tags: [const PrimaryBadge(child: Text("Security"))],
//                       priority: "High",
//                       priorityColor: Colors.red,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     ];
//   }

//   // Project actions
//   void addProject() {}

//   void editProject() {}

//   void deleteProject() {}

//   // Task actions
//   void moveTask() {}

//   void addTask() {}

//   void editTask() {}

//   void deleteTask() {}

//   // Column actions
//   void addColumn() {}

//   void editColumn() {}

//   void deleteColumn() {}

//   // void moveTask(
//   //   SortableData<ProjectTaskData> task,
//   //   List<SortableData<ProjectTaskData>> targetList,
//   //   int index,
//   // ) {
//   //   final newState = [...state];

//   //   // Find and remove from source column
//   //   SortableData<ProjectColumnData>? sourceColumn;
//   //   for (var col in newState) {
//   //     if (col.data.tasks.contains(task)) {
//   //       sourceColumn = col;

//   //       break;
//   //     }
//   //   }

//   //   if (sourceColumn != null) {
//   //     sourceColumn.data.tasks.remove(task);
//   //   }

//   //   final safeIndex = index.clamp(0, targetList.length);
//   //   targetList.insert(safeIndex, task);

//   //   state = newState;
//   // }

//   // void addTask() {
//   //   // TODO:
//   // }

//   // void updateTask() {
//   //   // TODO:
//   // }

//   // void deleteTask() {
//   //   // TODO:
//   // }
// }

// New
class Project {
  final String id;
  final String title;
  final String description;
  final List<ColumnData> columns;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> tags;
  final List<TeamMember> teamMembers;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.columns,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.tags = const [],
    this.teamMembers = const [],
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Project copyWith({
    String? id,
    String? title,
    String? description,
    List<ColumnData>? columns,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? tags,
    List<TeamMember>? teamMembers,
  }) {
    return Project(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      columns: columns ?? this.columns,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      tags: tags ?? this.tags,
      teamMembers: teamMembers ?? this.teamMembers,
    );
  }
}

class ColumnData {
  final String id;
  final String title;
  final List<TaskData> tasks;

  ColumnData({String? id, required this.title, required this.tasks})
    : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  ColumnData copyWith({String? id, String? title, List<TaskData>? tasks}) {
    return ColumnData(
      id: id ?? this.id,
      title: title ?? this.title,
      tasks: tasks ?? this.tasks,
    );
  }
}

class TaskData {
  final String id;
  final String title;
  final String description;
  final List<Tag> tags;
  final Priority priority;
  final DateTime? dueDate;
  final List<String> assignees;
  final DateTime createdAt;
  final DateTime updatedAt;

  TaskData({
    String? id,
    required this.title,
    required this.description,
    required this.tags,
    required this.priority,
    this.dueDate,
    this.assignees = const [],
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  TaskData copyWith({
    String? id,
    String? title,
    String? description,
    List<Tag>? tags,
    Priority? priority,
    DateTime? dueDate,
    List<String>? assignees,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskData(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      assignees: assignees ?? this.assignees,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class Tag {
  final String id;
  final String name;
  final Color color;

  const Tag({required this.id, required this.name, this.color = Colors.gray});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tag && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

enum Priority {
  low(Colors.green, "Low"),
  medium(Colors.orange, "Medium"),
  high(Colors.red, "High"),
  urgent(Colors.purple, "Urgent");

  final Color color;
  final String label;

  const Priority(this.color, this.label);
}

class TeamMember {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;

  TeamMember({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
  });
}

final projectsProvider = NotifierProvider<ProjectsNotifier, List<Project>>(
  ProjectsNotifier.new,
);

class ProjectsNotifier extends Notifier<List<Project>> {
  @override
  List<Project> build() {
    return _getDefaultProjects();
  }

  List<Project> _getDefaultProjects() {
    return [
      Project(
        id: 'project_1',
        title: 'Project Velocity',
        description:
            'System architecture and interface modeling for the Q4 kinetic engine update.',
        columns: [
          ColumnData(
            title: 'To Do',
            tasks: [
              TaskData(
                title: 'Competitor Spatial Analysis',
                description:
                    'Benchmarking the ease of movement in competing architect platforms.',
                tags: [
                  const Tag(
                    id: 'research',
                    name: 'Research',
                    color: Colors.blue,
                  ),
                ],
                priority: Priority.high,
              ),
              TaskData(
                title: 'V3 Iconography Pack',
                description:
                    'Exporting all stroke-based icons for the new shadcn library.',
                tags: [
                  const Tag(id: 'asset', name: 'Asset', color: Colors.green),
                ],
                priority: Priority.medium,
                dueDate: DateTime.now().add(const Duration(days: 3)),
              ),
            ],
          ),
          ColumnData(
            title: 'In Progress',
            tasks: [
              TaskData(
                title: 'Kinetic Physics Engine',
                description:
                    'Refining the spring animations for the dashboard cards transitions.',
                tags: [
                  const Tag(
                    id: 'engineering',
                    name: 'Engineering',
                    color: Colors.orange,
                  ),
                ],
                priority: Priority.low,
                assignees: ['user_1'],
              ),
            ],
          ),
          ColumnData(
            title: 'Review',
            tasks: [
              TaskData(
                title: 'Auth Flow Refactor',
                description:
                    'Security audit and 2FA implementation for enterprise users.',
                tags: [
                  const Tag(
                    id: 'security',
                    name: 'Security',
                    color: Colors.red,
                  ),
                ],
                priority: Priority.high,
                dueDate: DateTime.now().add(const Duration(days: 1)),
                assignees: ['user_1', 'user_2'],
              ),
            ],
          ),
        ],
        tags: ['velocity', 'q4', 'kinetic'],
        teamMembers: [
          TeamMember(id: 'user_1', name: 'John Doe', email: 'john@example.com'),
          TeamMember(
            id: 'user_2',
            name: 'Jane Smith',
            email: 'jane@example.com',
          ),
        ],
      ),
    ];
  }

  // Crud Operations
  void addProject(Project project) {}

  void updateProject(String projectId, Project updatedProject) {}

  void deleteProject(String projectId) {}

  Project? getProject(String projectId) {}

  // Column operations for a specific project
  void addColumn(String projectid, ColumnData column) {}

  void updateColumn(
    String projectId,
    int columnIndex,
    ColumnData updatedColumn,
  ) {}

  void deleteColumn(String projectId, int columnIndex) {}

  // Task operations for a specific project and column
  void addTask(String projectId, int columnIndex, TaskData task) {}

  void moveTask(
    String projectId,
    TaskData task,
    int sourceColumnIndex,
    int targetColumnIndex,
    int targetPosition,
  ) {}

  void updateTask(
    String projectId,
    int columnIndex,
    int taskIndex,
    TaskData updatedTask,
  ) {}

  void deleteTask(String projectId, int columnIndex, int taskIndex) {}
}

// Provider for a single project (derived state)
final projectProvider = Provider.family<Project?, String>((ref, projectId) {
  final projects = ref.watch(projectsProvider);
  return projects.firstWhere((p) => p.id == projectId, orElse: () => null);
}); // Try catch fix?

// Provider for project columns
final projectColumnsProvider = Provider.family<List<ColumnData>, String>((
  ref,
  projectId,
) {
  final project = ref.watch(projectProvider(projectId));
  return project?.columns ?? [];
});
