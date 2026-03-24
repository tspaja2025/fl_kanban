import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class ColumnData {
  final String title;
  final List<SortableData<TaskData>> tasks;

  ColumnData({required this.title, required this.tasks});
}

class TaskData {
  final String title;
  final String description;
  final List<Widget> tags;
  final String priority;
  final Color priorityColor;

  TaskData({
    required this.title,
    required this.description,
    required this.tags,
    required this.priority,
    required this.priorityColor,
  });
}

final kanbanProvider =
    NotifierProvider<KanbanNotifier, List<SortableData<ColumnData>>>(
      KanbanNotifier.new,
    );

class KanbanNotifier extends Notifier<List<SortableData<ColumnData>>> {
  @override
  List<SortableData<ColumnData>> build() {
    return [
      SortableData(
        ColumnData(
          title: "To Do",
          tasks: [
            SortableData(
              TaskData(
                title: "Competitor Spatial Analysis",
                description:
                    "Benchmarking the ease of movement in competing architect platforms.",
                tags: [const PrimaryBadge(child: Text("Research"))],
                priority: "High",
                priorityColor: Colors.red,
              ),
            ),
            SortableData(
              TaskData(
                title: "V3 Iconography Pack",
                description:
                    "Exporting all stroke-based icons for the new shadcn library.",
                tags: [const PrimaryBadge(child: Text("Asset"))],
                priority: "Medium",
                priorityColor: Colors.orange,
              ),
            ),
          ],
        ),
      ),
      SortableData(
        ColumnData(
          title: "In Progress",
          tasks: [
            SortableData(
              TaskData(
                title: "Kinetic Physics Engine",
                description:
                    "Refining the spring animations for the dashboard cards transitions.",
                tags: [const PrimaryBadge(child: Text("Engineering"))],
                priority: "Low",
                priorityColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
      SortableData(
        ColumnData(
          title: "Review",
          tasks: [
            SortableData(
              TaskData(
                title: "Auth Flow Refactor",
                description:
                    "Security audit and 2FA implementation for enterprise users.",
                tags: [const PrimaryBadge(child: Text("Security"))],
                priority: "High",
                priorityColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    ];
  }

  void moveTask(
    SortableData<TaskData> task,
    List<SortableData<TaskData>> targetList,
    int index,
  ) {
    final newState = [...state];

    // Find and remove from source column
    SortableData<ColumnData>? sourceColumn;
    for (var col in newState) {
      if (col.data.tasks.contains(task)) {
        sourceColumn = col;

        break;
      }
    }

    if (sourceColumn != null) {
      sourceColumn.data.tasks.remove(task);
    }

    final safeIndex = index.clamp(0, targetList.length);
    targetList.insert(safeIndex, task);

    state = newState;
  }

  void addTask() {
    // TODO:
  }

  void updateTask() {
    // TODO:
  }

  void deleteTask() {
    // TODO:
  }
}

class ProjectBoardData {
  final String id;
  final String title;
  final String description;
  final List<SortableData<ProjectColumnData>> columns;

  ProjectBoardData({
    required this.id,
    required this.title,
    required this.description,
    required this.columns,
  });
}

class ProjectColumnData {
  final String title;
  final List<SortableData<ProjectTaskData>> tasks;

  ProjectColumnData({required this.title, required this.tasks});
}

class ProjectTaskData {
  final String title;
  final String description;
  final List<Widget> tags;
  final String priority;
  final Color priorityColor;

  ProjectTaskData({
    required this.title,
    required this.description,
    required this.tags,
    required this.priority,
    required this.priorityColor,
  });
}

final projectBoardProvider =
    NotifierProvider<
      ProjectBoardNotifier,
      List<SortableData<ProjectBoardData>>
    >(ProjectBoardNotifier.new);

class ProjectBoardNotifier
    extends Notifier<List<SortableData<ProjectBoardData>>> {
  @override
  List<SortableData<ProjectBoardData>> build() {
    return [
      SortableData(
        ProjectBoardData(
          id: "1",
          title: "Project Velocity",
          description:
              "System architecture and interface modeling for the Q4 kinetic engine update.",
          columns: [
            SortableData(
              ProjectColumnData(
                title: "To Do",
                tasks: [
                  SortableData(
                    ProjectTaskData(
                      title: "Competitor Spatial Analysis",
                      description:
                          "Benchmarking the ease of movement in competing architect platforms.",
                      tags: [const PrimaryBadge(child: Text("Research"))],
                      priority: "High",
                      priorityColor: Colors.red,
                    ),
                  ),
                  SortableData(
                    ProjectTaskData(
                      title: "V3 Iconography Pack",
                      description:
                          "Exporting all stroke-based icons for the new shadcn library.",
                      tags: [const PrimaryBadge(child: Text("Asset"))],
                      priority: "Medium",
                      priorityColor: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
            SortableData(
              ProjectColumnData(
                title: "In Progress",
                tasks: [
                  SortableData(
                    ProjectTaskData(
                      title: "Kinetic Physics Engine",
                      description:
                          "Refining the spring animations for the dashboard cards transitions.",
                      tags: [const PrimaryBadge(child: Text("Engineering"))],
                      priority: "Low",
                      priorityColor: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            SortableData(
              ProjectColumnData(
                title: "Review",
                tasks: [
                  SortableData(
                    ProjectTaskData(
                      title: "Auth Flow Refactor",
                      description:
                          "Security audit and 2FA implementation for enterprise users.",
                      tags: [const PrimaryBadge(child: Text("Security"))],
                      priority: "High",
                      priorityColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      SortableData(
        ProjectBoardData(
          id: "2",
          title: "Project Velocity 2",
          description:
              "System architecture and interface modeling for the Q4 kinetic engine update.",
          columns: [
            SortableData(
              ProjectColumnData(
                title: "To Do",
                tasks: [
                  SortableData(
                    ProjectTaskData(
                      title: "Competitor Spatial Analysis",
                      description:
                          "Benchmarking the ease of movement in competing architect platforms.",
                      tags: [const PrimaryBadge(child: Text("Research"))],
                      priority: "High",
                      priorityColor: Colors.red,
                    ),
                  ),
                  SortableData(
                    ProjectTaskData(
                      title: "V3 Iconography Pack",
                      description:
                          "Exporting all stroke-based icons for the new shadcn library.",
                      tags: [const PrimaryBadge(child: Text("Asset"))],
                      priority: "Medium",
                      priorityColor: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
            SortableData(
              ProjectColumnData(
                title: "In Progress",
                tasks: [
                  SortableData(
                    ProjectTaskData(
                      title: "Kinetic Physics Engine",
                      description:
                          "Refining the spring animations for the dashboard cards transitions.",
                      tags: [const PrimaryBadge(child: Text("Engineering"))],
                      priority: "Low",
                      priorityColor: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            SortableData(
              ProjectColumnData(
                title: "Review",
                tasks: [
                  SortableData(
                    ProjectTaskData(
                      title: "Auth Flow Refactor",
                      description:
                          "Security audit and 2FA implementation for enterprise users.",
                      tags: [const PrimaryBadge(child: Text("Security"))],
                      priority: "High",
                      priorityColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ];
  }

  // Project actions
  void addProject() {}

  void editProject() {}

  void deleteProject() {}

  // Task actions
  void moveTask() {}

  void addTask() {}

  void editTask() {}

  void deleteTask() {}

  // Column actions
  void addColumn() {}

  void editColumn() {}

  void deleteColumn() {}

  // void moveTask(
  //   SortableData<ProjectTaskData> task,
  //   List<SortableData<ProjectTaskData>> targetList,
  //   int index,
  // ) {
  //   final newState = [...state];

  //   // Find and remove from source column
  //   SortableData<ProjectColumnData>? sourceColumn;
  //   for (var col in newState) {
  //     if (col.data.tasks.contains(task)) {
  //       sourceColumn = col;

  //       break;
  //     }
  //   }

  //   if (sourceColumn != null) {
  //     sourceColumn.data.tasks.remove(task);
  //   }

  //   final safeIndex = index.clamp(0, targetList.length);
  //   targetList.insert(safeIndex, task);

  //   state = newState;
  // }

  // void addTask() {
  //   // TODO:
  // }

  // void updateTask() {
  //   // TODO:
  // }

  // void deleteTask() {
  //   // TODO:
  // }
}
