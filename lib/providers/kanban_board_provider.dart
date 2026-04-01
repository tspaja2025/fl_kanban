import 'package:fl_kanban/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

final kanbanProvider = NotifierProvider<KanbanNotifier, List<KanbanData>>(
  KanbanNotifier.new,
);

class KanbanNotifier extends Notifier<List<KanbanData>> {
  @override
  List<KanbanData> build() {
    return [
      KanbanData(
        id: "1",
        title: "Project Velocity",
        description:
            "System architecture and interface modeling for the Q4 kinetic engine update.",
        columns: [
          SortableData(
            KanbanColumnData(
              id: "1",
              title: "To Do",
              tasks: [
                SortableData(
                  KanbanTaskData(
                    id: "1",
                    title: "Competitor Spatial Analysis",
                    description:
                        "Benchmarking the ease of movement in competing architect platforms.",
                    priority: TaskPriority.high,
                    color: Colors.red,
                  ),
                ),
                SortableData(
                  KanbanTaskData(
                    id: "2",
                    title: "V3 Iconography Pack",
                    description:
                        "Exporting all stroke-based icons for the new shadcn library.",
                    priority: TaskPriority.medium,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
          SortableData(
            KanbanColumnData(
              id: "2",
              title: "In Progress",
              tasks: [
                SortableData(
                  KanbanTaskData(
                    id: "3",
                    title: "Kinetic Physics Engine",
                    description:
                        "Refining the spring animations for the dashboard cards transitions.",
                    priority: TaskPriority.low,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          SortableData(
            KanbanColumnData(
              id: "3",
              title: "Review",
              tasks: [
                SortableData(
                  KanbanTaskData(
                    id: "4",
                    title: "Auth Flow Refactor",
                    description:
                        "Security audit and 2FA implementation for enterprise users.",
                    priority: TaskPriority.high,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ];
  }

  void moveTask(
    SortableData<KanbanTaskData> task,
    int targetColumnIndex,
    int targetTaskIndex,
  ) {
    final projects = [...state];
    // Assuming we're working with the first project for now
    // You might want to pass projectId as a parameter
    if (projects.isEmpty) return;

    final columns = List<SortableData<KanbanColumnData>>.from(
      projects[0].columns,
    );

    SortableData<KanbanTaskData>? removedTask;
    int sourceColumnIndex = -1;

    // Find and remove the task
    for (int i = 0; i < columns.length; i++) {
      final taskIndex = columns[i].data.tasks.indexWhere((t) => t == task);
      if (taskIndex != -1) {
        removedTask = columns[i].data.tasks.removeAt(taskIndex);
        sourceColumnIndex = i;
        break;
      }
    }

    if (removedTask == null) return;

    // Insert at new position
    final targetColumn = columns[targetColumnIndex];
    if (targetTaskIndex >= targetColumn.data.tasks.length) {
      targetColumn.data.tasks.add(removedTask);
    } else {
      targetColumn.data.tasks.insert(targetTaskIndex, removedTask);
    }

    // Update state
    state = [projects[0].copyWith(columns: columns), ...projects.skip(1)];
  }

  void addTask(String projectId, String columnId, KanbanTaskData task) {
    final projects = [...state];
    final projectIndex = projects.indexWhere((p) => p.id == projectId);

    if (projectIndex == -1) return;

    final columns = List<SortableData<KanbanColumnData>>.from(
      projects[projectIndex].columns,
    );
    final columnIndex = columns.indexWhere((c) => c.data.id == columnId);

    if (columnIndex != -1) {
      // Wrap the new task in SortableData
      columns[columnIndex].data.tasks.add(SortableData(task));
      state = [
        ...projects.take(projectIndex),
        projects[projectIndex].copyWith(columns: columns),
        ...projects.skip(projectIndex + 1),
      ];
    }
  }

  void editTask(
    String projectId,
    String columnId,
    String taskId,
    KanbanTaskData updatedTask,
  ) {
    final projects = [...state];
    final projectIndex = projects.indexWhere((p) => p.id == projectId);

    if (projectIndex == -1) return;

    final columns = List<SortableData<KanbanColumnData>>.from(
      projects[projectIndex].columns,
    );
    final columnIndex = columns.indexWhere((c) => c.data.id == columnId);

    if (columnIndex != -1) {
      final taskIndex = columns[columnIndex].data.tasks.indexWhere(
        (t) => t.data.id == taskId,
      );
      if (taskIndex != -1) {
        columns[columnIndex].data.tasks[taskIndex] = SortableData(updatedTask);
        state = [
          ...projects.take(projectIndex),
          projects[projectIndex].copyWith(columns: columns),
          ...projects.skip(projectIndex + 1),
        ];
      }
    }
  }

  void deleteTask(String projectId, String columnId, String taskId) {
    final projects = [...state];
    final projectIndex = projects.indexWhere((p) => p.id == projectId);

    if (projectIndex == -1) return;

    final columns = List<SortableData<KanbanColumnData>>.from(
      projects[projectIndex].columns,
    );
    final columnIndex = columns.indexWhere((c) => c.data.id == columnId);

    if (columnIndex != -1) {
      columns[columnIndex].data.tasks.removeWhere((t) => t.data.id == taskId);
      state = [
        ...projects.take(projectIndex),
        projects[projectIndex].copyWith(columns: columns),
        ...projects.skip(projectIndex + 1),
      ];
    }
  }

  void addColumn(String projectId, KanbanColumnData column) {
    final projects = [...state];
    final projectIndex = projects.indexWhere((p) => p.id == projectId);

    if (projectIndex == -1) return;

    final columns = List<SortableData<KanbanColumnData>>.from(
      projects[projectIndex].columns,
    );
    // Wrap the new column in SortableData
    columns.add(SortableData(column));

    // Update the project with new columns
    state = [
      ...projects.take(projectIndex),
      projects[projectIndex].copyWith(columns: columns),
      ...projects.skip(projectIndex + 1),
    ];
  }

  void editColumn(String projectId, String columnId, String newTitle) {
    final projects = [...state];
    final projectIndex = projects.indexWhere((p) => p.id == projectId);

    if (projectIndex == -1) return;

    final columns = List<SortableData<KanbanColumnData>>.from(
      projects[projectIndex].columns,
    );
    final columnIndex = columns.indexWhere((c) => c.data.id == columnId);

    if (columnIndex != -1) {
      final updatedColumn = columns[columnIndex].data.copyWith(title: newTitle);
      columns[columnIndex] = SortableData(updatedColumn);
      state = [
        ...projects.take(projectIndex),
        projects[projectIndex].copyWith(columns: columns),
        ...projects.skip(projectIndex + 1),
      ];
    }
  }

  void deleteColumn(String projectId, String columnId) {
    final projects = [...state];
    final projectIndex = projects.indexWhere((p) => p.id == projectId);

    if (projectIndex == -1) return;

    final columns = List<SortableData<KanbanColumnData>>.from(
      projects[projectIndex].columns,
    );
    columns.removeWhere((c) => c.data.id == columnId);

    state = [
      ...projects.take(projectIndex),
      projects[projectIndex].copyWith(columns: columns),
      ...projects.skip(projectIndex + 1),
    ];
  }

  void addProject(KanbanData project) {
    state = [...state, project];
  }

  void editProject(String projectId, KanbanData updatedProject) {
    final projectIndex = state.indexWhere((p) => p.id == projectId);

    if (projectIndex != -1) {
      state = [
        ...state.take(projectIndex),
        updatedProject,
        ...state.skip(projectIndex + 1),
      ];
    }
  }

  void deleteProject(String projectId) {
    state = state.where((p) => p.id != projectId).toList();
  }
}
