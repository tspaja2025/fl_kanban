import 'package:fl_kanban/models/models.dart';
import 'package:fl_kanban/service/storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

final kanbanProvider = AsyncNotifierProvider<KanbanNotifier, List<KanbanData>>(
  KanbanNotifier.new,
);

class KanbanNotifier extends AsyncNotifier<List<KanbanData>> {
  final StorageService _storageService = StorageService();
  String _searchQuery = "";
  String _taskSearchQuery = "";

  String get searchQuery => _searchQuery;
  String get taskSearchQuery => _taskSearchQuery;

  @override
  Future<List<KanbanData>> build() async {
    final savedData = await _storageService.loadKanbanData();

    if (savedData.isNotEmpty) {
      return savedData;
    }

    return _getExampleKanbanData();
  }

  List<KanbanData> _getExampleKanbanData() {
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
      return state.value ?? [];
    }

    final query = _searchQuery.trim().toLowerCase();
    return (state.value ?? []).where((project) {
      return project.title.toLowerCase().contains(query) ||
          project.description.toLowerCase().contains(query);
    }).toList();
  }

  List<SortableData<KanbanColumnData>> getFilteredColumns(String projectId) {
    final projects = state.value;
    if (projects == null) return [];

    final project = projects.firstWhere((p) => p.id == projectId);

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
    ref.notifyListeners();
  }

  void updateTaskSearchQuery(String query) {
    _taskSearchQuery = query;
    ref.notifyListeners();
  }

  // Helper method to save state after modifications
  Future<void> _saveAndUpdate(List<KanbanData> newState) async {
    state = AsyncData(newState);
    await _storageService.saveKanbanData(newState);
  }

  Future<void> moveTask(
    SortableData<KanbanTaskData> task,
    int targetColumnIndex,
    int targetTaskIndex,
  ) async {
    final projects = state.value;
    if (projects == null || projects.isEmpty) return;

    final projectsList = List<KanbanData>.from(projects);
    final columns = List<SortableData<KanbanColumnData>>.from(
      projectsList[0].columns,
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
    final newProjects = [
      projectsList[0].copyWith(columns: columns),
      ...projectsList.skip(1),
    ];
    await _saveAndUpdate(newProjects);
  }

  Future<void> addTask(
    String projectId,
    String columnId,
    KanbanTaskData task,
  ) async {
    final projects = state.value;
    if (projects == null) return;

    final projectsList = List<KanbanData>.from(projects);
    final projectIndex = projectsList.indexWhere((p) => p.id == projectId);

    if (projectIndex == -1) return;

    final columns = List<SortableData<KanbanColumnData>>.from(
      projectsList[projectIndex].columns,
    );
    final columnIndex = columns.indexWhere((c) => c.data.id == columnId);

    if (columnIndex != -1) {
      // Wrap the new task in SortableData
      columns[columnIndex].data.tasks.add(SortableData(task));
      final newProjects = [
        ...projectsList.take(projectIndex),
        projectsList[projectIndex].copyWith(columns: columns),
        ...projectsList.skip(projectIndex + 1),
      ];
      await _saveAndUpdate(newProjects);
    }
  }

  Future<void> editTask(
    String projectId,
    String columnId,
    String taskId,
    KanbanTaskData updatedTask,
  ) async {
    final projects = state.value;
    if (projects == null) return;

    final projectsList = List<KanbanData>.from(projects);
    final projectIndex = projectsList.indexWhere((p) => p.id == projectId);

    if (projectIndex == -1) return;

    final columns = List<SortableData<KanbanColumnData>>.from(
      projectsList[projectIndex].columns,
    );
    final columnIndex = columns.indexWhere((c) => c.data.id == columnId);

    if (columnIndex != -1) {
      final taskIndex = columns[columnIndex].data.tasks.indexWhere(
        (t) => t.data.id == taskId,
      );
      if (taskIndex != -1) {
        columns[columnIndex].data.tasks[taskIndex] = SortableData(updatedTask);
        final newProjects = [
          ...projectsList.take(projectIndex),
          projectsList[projectIndex].copyWith(columns: columns),
          ...projectsList.skip(projectIndex + 1),
        ];
        await _saveAndUpdate(newProjects);
      }
    }
  }

  Future<void> deleteTask(
    String projectId,
    String columnId,
    String taskId,
  ) async {
    final projects = state.value;
    if (projects == null) return;

    final projectsList = List<KanbanData>.from(projects);
    final projectIndex = projectsList.indexWhere((p) => p.id == projectId);

    if (projectIndex == -1) return;

    final columns = List<SortableData<KanbanColumnData>>.from(
      projectsList[projectIndex].columns,
    );
    final columnIndex = columns.indexWhere((c) => c.data.id == columnId);

    if (columnIndex != -1) {
      columns[columnIndex].data.tasks.removeWhere((t) => t.data.id == taskId);
      final newProjects = [
        ...projectsList.take(projectIndex),
        projectsList[projectIndex].copyWith(columns: columns),
        ...projectsList.skip(projectIndex + 1),
      ];
      await _saveAndUpdate(newProjects);
    }
  }

  Future<void> addColumn(String projectId, KanbanColumnData column) async {
    final projects = state.value;
    if (projects == null) return;

    final projectsList = List<KanbanData>.from(projects);
    final projectIndex = projectsList.indexWhere((p) => p.id == projectId);

    if (projectIndex == -1) return;

    final columns = List<SortableData<KanbanColumnData>>.from(
      projectsList[projectIndex].columns,
    );
    // Wrap the new column in SortableData
    columns.add(SortableData(column));

    // Update the project with new columns
    final newProjects = [
      ...projectsList.take(projectIndex),
      projectsList[projectIndex].copyWith(columns: columns),
      ...projectsList.skip(projectIndex + 1),
    ];
    await _saveAndUpdate(newProjects);
  }

  Future<void> editColumn(
    String projectId,
    String columnId,
    String newTitle,
  ) async {
    final projects = state.value;
    if (projects == null) return;

    final projectsList = List<KanbanData>.from(projects);
    final projectIndex = projectsList.indexWhere((p) => p.id == projectId);

    if (projectIndex == -1) return;

    final columns = List<SortableData<KanbanColumnData>>.from(
      projectsList[projectIndex].columns,
    );
    final columnIndex = columns.indexWhere((c) => c.data.id == columnId);

    if (columnIndex != -1) {
      final updatedColumn = columns[columnIndex].data.copyWith(title: newTitle);
      columns[columnIndex] = SortableData(updatedColumn);
      final newProjects = [
        ...projectsList.take(projectIndex),
        projectsList[projectIndex].copyWith(columns: columns),
        ...projectsList.skip(projectIndex + 1),
      ];
      await _saveAndUpdate(newProjects);
    }
  }

  Future<void> deleteColumn(String projectId, String columnId) async {
    final projects = state.value;
    if (projects == null) return;

    final projectsList = List<KanbanData>.from(projects);
    final projectIndex = projectsList.indexWhere((p) => p.id == projectId);

    if (projectIndex == -1) return;

    final columns = List<SortableData<KanbanColumnData>>.from(
      projectsList[projectIndex].columns,
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

    final newProjects = [
      ...projects.take(projectIndex),
      projects[projectIndex].copyWith(columns: columns),
      ...projectsList.skip(projectIndex + 1),
    ];
    await _saveAndUpdate(newProjects);
  }

  Future<void> addProject(KanbanData project) async {
    final projects = state.value;
    if (projects == null) return;

    final newProjects = [...projects, project];
    await _saveAndUpdate(newProjects);
  }

  Future<void> editProject(String projectId, KanbanData updatedProject) async {
    final projects = state.value;
    if (projects == null) return;

    final projectIndex = projects.indexWhere((p) => p.id == projectId);

    if (projectIndex != -1) {
      final newProjects = [
        ...projects.take(projectIndex),
        updatedProject,
        ...projects.skip(projectIndex + 1),
      ];
      await _saveAndUpdate(newProjects);
    }
  }

  Future<void> updateProject(KanbanData updatedProject) async {
    final projects = state.value;
    if (projects == null) return;

    final projectIndex = projects.indexWhere((p) => p.id == updatedProject.id);

    if (projectIndex != -1) {
      final existingProject = projects[projectIndex];
      final mergedProject = updatedProject.copyWith(
        columns: existingProject.columns,
        status: existingProject.status,
        dueDate: existingProject.dueDate,
        backgroundColor: existingProject.backgroundColor,
        foregroundColor: existingProject.foregroundColor,
      );

      final newProjects = [
        ...projects.take(projectIndex),
        mergedProject,
        ...projects.skip(projectIndex + 1),
      ];
      await _saveAndUpdate(newProjects);
    }
  }

  Future<void> deleteProject(String projectId) async {
    final projects = state.value;
    if (projects == null) return;

    final newProjects = projects.where((p) => p.id != projectId).toList();
    await _saveAndUpdate(newProjects);
  }

  Future<void> resetToDefault() async {
    final defaultData = _getExampleKanbanData();
    await _storageService.clearSavedData();
    await _saveAndUpdate(defaultData);
  }
}
