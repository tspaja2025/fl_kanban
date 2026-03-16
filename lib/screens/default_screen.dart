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
  // List of columns, each containing a list of items
  List<SortableData<ColumnData>> columns = [
    SortableData(
      ColumnData(
        id: "backlog",
        title: "Backlog",
        color: Colors.red,
        items: [
          TaskItem(
            id: "task1",
            title: "Integrate Stripe payment gateway",
            description:
                "Compile competitor landing page designs for inspiration.",
            color: Colors.red,
            priority: "High",
          ),
          TaskItem(
            id: "task2",
            title: "Redesign marketing homepage",
            description:
                "Compile competitor landing page designs for inspiration.",
            color: Colors.red,
            priority: "Medium",
          ),
          TaskItem(
            id: "task3",
            title: "Set up automated backups",
            description:
                "Compile competitor landing page designs for inspiration.",
            color: Colors.red,
            priority: "Low",
          ),
          TaskItem(
            id: "task4",
            title: "Implement blog search functionality",
            description:
                "Compile competitor landing page designs for inspiration.",
            color: Colors.red,
            priority: "Medium",
          ),
        ],
      ),
    ),
    SortableData(
      ColumnData(
        id: "inprogress",
        title: "In Progress",
        color: Colors.yellow,
        items: [
          TaskItem(
            id: "task5",
            title: "Dark mode toggle implementation",
            description:
                "Compile competitor landing page designs for inspiration.",
            color: Colors.yellow,
            priority: "High",
          ),
          TaskItem(
            id: "task6",
            title: "Databse schema refactoring",
            description:
                "Compile competitor landing page designs for inspiration.",
            color: Colors.yellow,
            priority: "Medium",
          ),
          TaskItem(
            id: "task7",
            title: "Accessibility improvements",
            description:
                "Compile competitor landing page designs for inspiration.",
            color: Colors.yellow,
            priority: "Low",
          ),
        ],
      ),
    ),
    SortableData(
      ColumnData(
        id: "done",
        title: "Done",
        color: Colors.green,
        items: [
          TaskItem(
            id: "task8",
            title: "Set up CI/CD pipeline",
            description:
                "Compile competitor landing page designs for inspiration.",
            color: Colors.green,
            priority: "High",
          ),
          TaskItem(
            id: "task9",
            title: "Initial project setup",
            description:
                "Compile competitor landing page designs for inspiration.",
            color: Colors.green,
            priority: "Medium",
          ),
        ],
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
              for (int colIndex = 0; colIndex < columns.length; colIndex++)
                Sortable(
                  data: columns[colIndex],
                  onAcceptLeft: (value) {
                    setState(() {
                      _moveColumn(value, colIndex);
                    });
                  },
                  onAcceptRight: (value) {
                    setState(() {
                      _moveColumn(value, colIndex + 1);
                    });
                  },
                  child: KanbanColumn(
                    columns: columns,
                    title: columns[colIndex].data.title,
                    items: columns[colIndex].data.items,
                    columnIndex: colIndex,
                    color: columns[colIndex].data.color,
                  ),
                ),
              EmptyKanbanColumn(),
            ],
          ).gap(16),
        ),
      ),
    );
  }

  void _moveColumn(SortableData<ColumnData> column, int targetIndex) {
    columns.remove(column);
    columns.insert(targetIndex, column);
  }
}

class KanbanColumn extends ConsumerStatefulWidget {
  final List<SortableData<ColumnData>> columns;
  final String title;
  final List<TaskItem> items;
  final int columnIndex;
  final Color color;

  const KanbanColumn({
    super.key,
    required this.columns,
    required this.title,
    required this.items,
    required this.columnIndex,
    required this.color,
  });

  @override
  ConsumerState<KanbanColumn> createState() => _KanbanColumnState();
}

class _KanbanColumnState extends ConsumerState<KanbanColumn> {
  void _moveItem(
    TaskItem item,
    List<TaskItem> targetColumn,
    int targetIndex,
    int targetColumnIndex,
  ) {
    // Find and remove from source column
    for (var column in widget.columns) {
      if (column.data.items.contains(item)) {
        column.data.items.remove(item);
        break;
      }
    }

    // Insert into target column at specified index
    targetColumn.insert(targetIndex, item);
  }

  void _moveColumn(SortableData<ColumnData> column, int targetIndex) {
    widget.columns.remove(column);
    widget.columns.insert(targetIndex, column);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: widget.color, width: 4)),
        color: widget.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: SortableDropFallback<ColumnData>(
        onAccept: (value) {
          setState(() {
            _moveColumn(value, widget.columnIndex);
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
                Text(widget.title).semiBold,
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
                                        );
                                      },
                                    );
                                  },
                                  child: const Text("Edit"),
                                ),
                                const MenuDivider(),
                                MenuButton(
                                  onPressed: (_) {},
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

            // Items
            SortableLayer(
              child: Column(
                children: [
                  for (int i = 0; i < widget.items.length; i++)
                    Sortable(
                      key: ValueKey(widget.items[i].id),
                      data: SortableData(widget.items[i]),
                      onAcceptTop: (value) {
                        setState(() {
                          _moveItem(
                            value.data,
                            widget.items,
                            i,
                            widget.columnIndex,
                          );
                        });
                      },
                      onAcceptBottom: (value) {
                        setState(() {
                          _moveItem(
                            value.data,
                            widget.items,
                            i + 1,
                            widget.columnIndex,
                          );
                        });
                      },
                      child: KanbanColumnItem(
                        title: widget.items[i].title,
                        description: widget.items[i].description,
                        color: widget.items[i].color,
                      ),
                    ),
                ],
              ).gap(16),
            ),
          ],
        ).gap(16),
      ),
    );
  }
}

class KanbanColumnItem extends ConsumerStatefulWidget {
  final String title;
  final String description;
  final Color color;

  const KanbanColumnItem({
    super.key,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  ConsumerState<KanbanColumnItem> createState() => _KanbanColumnItemState();
}

class _KanbanColumnItemState extends ConsumerState<KanbanColumnItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: widget.color, width: 4)),
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
              Expanded(child: Text(widget.title).semiBold.small),
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
                                      return KanbanItemDialog();
                                    },
                                  );
                                },
                                child: const Text("Edit"),
                              ),
                              const MenuDivider(),
                              MenuButton(
                                onPressed: (_) {},
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

          Text(widget.description).muted.xSmall,
        ],
      ).gap(16),
    );
  }
}

class KanbanItemDialog extends StatelessWidget {
  final bool isNewTask;

  const KanbanItemDialog({super.key, this.isNewTask = false});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: isNewTask ? Text("Create New Task") : Text("Edit Task"),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isNewTask)
                  const Text("Add a new task to your board")
                else
                  const Text("Edit a task on your board"),

                FormField(
                  key: FormKey(#title),
                  label: const Text("Title"),
                  child: TextField(placeholder: const Text("Enter task title")),
                ),

                FormField(
                  key: FormKey(#description),
                  label: const Text("Description"),
                  child: TextArea(
                    placeholder: const Text(
                      "Enter task description (optional)",
                    ),
                    expandableHeight: true,
                    initialHeight: 75,
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
            Navigator.pop(context);
          },
          child: isNewTask ? Text("Create Task") : Text("Update"),
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
  ColorDerivative colorValue = ColorDerivative.fromColor(Colors.blue);

  @override
  Widget build(BuildContext context) {
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
                                      value: colorValue,
                                      orientation: Axis.horizontal,
                                      promptMode: PromptMode.dialog,
                                      onChanged: (value) {
                                        setState(() {
                                          colorValue = value;
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
                            Navigator.pop(context);
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
  List<TaskItem> items;

  ColumnData({
    required this.id,
    required this.title,
    required this.color,
    required this.items,
  });
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
}
