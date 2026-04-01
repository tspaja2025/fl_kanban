import 'package:fl_kanban/constants/kanban_constants.dart';
import 'package:fl_kanban/models/models.dart';
import 'package:fl_kanban/providers/kanban_board_provider.dart';
import 'package:fl_kanban/widgets/badge.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class KanbanBoardScreen extends ConsumerStatefulWidget {
  final String projectId;

  const KanbanBoardScreen({super.key, required this.projectId});

  @override
  ConsumerState<KanbanBoardScreen> createState() => _KanbanBoardScreenState();
}

class _KanbanBoardScreenState extends ConsumerState<KanbanBoardScreen> {
  @override
  Widget build(BuildContext context) {
    final projects = ref.watch(kanbanProvider);
    final currentProject = projects.firstWhere(
      (project) => project.id == widget.projectId,
      orElse: () => projects.first,
    );
    final columns = currentProject.columns;
    final notifier = ref.read(kanbanProvider.notifier);
    final ScrollController scrollController = ScrollController();

    return Scrollbar(
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
              for (int i = 0; i < columns.length; i++)
                KanbanColumn(
                  key: ValueKey(columns[i].data.id),
                  projectId: widget.projectId,
                  column: columns[i],
                  columnIndex: i,
                  onMoveTask: notifier.moveTask,
                ),
              KanbanColumnEmpty(
                projectId: widget.projectId,
                onAddColumn: (title) {
                  notifier.addColumn(
                    widget.projectId,
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
            stateBuilder: (date) {
              return date.isAfter(DateTime.now())
                  ? DateState.disabled
                  : DateState.enabled;
            },
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
