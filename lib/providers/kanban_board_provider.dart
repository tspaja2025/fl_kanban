import 'package:fl_kanban/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

final kanbanProvider = NotifierProvider<KanbanNotifier, List<KanbanData>>(
  KanbanNotifier.new,
);

class KanbanNotifier extends Notifier<List<KanbanData>> {
  String _searchQuery = "";
  String _taskSearchQuery = "";

  String get searchQuery => _searchQuery;
  String get taskSearchQuery => _taskSearchQuery;

  @override
  List<KanbanData> build() {
    return [
      KanbanData(
        id: "1",
        title: "Alpha Redesign",
        description:
            "Complete overhaul of the core user interface focusing on accessbility.",
        status: ProjectStatus.inProgress,
        backgroundColor: const Color(0xFFE0F2FE),
        foregroundColor: const Color(0xFF075985),
        dueDate: "3 days left",
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
                    dueDate: DateTime(2026, 4, 10),
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
                    dueDate: DateTime(2026, 4, 10),
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
                    dueDate: DateTime(2026, 4, 10),
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
                    dueDate: DateTime(2026, 4, 10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      KanbanData(
        id: "2",
        title: "Q3 Marketing Site",
        description: "Brand expansion for the new enterprise tier launch.",
        status: ProjectStatus.completed,
        backgroundColor: Color(0xFFDCFCE7),
        foregroundColor: Color(0xFF166534),
        dueDate: "3 days left",
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
                    dueDate: DateTime(2026, 4, 10),
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
                    dueDate: DateTime(2026, 4, 10),
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
                    dueDate: DateTime(2026, 4, 10),
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
                    dueDate: DateTime(2026, 4, 10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      KanbanData(
        id: "3",
        title: "API Documentation",
        description: "Developing a new Swagger-based documentation system.",
        status: ProjectStatus.delayed,
        backgroundColor: Color(0xFFFEE2E2),
        foregroundColor: Color(0xFF991B1B),
        dueDate: "3 days left",
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
                    dueDate: DateTime(2026, 4, 10),
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
                    dueDate: DateTime(2026, 4, 10),
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
                    dueDate: DateTime(2026, 4, 10),
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
                    dueDate: DateTime(2026, 4, 10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      KanbanData(
        id: "4",
        title: "Security Audit",
        description:
            "Quarterly review of our infastructure and data encryption.",
        status: ProjectStatus.inProgress,
        backgroundColor: const Color(0xFFE0F2FE),
        foregroundColor: const Color(0xFF075985),
        dueDate: "3 days left",
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
                    dueDate: DateTime(2026, 4, 10),
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
                    dueDate: DateTime(2026, 4, 10),
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
                    dueDate: DateTime(2026, 4, 10),
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
                    dueDate: DateTime(2026, 4, 10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ];
  }

  List<KanbanData> get filteredProjects {
    if (_searchQuery.isEmpty) {
      return state;
    }

    final query = _searchQuery.trim().toLowerCase();
    return state.where((project) {
      return project.title.toLowerCase().contains(query) ||
          project.description.toLowerCase().contains(query);
    }).toList();
  }

  List<SortableData<KanbanColumnData>> getFilteredColumns(String projectId) {
    final project = state.firstWhere((p) => p.id == projectId);

    if (_taskSearchQuery.isEmpty) {
      return project.columns;
    }

    final query = _taskSearchQuery.trim().toLowerCase();

    // Filter tasks in each column
    return project.columns.map((column) {
      final filteredTasks = column.data.tasks.where((task) {
        return task.data.title.toLowerCase().contains(query) ||
            task.data.description.toLowerCase().contains(query);
      }).toList();

      return SortableData(column.data.copyWith(tasks: filteredTasks));
    }).toList();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    state = [...state];
  }

  void updateTaskSearchQuery(String query) {
    _taskSearchQuery = query;
    state = [...state];
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

    if (columns.isEmpty) {
      columns.add(
        SortableData(
          KanbanColumnData(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: "To Do",
            tasks: [],
          ),
        ),
      );
    }

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

  void updateProject(KanbanData updatedProject) {
    final projectIndex = state.indexWhere((p) => p.id == updatedProject.id);

    if (projectIndex != -1) {
      // Preserve existing columns and other data that wasn't updated
      final existingProject = state[projectIndex];
      final mergedProject = updatedProject.copyWith(
        columns: existingProject.columns,
        status: existingProject.status,
        dueDate: existingProject.dueDate,
        backgroundColor: existingProject.backgroundColor,
        foregroundColor: existingProject.foregroundColor,
      );

      state = [
        ...state.take(projectIndex),
        mergedProject,
        ...state.skip(projectIndex + 1),
      ];
    }
  }

  void deleteProject(String projectId) {
    state = state.where((p) => p.id != projectId).toList();
  }
}
