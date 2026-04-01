import 'package:fl_kanban/providers/router_provider.dart';
import 'package:fl_kanban/providers/theme_provider.dart';
import 'package:fl_kanban/widgets/badge.dart';
import 'package:fl_kanban/widgets/kanban_empty_project_card.dart';
import 'package:fl_kanban/widgets/kanban_project_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

void main() {
  runApp(const ProviderScope(child: FlKanban()));
}

class FlKanban extends ConsumerWidget {
  const FlKanban({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final router = ref.watch(routerProvider);

    return ShadcnApp.router(
      key: ValueKey(themeMode),
      debugShowCheckedModeBanner: false,
      title: "Your Kanban Board",
      theme: ThemeData(colorScheme: ColorSchemes.lightNeutral),
      darkTheme: ThemeData(colorScheme: ColorSchemes.darkNeutral),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}

// ================ Screens ================ //

class KanbanProjectScreen extends ConsumerWidget {
  const KanbanProjectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boards = ref.watch(kanbanProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: KanbanConstants.gapSize,
          runSpacing: KanbanConstants.gapSize,
          children: [
            for (final board in boards)
              KanbanProjectCard(
                onTap: () => context.pushNamed(
                  "kanbanProjectDetail",
                  pathParameters: {"id": board.id},
                ),
                title: board.title,
                description: board.description,
              ),
            KanbanEmptyProjectCard(onTap: () => _showNewProjectDialog(context)),
          ],
        ),
      ],
    );
  }

  void _showNewProjectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final controller = FormController();
        return AlertDialog(
          title: const Text("New Project"),
          content: NewProjectForm(controller: controller),
          actions: [
            OutlineButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            PrimaryButton(
              onPressed: () => Navigator.of(context).pop(controller.values),
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}

class NewProjectForm extends ConsumerWidget {
  final FormController controller;

  const NewProjectForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Form(
        controller: controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            FormField(
              key: FormKey(#title),
              label: Text("Title"),
              child: TextField(),
            ),
            FormField(
              key: FormKey(#description),
              label: Text("Description"),
              child: TextArea(maxLines: 3),
            ),
          ],
        ).gap(KanbanConstants.gapSize),
      ),
    );
  }
}

class KanbanBoardScreen extends ConsumerWidget {
  final String projectId;

  const KanbanBoardScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(kanbanProvider);
    final currentProject = projects.firstWhere(
      (project) => project.id == projectId,
      orElse: () => projects.first,
    );
    final columns = currentProject.columns;
    final notifier = ref.read(kanbanProvider.notifier);

    return SortableLayer(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < columns.length; i++)
              KanbanColumn(
                key: ValueKey(columns[i].data.id),
                projectId: projectId,
                column: columns[i],
                columnIndex: i,
                onMoveTask: notifier.moveTask,
              ),
            KanbanColumnEmpty(
              projectId: projectId,
              onAddColumn: (title) {
                notifier.addColumn(
                  projectId,
                  KanbanColumnData(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: title,
                    tasks: [],
                  ),
                );
              },
            ),
          ],
        ).gap(KanbanConstants.gapSize),
      ),
    );
  }
}

class KanbanColumn extends ConsumerStatefulWidget {
  final String projectId;
  final SortableData<KanbanColumnData> column;
  final int columnIndex;
  final void Function(SortableData<KanbanTaskData>, int, int) onMoveTask;

  const KanbanColumn({
    super.key,
    required this.projectId,
    required this.column,
    required this.columnIndex,
    required this.onMoveTask,
  });

  @override
  ConsumerState<KanbanColumn> createState() => _KanbanColumnState();
}

class _KanbanColumnState extends ConsumerState<KanbanColumn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: KanbanConstants.columnWidth,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.card,
        border: Border.all(color: Theme.of(context).colorScheme.border),
        borderRadius: BorderRadius.circular(KanbanConstants.borderRadius),
      ),
      padding: const EdgeInsets.all(KanbanConstants.columnPadding),
      child: SortableDropFallback<KanbanTaskData>(
        onAccept: (value) {
          widget.onMoveTask(
            value,
            widget.columnIndex,
            widget.column.data.tasks.length,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildColumnHeader(),
            ..._buildTaskList(),
            PrimaryButton(
              onPressed: () => _showNewTaskDialog(context),
              alignment: Alignment.center,
              child: const Text("New Task"),
            ),
          ],
        ).gap(KanbanConstants.gapSize),
      ),
    );
  }

  Widget _buildColumnHeader() {
    return Row(
      children: [
        Text(widget.column.data.title),
        const Gap(8),
        PrimaryBadge(child: Text("${widget.column.data.tasks.length}")),
        const Spacer(),
        Builder(
          builder: (context) {
            return IconButton.ghost(
              onPressed: () => _showColumnMenu(context),
              icon: const Icon(LucideIcons.ellipsis, size: 16),
            );
          },
        ),
      ],
    );
  }

  void _showColumnMenu(BuildContext context) {
    final notifier = ref.read(kanbanProvider.notifier);
    showDropdown(
      context: context,
      builder: (context) {
        return DropdownMenu(
          children: [
            const MenuLabel(child: Text("Actions")),
            const MenuDivider(),
            MenuButton(
              onPressed: (context) {
                _showNewTaskDialog(context);
                Navigator.pop(context);
              },
              child: const Text("Add Task"),
            ),
            MenuButton(
              onPressed: (context) {
                _showEditColumnDialog(context);
                Navigator.pop(context);
              },
              child: const Text("Edit Column"),
            ),
            MenuButton(
              onPressed: (context) {
                notifier.deleteColumn(widget.projectId, widget.column.data.id);
                Navigator.pop(context);
              },
              child: const Text("Delete Column"),
            ),
          ],
        );
      },
    );
  }

  void _showEditColumnDialog(BuildContext context) {
    final controller = FormController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Column"),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              controller: controller,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FormField(
                    key: const FormKey(#columnTitle),
                    label: const Text("Column Title"),
                    child: TextField(initialValue: widget.column.data.title),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            OutlineButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            PrimaryButton(
              onPressed: () {
                final title = controller.values[#columnTitle] as String;
                final notifier = ref.read(kanbanProvider.notifier);
                notifier.editColumn(
                  widget.projectId,
                  widget.column.data.id,
                  title,
                );
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _showNewTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => NewTaskDialog(
        projectId: widget.projectId,
        columnId: widget.column.data.id,
      ),
    );
  }

  List<Widget> _buildTaskList() {
    return List.generate(widget.column.data.tasks.length, (taskIndex) {
      final task = widget.column.data.tasks[taskIndex];

      return Sortable<KanbanTaskData>(
        data: task,
        onAcceptTop: (value) {
          widget.onMoveTask(value, widget.columnIndex, taskIndex);
        },
        onAcceptBottom: (value) {
          widget.onMoveTask(value, widget.columnIndex, taskIndex + 1);
        },
        child: KanbanColumnItem(
          title: task.data.title,
          description: task.data.description,
          priority: task.data.priority,
          color: task.data.effectiveColor,
        ),
      );
    });
  }
}

class NewTaskDialog extends ConsumerStatefulWidget {
  final String projectId;
  final String columnId;

  const NewTaskDialog({
    super.key,
    required this.projectId,
    required this.columnId,
  });

  @override
  ConsumerState<NewTaskDialog> createState() => _NewTaskDialogState();
}

class _NewTaskDialogState extends ConsumerState<NewTaskDialog> {
  TaskPriority? selectedPriority;
  DateTime? dueDate;

  @override
  Widget build(BuildContext context) {
    final controller = FormController();

    return AlertDialog(
      title: const Text("New Task"),
      content: NewTaskForm(
        controller: controller,
        selectedPriority: selectedPriority,
        dueDate: dueDate,
        onPriorityChanged: (priority) =>
            setState(() => selectedPriority = priority),
        onDueDateChanged: (date) => setState(() => dueDate = date),
      ),
      actions: [
        OutlineButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        PrimaryButton(
          onPressed: () {
            final values = controller.values;
            final notifier = ref.read(kanbanProvider.notifier);

            final newTask = KanbanTaskData(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              title: values[#title] as String,
              description: values[#description] as String,
              priority: selectedPriority ?? TaskPriority.medium,
            );

            notifier.addTask(widget.projectId, widget.columnId, newTask);
            Navigator.pop(context);
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}

class NewTaskForm extends ConsumerWidget {
  final FormController controller;
  final TaskPriority? selectedPriority;
  final DateTime? dueDate;
  final ValueChanged<TaskPriority?> onPriorityChanged;
  final ValueChanged<DateTime?> onDueDateChanged;

  const NewTaskForm({
    super.key,
    required this.controller,
    required this.selectedPriority,
    required this.dueDate,
    required this.onPriorityChanged,
    required this.onDueDateChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Form(
        controller: controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const FormField(
              key: FormKey(#title),
              label: Text("Title"),
              child: TextField(),
            ),
            const FormField(
              key: FormKey(#description),
              label: Text("Description"),
              child: TextArea(maxLines: 3),
            ),
            PriorityFormField(
              value: selectedPriority,
              onChanged: onPriorityChanged,
            ),
            DueDateFormField(value: dueDate, onChanged: onDueDateChanged),
          ],
        ).gap(KanbanConstants.gapSize),
      ),
    );
  }
}

class PriorityFormField extends ConsumerWidget {
  final TaskPriority? value;
  final ValueChanged<TaskPriority?> onChanged;

  const PriorityFormField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FormField(
      key: const FormKey(#priority),
      label: const Text("Priority"),
      child: Select<TaskPriority>(
        itemBuilder: (context, item) => Text(item.displayName),
        popupConstraints: const BoxConstraints(maxHeight: 300, maxWidth: 200),
        onChanged: onChanged,
        value: value,
        placeholder: const Text("Select priority"),
        popup: const SelectPopup(
          items: SelectItemList(
            children: [
              SelectItemButton(value: TaskPriority.high, child: Text("High")),
              SelectItemButton(
                value: TaskPriority.medium,
                child: Text("Medium"),
              ),
              SelectItemButton(value: TaskPriority.low, child: Text("Low")),
            ],
          ),
        ).call,
      ),
    );
  }
}

class DueDateFormField extends ConsumerWidget {
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  const DueDateFormField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FormField(
      key: FormKey(#dueDate),
      label: const Text("Due Date"),
      child: DatePicker(
        value: value,
        mode: PromptMode.popover,
        stateBuilder: (date) {
          return date.isAfter(DateTime.now())
              ? DateState.disabled
              : DateState.enabled;
        },
        onChanged: onChanged,
      ),
    );
  }
}

class KanbanColumnEmpty extends ConsumerWidget {
  final String projectId;
  final void Function(String title) onAddColumn;

  const KanbanColumnEmpty({
    super.key,
    required this.projectId,
    required this.onAddColumn,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _showNewColumnDialog(context),
        child: Container(
          width: KanbanConstants.columnWidth,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.card,
            border: Border.all(color: Theme.of(context).colorScheme.border),
            borderRadius: BorderRadius.circular(KanbanConstants.borderRadius),
          ),
          padding: const EdgeInsets.all(KanbanConstants.columnPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [const Icon(LucideIcons.plus, size: 32)],
          ).gap(KanbanConstants.gapSize),
        ),
      ),
    );
  }

  void _showNewColumnDialog(BuildContext context) {
    final controller = FormController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("New Column"),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              controller: controller,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  FormField(
                    key: FormKey(#columnTitle),
                    label: Text("Column Title"),
                    child: TextField(),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            OutlineButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            PrimaryButton(
              onPressed: () {
                final title = controller.values[#columnTitle] as String;
                onAddColumn(title);
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}

class KanbanColumnItem extends ConsumerWidget {
  final String title;
  final String description;
  final TaskPriority priority;
  final Color color;

  const KanbanColumnItem({
    super.key,
    required this.title,
    required this.description,
    required this.priority,
    required this.color,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.card,
        border: Border.all(color: Theme.of(context).colorScheme.border),
        borderRadius: BorderRadius.circular(KanbanConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(KanbanConstants.columnPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title).semiBold,
              const Spacer(),
              Badge(child: priority.displayName, color: color),
            ],
          ),
          const Gap(KanbanConstants.gapSize),
          Text(description),
          const Gap(KanbanConstants.gapSize),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        const Icon(LucideIcons.calendar, size: 16),
        const Gap(8),
        const Text("Mar 21"),
        const Spacer(),
        Avatar(
          size: 24,
          initials: Avatar.getInitials("ts paja"),
          provider: const NetworkImage(
            "https://avatars.githubusercontent.com/u/213942709?s=400&v=4",
          ),
        ),
      ],
    );
  }
}

// ================ Models ================ //

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

class KanbanConstants {
  static const double columnWidth = 360;
  static const double columnPadding = 16;
  static const double borderRadius = 12;
  static const double gapSize = 16;
}

// ================ Providers ================ //

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
    columns.add(SortableData(column));

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
}
