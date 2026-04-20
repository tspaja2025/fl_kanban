import 'package:fl_kanban/shared/kanban_constants.dart';
import 'package:fl_kanban/models/models.dart';
import 'package:fl_kanban/providers/kanban_provider.dart';
import 'package:fl_kanban/widgets/badge.dart';
import 'package:fl_kanban/widgets/card_container.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class KanbanBoardScreen extends ConsumerStatefulWidget {
  final String projectId;

  const KanbanBoardScreen({super.key, required this.projectId});

  @override
  ConsumerState<KanbanBoardScreen> createState() => _KanbanBoardScreenState();
}

class _KanbanBoardScreenState extends ConsumerState<KanbanBoardScreen> {
  final _taskSearchController = TextEditingController();

  @override
  void dispose() {
    _taskSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projectsAsync = ref.watch(kanbanProvider);
    final notifier = ref.read(kanbanProvider.notifier);
    final ScrollController scrollController = ScrollController();

    return projectsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error loading projects: $error'),
            const Gap(16),
            PrimaryButton(
              onPressed: () => ref.invalidate(kanbanProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (projects) {
        final currentProject = projects.firstWhere(
          (project) => project.id == widget.projectId,
          orElse: () => projects.first,
        );

        final filteredColumns = notifier.getFilteredColumns(widget.projectId);

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(currentProject.title).large.bold,
                      Text(currentProject.description),
                    ],
                  ),
                  const Spacer(),
                  if (_taskSearchController.text.isNotEmpty)
                    Container(
                      width: 320,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.card,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(LucideIcons.search, size: 16),
                          const Gap(8),
                          Text(
                            'Showing tasks matching: "${_taskSearchController.text}"',
                          ).small,
                          TextButton(
                            onPressed: () {
                              _taskSearchController.clear();
                              notifier.updateTaskSearchQuery('');
                            },
                            child: const Text("Clear"),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(
                    width: 250,
                    child: TextField(
                      controller: _taskSearchController,
                      placeholder: const Text("Search tasks"),
                      onChanged: (value) {
                        notifier.updateTaskSearchQuery(value);
                      },
                      features: [
                        InputFeature.leading(
                          StatedWidget.builder(
                            builder: (context, states) {
                              return states.hovered
                                  ? const Icon(LucideIcons.search)
                                  : const Icon(
                                      LucideIcons.search,
                                    ).iconMutedForeground;
                            },
                          ),
                          visibility: InputFeatureVisibility.textEmpty,
                        ),
                        InputFeature.clear(
                          visibility:
                              (InputFeatureVisibility.textNotEmpty &
                                  InputFeatureVisibility.focused) |
                              InputFeatureVisibility.hovered,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(16),
              Scrollbar(
                controller: scrollController,
                thumbVisibility: true,
                trackVisibility: true,
                interactive: true,
                child: SingleChildScrollView(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  child: SortableLayer(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (int i = 0; i < filteredColumns.length; i++)
                          KanbanColumn(
                            key: ValueKey(filteredColumns[i].data.id),
                            projectId: widget.projectId,
                            column: filteredColumns[i],
                            columnIndex: i,
                            onMoveTask: notifier.moveTask,
                            isSearchActive:
                                _taskSearchController.text.isNotEmpty,
                          ),
                        if (_taskSearchController.text.isEmpty)
                          KanbanColumnEmpty(
                            projectId: widget.projectId,
                            onAddColumn: (title) {
                              notifier.addColumn(
                                widget.projectId,
                                KanbanColumnData(
                                  id: DateTime.now().millisecondsSinceEpoch
                                      .toString(),
                                  title: title,
                                  tasks: [],
                                ),
                              );
                            },
                          ),
                      ],
                    ).gap(KanbanConstants.gapSize),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class KanbanColumn extends ConsumerStatefulWidget {
  final String projectId;
  final SortableData<KanbanColumnData> column;
  final int columnIndex;
  final void Function(String, SortableData<KanbanTaskData>, int, int)
  onMoveTask;
  final bool isSearchActive;

  const KanbanColumn({
    super.key,
    required this.projectId,
    required this.column,
    required this.columnIndex,
    required this.onMoveTask,
    this.isSearchActive = false,
  });

  @override
  ConsumerState<KanbanColumn> createState() => _KanbanColumnState();
}

class _KanbanColumnState extends ConsumerState<KanbanColumn> {
  @override
  Widget build(BuildContext context) {
    final hasSearchResults =
        widget.isSearchActive && widget.column.data.tasks.isNotEmpty;

    return Container(
      width: KanbanConstants.columnWidth,
      height: widget.isSearchActive
          ? MediaQuery.of(context).size.height - 150
          : MediaQuery.of(context).size.height - 145,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.card,
        border: Border.all(
          color: hasSearchResults
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.border,
          width: hasSearchResults ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(KanbanConstants.borderRadius),
      ),
      padding: const EdgeInsets.all(KanbanConstants.columnPadding),
      child: SortableDropFallback<KanbanTaskData>(
        onAccept: widget.isSearchActive
            ? null
            : (value) {
                widget.onMoveTask(
                  widget.projectId,
                  value,
                  widget.columnIndex,
                  widget.column.data.tasks.length,
                );
              },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildColumnHeader(),
            if (widget.isSearchActive && widget.column.data.tasks.isEmpty)
              Expanded(child: Center(child: Text("No matching tasks").muted))
            else
              ..._buildTaskList(),
            if (!widget.isSearchActive)
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
              onPressed: (_) {
                _showNewTaskDialog(context);
              },
              child: const Text("Add Task"),
            ),
            MenuButton(
              onPressed: (_) {
                _showEditColumnDialog(context);
              },
              child: const Text("Edit Column"),
            ),
            MenuButton(
              onPressed: (_) {
                notifier.deleteColumn(widget.projectId, widget.column.data.id);
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
                // ignore: collection_methods_unrelated_type
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
          widget.onMoveTask(
            widget.projectId,
            value,
            widget.columnIndex,
            taskIndex,
          );
        },
        onAcceptBottom: (value) {
          widget.onMoveTask(
            widget.projectId,
            value,
            widget.columnIndex,
            taskIndex + 1,
          );
        },
        child: KanbanColumnItem(
          projectId: widget.projectId,
          columnId: widget.column.data.id,
          taskId: task.data.id,
          title: task.data.title,
          description: task.data.description,
          priority: task.data.priority,
          color: task.data.effectiveColor,
          dueDate: task.data.dueDate,
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
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  TaskPriority? selectedPriority;
  DateTime? dueDate;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("New Task"),
      content: NewTaskForm(
        titleController: titleController,
        descriptionController: descriptionController,
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
            final title = titleController.text.trim();
            final description = descriptionController.text.trim();

            if (title.isNotEmpty) {
              final notifier = ref.read(kanbanProvider.notifier);

              final newTask = KanbanTaskData(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: title,
                description: description,
                priority: selectedPriority ?? TaskPriority.medium,
                dueDate: dueDate,
              );

              notifier.addTask(widget.projectId, widget.columnId, newTask);
              Navigator.pop(context);
            }
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}

class NewTaskForm extends ConsumerWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TaskPriority? selectedPriority;
  final DateTime? dueDate;
  final ValueChanged<TaskPriority?> onPriorityChanged;
  final ValueChanged<DateTime?> onDueDateChanged;

  const NewTaskForm({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.selectedPriority,
    required this.dueDate,
    required this.onPriorityChanged,
    required this.onDueDateChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text("Title"),
          const Gap(8),
          TextField(
            controller: titleController,
            autofocus: true,
            placeholder: const Text("Enter task title"),
          ),
          const Gap(16),
          const Text("Description"),
          const Gap(8),
          TextField(
            controller: descriptionController,
            maxLines: 3,
            placeholder: const Text("Enter task description"),
          ),
          const Gap(16),
          const Text("Priority"),
          const Gap(8),
          Select<TaskPriority>(
            itemBuilder: (context, item) => Text(item.displayName),
            popupConstraints: const BoxConstraints(
              maxHeight: 300,
              maxWidth: 200,
            ),
            onChanged: onPriorityChanged,
            value: selectedPriority,
            placeholder: const Text("Select priority"),
            popup: const SelectPopup(
              items: SelectItemList(
                children: [
                  SelectItemButton(
                    value: TaskPriority.high,
                    child: Text("High"),
                  ),
                  SelectItemButton(
                    value: TaskPriority.medium,
                    child: Text("Medium"),
                  ),
                  SelectItemButton(value: TaskPriority.low, child: Text("Low")),
                ],
              ),
            ).call,
          ),
          const Gap(16),
          const Text("Due Date"),
          const Gap(8),
          DatePicker(
            value: dueDate,
            mode: PromptMode.popover,
            onChanged: onDueDateChanged,
          ),
        ],
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
          return date.isBefore(DateTime.now().subtract(const Duration(days: 1)))
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
    final titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("New Column"),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text("Column Title"),
                const Gap(8),
                TextField(
                  controller: titleController,
                  autofocus: true,
                  placeholder: const Text("Enter column title"),
                ),
              ],
            ),
          ),
          actions: [
            OutlineButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            PrimaryButton(
              onPressed: () {
                final title = titleController.text.trim();
                if (title.isNotEmpty) {
                  onAddColumn(title);
                  Navigator.pop(context);
                }
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
  final String projectId;
  final String columnId;
  final String taskId;
  final String title;
  final String description;
  final TaskPriority priority;
  final Color color;
  final DateTime? dueDate;

  const KanbanColumnItem({
    super.key,
    required this.projectId,
    required this.columnId,
    required this.taskId,
    required this.title,
    required this.description,
    required this.priority,
    required this.color,
    this.dueDate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CardContainer(
      height: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title).semiBold,
              const Spacer(),
              Builder(
                builder: (context) {
                  return IconButton.ghost(
                    onPressed: () {
                      showDropdown(
                        context: context,
                        builder: (context) {
                          return DropdownMenu(
                            children: [
                              MenuLabel(child: const Text("Actions")),
                              MenuDivider(),
                              MenuButton(
                                onPressed: (_) {
                                  _showEditTaskDialog(context, ref);
                                },
                                child: const Text("Edit"),
                              ),
                              MenuButton(
                                onPressed: (_) {
                                  _showDeleteTaskDialog(context, ref);
                                },
                                child: const Text("Delete"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(LucideIcons.ellipsis, size: 16),
                  );
                },
              ),
            ],
          ),
          const Gap(KanbanConstants.gapSize),
          Text(description),
          const Gap(KanbanConstants.gapSize),
          _buildFooter(context),
        ],
      ),
    );
  }

  void _showEditTaskDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController(text: title);
    final descriptionController = TextEditingController(text: description);
    TaskPriority? selectedPriority = priority;
    DateTime? dueDate;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Task"),
          content: NewTaskForm(
            titleController: titleController,
            descriptionController: descriptionController,
            selectedPriority: selectedPriority,
            dueDate: dueDate,
            onPriorityChanged: (priority) => selectedPriority = priority,
            onDueDateChanged: (date) => dueDate = date,
          ),
          actions: [
            OutlineButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            PrimaryButton(
              onPressed: () {
                final newTitle = titleController.text.trim();
                final newDescription = descriptionController.text.trim();

                if (newTitle.isNotEmpty) {
                  final notifier = ref.read(kanbanProvider.notifier);

                  final updatedTask = KanbanTaskData(
                    id: taskId,
                    title: newTitle,
                    description: newDescription,
                    priority: selectedPriority ?? TaskPriority.medium,
                    dueDate: dueDate,
                  );

                  notifier.editTask(projectId, columnId, taskId, updatedTask);
                  Navigator.pop(context);
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteTaskDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Task"),
          content: const Text("Are you sure you want to delete this task?"),
          actions: [
            OutlineButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            PrimaryButton(
              onPressed: () {
                final notifier = ref.read(kanbanProvider.notifier);
                notifier.deleteTask(projectId, columnId, taskId);
                Navigator.pop(context);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFooter(BuildContext context) {
    String dueDateText = "";

    if (dueDate != null) {
      dueDateText = "${dueDate!.month}/${dueDate!.day}";
    } else {
      dueDateText = "No Date";
    }

    final isOverdue = dueDate != null && dueDate!.isBefore(DateTime.now());

    return Row(
      children: [
        const Icon(LucideIcons.calendar, size: 16),
        const Gap(8),
        Text(
          dueDateText,
          style: isOverdue
              ? TextStyle(color: Theme.of(context).colorScheme.destructive)
              : null,
        ),
        const Gap(8),
        Badge(text: priority.displayName, backgroundColor: color),
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
