import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

// TODO:
// Cross-column dragging
// Column and Column item dragging works and breaks everything
// Move state to riverpod
// Search tasks functionality

class DefaultScreen extends ConsumerStatefulWidget {
  const DefaultScreen({super.key});

  @override
  ConsumerState<DefaultScreen> createState() => _DefaultScreenState();
}

class _DefaultScreenState extends ConsumerState<DefaultScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final board = ref.watch(boardProvider);
    final boardNotifier = ref.read(boardProvider.notifier);

    return Scaffold(
      headers: [
        AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryForeground,
          child: Row(
            children: [
              const Spacer(),
              Expanded(
                child: TextField(
                  placeholder: const Text("Search tasks"),
                  features: [
                    InputFeature.leading(
                      StatedWidget.builder(
                        builder: (context, states) {
                          if (states.hovered) {
                            return const Icon(Icons.search);
                          } else {
                            return const Icon(
                              Icons.search,
                            ).iconMutedForeground();
                          }
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
              const Spacer(),
            ],
          ),
        ),
        const Divider(),
      ],
      child: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: SortableLayer(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (int colIndex = 0; colIndex < board.length; colIndex++)
                Sortable(
                  data: SortableData(board[colIndex]),
                  onAcceptLeft: (value) {
                    setState(() {
                      boardNotifier.moveColumn(
                        board.indexOf(value.data),
                        colIndex,
                      );
                    });
                  },
                  onAcceptRight: (value) {
                    setState(() {
                      boardNotifier.moveColumn(
                        board.indexOf(value.data),
                        colIndex + 1,
                      );
                    });
                  },
                  child: KanbanColumn(
                    column: board[colIndex],
                    columnIndex: colIndex,
                  ),
                ),
              const EmptyKanbanColumn(),
            ],
          ).gap(16),
        ),
      ),
    );
  }
}

class KanbanColumn extends ConsumerStatefulWidget {
  final ColumnData column;
  final int columnIndex;

  const KanbanColumn({
    super.key,
    required this.column,
    required this.columnIndex,
  });

  @override
  ConsumerState<KanbanColumn> createState() => _KanbanColumnState();
}

class _KanbanColumnState extends ConsumerState<KanbanColumn> {
  @override
  Widget build(BuildContext context) {
    final board = ref.watch(boardProvider);
    final boardNotifier = ref.read(boardProvider.notifier);

    return Container(
      width: 360,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: widget.column.color, width: 4)),
        color: widget.column.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: SortableDropFallback<ColumnData>(
        onAccept: (value) {
          setState(() {
            boardNotifier.moveColumn(
              board.indexOf(value.data),
              widget.columnIndex,
            );
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Optional column header
            Row(
              children: [
                const SortableDragHandle(
                  child: Icon(LucideIcons.gripVertical, size: 16),
                ),
                const SizedBox(width: 8),
                Text(widget.column.title).semiBold,
                const Spacer(),
                // Column actions
                Builder(
                  builder: (BuildContext context) {
                    return IconButton.ghost(
                      onPressed: () {
                        showDropdown(
                          context: context,
                          builder: (BuildContext context) {
                            return DropdownMenu(
                              children: [
                                const MenuLabel(child: Text("Actions")),
                                const MenuDivider(),
                                MenuButton(
                                  onPressed: (_) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return KanbanItemDialog(
                                          isNewTask: true,
                                          columnIndex: widget.columnIndex,
                                        );
                                      },
                                    );
                                  },
                                  child: const Text("Add Task"),
                                ),
                                MenuButton(
                                  onPressed: (_) {},
                                  child: const Text("Edit Column"),
                                ),
                                const MenuDivider(),
                                MenuButton(
                                  onPressed: (_) {},
                                  child: const Text("Delete Column"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(LucideIcons.settings, size: 16),
                    );
                  },
                ),
              ],
            ),

            // Items
            Expanded(
              child: SortableDropFallback<TaskItem>(
                onAccept: (value) {
                  // Drop at the end of the column
                  boardNotifier.moveTask(
                    task: value.data,
                    targetColumn: widget.columnIndex,
                    targetIndex: widget.column.items.length,
                  );
                },
                child: SortableLayer(
                  child: Column(
                    children: [
                      for (int i = 0; i < widget.column.items.length; i++)
                        Sortable(
                          key: ValueKey(widget.column.items[i]),
                          data: widget.column.items[i],
                          onAcceptTop: (value) {
                            setState(() {
                              boardNotifier.moveTask(
                                task: value.data,
                                targetColumn: widget.columnIndex,
                                targetIndex: i,
                              );
                            });
                          },
                          onAcceptBottom: (value) {
                            setState(() {
                              boardNotifier.moveTask(
                                task: value.data,
                                targetColumn: widget.columnIndex,
                                targetIndex: i + 1,
                              );
                            });
                          },
                          child: KanbanColumnItem(
                            key: ValueKey(widget.column.items[i].data.id),
                            task: widget.column.items[i].data,
                            columnIndex: widget.columnIndex,
                            itemIndex: i,
                          ),
                        ),
                    ],
                  ).gap(16),
                ),
              ),
            ),
          ],
        ).gap(16),
      ),
    );
  }
}

class KanbanColumnItem extends ConsumerStatefulWidget {
  final TaskItem task;
  final int columnIndex;
  final int itemIndex;

  const KanbanColumnItem({
    super.key,
    required this.task,
    required this.columnIndex,
    required this.itemIndex,
  });

  @override
  ConsumerState<KanbanColumnItem> createState() => _KanbanColumnItemState();
}

class _KanbanColumnItemState extends ConsumerState<KanbanColumnItem> {
  @override
  Widget build(BuildContext context) {
    final boardNotifier = ref.read(boardProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: widget.task.color, width: 4)),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SortableDragHandle(
                child: Icon(LucideIcons.gripVertical, size: 16),
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(widget.task.title).semiBold.small),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _getPriorityColor(widget.task.priority),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(widget.task.priority).xSmall.bold,
              ),
              Builder(
                builder: (BuildContext context) {
                  return IconButton.ghost(
                    onPressed: () {
                      showDropdown(
                        context: context,
                        builder: (BuildContext context) {
                          return DropdownMenu(
                            children: [
                              const MenuLabel(child: Text("Actions")),
                              const MenuDivider(),
                              MenuButton(
                                onPressed: (_) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return KanbanItemDialog(
                                        task: widget.task,
                                        columnIndex: widget.columnIndex,
                                        itemIndex: widget.itemIndex,
                                      );
                                    },
                                  );
                                },
                                child: const Text("Edit"),
                              ),
                              const MenuDivider(),
                              MenuButton(
                                onPressed: (_) {
                                  boardNotifier.deleteTask(widget.task.id);
                                },
                                child: const Text("Delete"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(LucideIcons.settings, size: 16),
                  );
                },
              ),
            ],
          ),

          Text(widget.task.description).muted.xSmall,
        ],
      ).gap(16),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case "high":
        return Colors.red.shade100;
      case "medium":
        return Colors.orange.shade100;
      case "low":
        return Colors.gray.shade100;
      default:
        return Colors.gray.shade100;
    }
  }
}

class KanbanItemDialog extends ConsumerStatefulWidget {
  final TaskItem? task;
  final bool isNewTask;
  final int? columnIndex;
  final int? itemIndex;

  const KanbanItemDialog({
    super.key,
    this.task,
    this.isNewTask = false,
    this.columnIndex,
    this.itemIndex,
  });

  @override
  ConsumerState<KanbanItemDialog> createState() => _KanbanItemDialogState();
}

class _KanbanItemDialogState extends ConsumerState<KanbanItemDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String _selectedPriority;
  late ColorDerivative _selectedColor;

  final List<String> _priorities = ["High", "Medium", "Low"];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? "");
    _descriptionController = TextEditingController(
      text: widget.task?.description ?? "",
    );
    _selectedPriority = widget.task?.priority ?? "Medium";
    _selectedColor = ColorDerivative.fromColor(
      widget.task?.color ?? Colors.blue,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final boardNotifier = ref.read(boardProvider.notifier);

    return AlertDialog(
      title: widget.isNewTask ? Text("Create New Task") : Text("Edit Task"),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.isNewTask)
                  const Text("Add a new task to your board")
                else
                  const Text("Edit a task on your board"),

                FormField(
                  key: FormKey(#title),
                  label: const Text("Title"),
                  child: TextField(
                    controller: _titleController,
                    placeholder: const Text("Enter task title"),
                  ),
                ),

                FormField(
                  key: FormKey(#description),
                  label: const Text("Description"),
                  child: TextArea(
                    controller: _descriptionController,
                    placeholder: const Text(
                      "Enter task description (optional)",
                    ),
                    expandableHeight: true,
                    initialHeight: 75,
                  ),
                ),

                FormField(
                  key: FormKey(#priority),
                  label: const Text("Priority"),
                  child: Select<String>(
                    itemBuilder: (context, item) {
                      return Text(item);
                    },
                    popupConstraints: const BoxConstraints(
                      maxHeight: 300,
                      maxWidth: 200,
                    ),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedPriority = newValue;
                        });
                      }
                    },
                    popup: SelectPopup(
                      items: SelectItemList(
                        children: _priorities.map<SelectItemButton<String>>((
                          String value,
                        ) {
                          return SelectItemButton(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ).call,
                  ),
                ),

                FormField(
                  key: FormKey(#color),
                  label: const Text("Color"),
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: ColorInput(
                      value: _selectedColor,
                      orientation: Axis.horizontal,
                      promptMode: PromptMode.popover,
                      onChanged: (value) {
                        setState(() {
                          _selectedColor = value;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ).gap(16),
          ),
        ],
      ).gap(16),
      actions: [
        SecondaryButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        PrimaryButton(
          onPressed: () {
            if (_titleController.text.isNotEmpty) {
              final task = TaskItem(
                id: widget.task?.id ?? DateTime.now().toString(),
                title: _titleController.text,
                description: _descriptionController.text,
                color: _selectedColor.toColor(),
                priority: _selectedPriority,
              );

              if (widget.isNewTask && widget.columnIndex != null) {
                boardNotifier.addTask(widget.columnIndex!, task);
              } else if (!widget.isNewTask) {
                // For edit, delete and add or update in place
                boardNotifier.deleteTask(widget.task!.id);
                if (widget.columnIndex != null) {
                  boardNotifier.addTask(widget.columnIndex!, task);
                }
              }

              Navigator.pop(context);
            }
          },
          child: widget.isNewTask
              ? const Text("Create Task")
              : const Text("Update"),
        ),
      ],
    );
  }
}

class EmptyKanbanColumn extends ConsumerStatefulWidget {
  const EmptyKanbanColumn({super.key});

  @override
  ConsumerState<EmptyKanbanColumn> createState() => _EmptyKanbanColumnState();
}

class _EmptyKanbanColumnState extends ConsumerState<EmptyKanbanColumn> {
  final TextEditingController _titleController = TextEditingController();
  ColorDerivative _selectedColor = ColorDerivative.fromColor(Colors.blue);

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final boardNotifier = ref.read(boardProvider.notifier);

    return SizedBox(
      width: 360,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.gray.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PrimaryButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Add New Column"),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 320),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                FormField(
                                  key: FormKey(#title),
                                  label: const Text("Title"),
                                  child: TextField(
                                    controller: _titleController,
                                    placeholder: const Text("Column title"),
                                  ),
                                ),

                                FormField(
                                  key: FormKey(#color),
                                  label: const Text("Color"),
                                  child: SizedBox(
                                    width: 32,
                                    height: 32,
                                    child: ColorInput(
                                      value: _selectedColor,
                                      orientation: Axis.horizontal,
                                      promptMode: PromptMode.popover,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedColor = value;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ).gap(16),
                          ),
                        ],
                      ),
                      actions: [
                        SecondaryButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"),
                        ),
                        PrimaryButton(
                          onPressed: () {
                            if (_titleController.text.isNotEmpty) {
                              final newColumn = ColumnData(
                                id: DateTime.now().toString(),
                                title: _titleController.text,
                                color: _selectedColor.toColor(),
                                items: [],
                              );

                              boardNotifier.addColumn(newColumn);
                              _titleController.clear();
                              Navigator.pop(context);
                            }
                          },
                          child: const Text("Create Column"),
                        ),
                      ],
                    );
                  },
                );
              },
              alignment: Alignment.center,
              child: const Text("Add New Column"),
            ),
          ],
        ).gap(16),
      ),
    );
  }
}

class ColumnData {
  final String id;
  String title;
  Color color;
  List<SortableData<TaskItem>> items;

  ColumnData({
    required this.id,
    required this.title,
    required this.color,
    required this.items,
  });

  ColumnData copyWith({
    String? title,
    Color? color,
    List<SortableData<TaskItem>>? items,
  }) {
    return ColumnData(
      id: id,
      title: title ?? this.title,
      color: color ?? this.color,
      items: items ?? this.items,
    );
  }
}

class TaskItem {
  final String id;
  String title;
  String description;
  Color color;
  String priority;

  TaskItem({
    required this.id,
    required this.title,
    required this.description,
    required this.color,
    required this.priority,
  });

  TaskItem copyWith({
    String? title,
    String? description,
    Color? color,
    String? priority,
  }) {
    return TaskItem(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      color: color ?? this.color,
      priority: priority ?? this.priority,
    );
  }
}

final boardProvider = NotifierProvider<BoardNotifier, List<ColumnData>>(
  BoardNotifier.new,
);

final initialBoard = [
  ColumnData(
    id: "backlog",
    title: "Backlog",
    color: Colors.red,
    items: [
      SortableData(
        TaskItem(
          id: "task1",
          title: "Integrate Stripe payment gateway",
          description:
              "Compile competitor landing page designs for inspiration.",
          color: Colors.red,
          priority: "High",
        ),
      ),
      SortableData(
        TaskItem(
          id: "task2",
          title: "Redesign marketing homepage",
          description:
              "Compile competitor landing page designs for inspiration.",
          color: Colors.red,
          priority: "Medium",
        ),
      ),
      SortableData(
        TaskItem(
          id: "task3",
          title: "Set up automated backups",
          description:
              "Compile competitor landing page designs for inspiration.",
          color: Colors.red,
          priority: "Low",
        ),
      ),
      SortableData(
        TaskItem(
          id: "task4",
          title: "Implement blog search functionality",
          description:
              "Compile competitor landing page designs for inspiration.",
          color: Colors.red,
          priority: "Medium",
        ),
      ),
    ],
  ),
  ColumnData(
    id: "inprogress",
    title: "In Progress",
    color: Colors.yellow,
    items: [
      SortableData(
        TaskItem(
          id: "task5",
          title: "Dark mode toggle implementation",
          description:
              "Compile competitor landing page designs for inspiration.",
          color: Colors.yellow,
          priority: "High",
        ),
      ),
      SortableData(
        TaskItem(
          id: "task6",
          title: "Databse schema refactoring",
          description:
              "Compile competitor landing page designs for inspiration.",
          color: Colors.yellow,
          priority: "Medium",
        ),
      ),
      SortableData(
        TaskItem(
          id: "task7",
          title: "Accessibility improvements",
          description:
              "Compile competitor landing page designs for inspiration.",
          color: Colors.yellow,
          priority: "Low",
        ),
      ),
    ],
  ),
  ColumnData(
    id: "done",
    title: "Done",
    color: Colors.green,
    items: [
      SortableData(
        TaskItem(
          id: "task8",
          title: "Set up CI/CD pipeline",
          description:
              "Compile competitor landing page designs for inspiration.",
          color: Colors.green,
          priority: "High",
        ),
      ),
      SortableData(
        TaskItem(
          id: "task9",
          title: "Initial project setup",
          description:
              "Compile competitor landing page designs for inspiration.",
          color: Colors.green,
          priority: "Medium",
        ),
      ),
    ],
  ),
];

class BoardNotifier extends Notifier<List<ColumnData>> {
  @override
  List<ColumnData> build() {
    return initialBoard;
  }

  // Column operations
  void moveColumn(int fromIndex, int toIndex) {
    final newState = [...state];
    final column = newState.removeAt(fromIndex);

    newState.insert(toIndex, column);

    state = newState;
  }

  void addColumn(ColumnData column) {
    state = [...state, column];
  }

  void updateColumn(int index, ColumnData column) {
    final newState = [...state];

    newState[index] = column;

    state = newState;
  }

  void deleteColumn(int index) {
    final newState = [...state];

    newState.removeAt(index);

    state = newState;
  }

  // Task operations
  void moveTask({
    required TaskItem task,
    required int targetColumn,
    required int targetIndex,
  }) {
    final newState = [...state];

    for (final column in newState) {
      column.items.removeWhere((i) => i.data.id == task.id);
    }

    newState[targetColumn].items.insert(targetIndex, SortableData(task));

    state = newState;
  }

  void addTask(int columnIndex, TaskItem task) {
    final newState = [...state];

    newState[columnIndex].items.add(SortableData(task));

    state = newState;
  }

  void updateTask(int columnIndex, int itemIndex, TaskItem task) {
    final newState = [...state];

    newState[columnIndex].items[itemIndex] = SortableData(task);

    state = newState;
  }

  void deleteTask(String taskId) {
    final newState = [...state];

    for (final column in newState) {
      column.items.removeWhere((i) => i.data.id == taskId);
    }

    state = newState;
  }
}
