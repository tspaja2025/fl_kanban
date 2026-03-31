import 'package:fl_kanban/models/models.dart';
import 'package:fl_kanban/widgets/badge.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class KanbanBoardScreen extends ConsumerWidget {
  final String projectId;

  const KanbanBoardScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final columns = ref.watch(kanbanProvider);
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
                column: columns[i],
                columnIndex: i,
                onMoveTask: notifier.moveTask,
              ),
            KanbanColumnEmpty(),
          ],
        ).gap(16),
      ),
    );
  }
}

class KanbanColumn extends ConsumerStatefulWidget {
  final SortableData<KanbanColumnData> column;
  final int columnIndex;
  final void Function(SortableData<KanbanTaskData>, int, int) onMoveTask;

  const KanbanColumn({
    super.key,
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
      width: 360,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.card,
        border: Border.all(color: Theme.of(context).colorScheme.border),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
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
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    final FormController controller = FormController();
                    String? selectedValue;
                    DateTime? dateValue;

                    return AlertDialog(
                      title: const Text("New Task"),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ConstrainedBox(
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
                                  FormField(
                                    key: const FormKey(#priority),
                                    label: const Text("Priority"),
                                    child: Select<String>(
                                      itemBuilder: (context, item) {
                                        return Text(item);
                                      },
                                      popupConstraints: const BoxConstraints(
                                        maxHeight: 300,
                                        maxWidth: 200,
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedValue = value;
                                        });
                                      },
                                      value: selectedValue,
                                      placeholder: const Text(
                                        "Select priority",
                                      ),
                                      popup: const SelectPopup(
                                        items: SelectItemList(
                                          children: [
                                            SelectItemButton(
                                              value: "High",
                                              child: Text("High"),
                                            ),
                                            SelectItemButton(
                                              value: "Medium",
                                              child: Text("Medium"),
                                            ),
                                            SelectItemButton(
                                              value: "Low",
                                              child: Text("Low"),
                                            ),
                                          ],
                                        ),
                                      ).call,
                                    ),
                                  ),
                                  FormField(
                                    key: FormKey(#dueDate),
                                    label: Text("Due Date"),
                                    child: DatePicker(
                                      value: dateValue,
                                      mode: PromptMode.popover,
                                      stateBuilder: (date) {
                                        if (date.isAfter(DateTime.now())) {
                                          return DateState.disabled;
                                        }
                                        return DateState.enabled;
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          dateValue = value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ).gap(16),
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        OutlineButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"),
                        ),
                        OutlineButton(
                          onPressed: () {
                            Navigator.of(context).pop(controller.values);
                          },
                          child: const Text("Save"),
                        ),
                      ],
                    );
                  },
                );
              },
              alignment: Alignment.center,
              child: const Text("New Task"),
            ),
          ],
        ).gap(16),
      ),
    );
  }

  Widget _buildColumnHeader() {
    return Row(
      children: [
        Text(widget.column.data.title),
        gap(8),
        PrimaryBadge(child: Text("${widget.column.data.tasks.length}")),
        const Spacer(),
        Builder(
          builder: (context) {
            return IconButton.ghost(
              onPressed: () {
                showDropdown(
                  context: context,
                  builder: (context) {
                    return const DropdownMenu(
                      children: [
                        MenuLabel(child: Text("Actions")),
                        MenuDivider(),
                        MenuButton(child: Text("Add Task")),
                        MenuButton(child: Text("Edit Column")),
                        MenuButton(child: Text("Delete Column")),
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
          color: task.data.color,
        ),
      );
    });
  }
}

class KanbanColumnEmpty extends ConsumerWidget {
  const KanbanColumnEmpty({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              final FormController controller = FormController();

              return AlertDialog(
                title: const Text("New Column"),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ConstrainedBox(
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
                  ],
                ),
                actions: [
                  OutlineButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                  OutlineButton(
                    onPressed: () {
                      Navigator.of(context).pop(controller.values);
                    },
                    child: const Text("Save"),
                  ),
                ],
              );
            },
          );
        },
        child: Container(
          width: 360,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.card,
            border: Border.all(color: Theme.of(context).colorScheme.border),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [const Icon(LucideIcons.plus, size: 32)],
          ).gap(16),
        ),
      ),
    );
  }
}

class KanbanColumnItem extends ConsumerWidget {
  final String title;
  final String description;
  final String priority;
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
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title).semiBold,
              const Spacer(),
              Badge(child: priority, color: color),
            ],
          ),

          gap(16),

          Text(description),

          gap(16),

          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        const Icon(LucideIcons.calendar, size: 16),
        gap(8),
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

final kanbanProvider =
    NotifierProvider<KanbanNotifier, List<SortableData<KanbanColumnData>>>(
      KanbanNotifier.new,
    );

class KanbanNotifier extends Notifier<List<SortableData<KanbanColumnData>>> {
  @override
  List<SortableData<KanbanColumnData>> build() {
    return [
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
                priority: "High",
                color: Colors.red,
              ),
            ),
            SortableData(
              KanbanTaskData(
                id: "2",
                title: "V3 Iconography Pack",
                description:
                    "Exporting all stroke-based icons for the new shadcn library.",
                priority: "Medium",
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
                priority: "Low",
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
                priority: "High",
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    ];
  }

  void addTask() {}

  void editTask() {}

  void deleteTask() {}

  void moveTask(
    SortableData<KanbanTaskData> task,
    int targetColumnIndex,
    int targetTaskIndex,
  ) {
    final columns = [...state];

    SortableData<KanbanTaskData>? removedTask;

    for (var column in columns) {
      final index = column.data.tasks.indexWhere((t) => t == task);
      if (index != -1) {
        removedTask = column.data.tasks.removeAt(index);
        break;
      }
    }

    if (removedTask == null) return;

    final targetColumn = columns[targetColumnIndex];

    if (targetTaskIndex >= targetColumn.data.tasks.length) {
      targetColumn.data.tasks.add(removedTask);
    } else {
      targetColumn.data.tasks.insert(targetTaskIndex, removedTask);
    }

    state = columns;
  }

  void addColumn() {}

  void editColumn() {}

  void deleteColumn() {}
}
