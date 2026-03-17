// import 'package:fl_kanban/screens/default_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

// TODO:
// Column dragging
// Columns move only horizontally
// Column items move cross-column and vertically inside the column
// Move state to riverpod
// Search tasks functionality

void main() {
  runApp(ProviderScope(child: const FlKanban()));
}

class FlKanban extends StatelessWidget {
  const FlKanban({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadcnApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter Kanban",
      theme: ThemeData(colorScheme: ColorSchemes.lightNeutral),
      // darkTheme: ThemeData.dark(colorScheme: ColorSchemes.darkNeutral),
      home: const DefaultScreen(),
    );
  }
}

class DefaultScreen extends ConsumerStatefulWidget {
  const DefaultScreen({super.key});

  @override
  ConsumerState<DefaultScreen> createState() => _DefaultScreenState();
}

class _DefaultScreenState extends ConsumerState<DefaultScreen> {
  List<SortableData<ColumnData>> columns = [
    SortableData(
      ColumnData(id: "backlog", title: "Backlog", color: Colors.red),
    ),
    SortableData(
      ColumnData(id: "inProgress", title: "In Progress", color: Colors.orange),
    ),
    SortableData(ColumnData(id: "done", title: "Done", color: Colors.green)),
  ];

  Map<String, List<SortableData<TaskItem>>> items = {
    "backlog": [
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
    "inProgress": [
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
    "done": [
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
  };

  @override
  void initState() {
    super.initState();
  }

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
                Expanded(
                  child: Sortable<ColumnData>(
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
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            color: Colors.gray.shade100,
                            child: Text(columns[colIndex].data.title).bold,
                          ),

                          const SizedBox(height: 8),

                          SortableDropFallback<TaskItem>(
                            onAccept: (value) {
                              setState(() {
                                _moveItemToColumn(
                                  value,
                                  columns[colIndex].data.id,
                                  items[columns[colIndex].data.id]!.length,
                                );
                              });
                            },
                            child: Column(
                              children: [
                                for (
                                  int itemIndex = 0;
                                  itemIndex < items.length;
                                  itemIndex++
                                )
                                  Sortable<TaskItem>(
                                    data:
                                        items[columns[colIndex]
                                            .data
                                            .id]![itemIndex],
                                    onAcceptTop: (value) {
                                      setState(() {
                                        _moveItemWithinColumn(
                                          value,
                                          columns[colIndex].data.id,
                                          itemIndex,
                                        );
                                      });
                                    },
                                    onAcceptBottom: (value) {
                                      setState(() {
                                        _moveItemWithinColumn(
                                          value,
                                          columns[colIndex].data.id,
                                          itemIndex + 1,
                                        );
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 4,
                                      ),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.gray),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        "${items[columns[colIndex].data.id]![itemIndex].data}",
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              const EmptyKanbanColumn(),
            ],
          ).gap(16),
        ),
      ),
    );
  }

  void _moveColumn(SortableData<ColumnData> draggedColumn, int newIndex) {
    final oldIndex = columns.indexWhere(
      (col) => col.data.id == draggedColumn.data.id,
    );

    if (oldIndex != -1 && oldIndex != newIndex) {
      final item = columns.removeAt(oldIndex);
      columns.insert(newIndex, item);
    }
  }

  void _moveItemWithinColumn(
    SortableData<TaskItem> draggedItem,
    String targetColumnId,
    int newIndex,
  ) {
    String? sourceColumnId;
    int oldIndex = -1;

    for (var entry in items.entries) {
      final index = entry.value.indexWhere(
        (item) => item.data == draggedItem.data,
      );
      if (index != -1) {
        sourceColumnId = entry.key;
        oldIndex = index;
        break;
      }
    }

    if (sourceColumnId != null && oldIndex != -1) {
      if (sourceColumnId == targetColumnId) {
        // Same column - just reorder
        if (oldIndex != newIndex) {
          final item = items[sourceColumnId]!.removeAt(oldIndex);
          items[sourceColumnId]!.insert(newIndex, item);
        }
      } else {
        // Different column - move between columns
        final item = items[sourceColumnId]!.removeAt(oldIndex);
        items[targetColumnId]!.insert(newIndex, item);
      }
    }
  }

  void _moveItemToColumn(
    SortableData<TaskItem> draggedItem,
    String targetColumnId,
    int newIndex,
  ) {
    _moveItemWithinColumn(draggedItem, targetColumnId, newIndex);
  }
}

class KanbanColumn extends ConsumerStatefulWidget {
  final List<List<SortableData<TaskItem>>> lists;
  final List<SortableData<TaskItem>> column;
  final String title;
  final Color color;

  const KanbanColumn({
    super.key,
    required this.lists,
    required this.column,
    required this.title,
    required this.color,
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
        border: Border(top: BorderSide(color: widget.color, width: 4)),
        color: widget.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: SortableDropFallback<String>(
        onAccept: (value) {
          setState(() {
            swapItemInLists(
              [widget.lists],
              value,
              widget.column,
              widget.column.length,
            );
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                                  onPressed: (_) {},
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

            for (int i = 0; i < widget.column.length; i++)
              Sortable<TaskItem>(
                data: widget.column[i],
                onAcceptTop: (value) {
                  setState(() {
                    swapItemInLists([widget.lists], value, widget.column, i);
                  });
                },
                onAcceptBottom: (value) {
                  setState(() {
                    swapItemInLists(
                      [widget.lists],
                      value,
                      widget.column,
                      i + 1,
                    );
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      left: BorderSide(color: widget.color, width: 4),
                    ),
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
                          Expanded(
                            child: Text(
                              widget.column[i].data.title,
                            ).semiBold.small,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: widget.color,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              widget.column[i].data.priority,
                            ).xSmall.bold,
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
                                          const MenuLabel(
                                            child: Text("Actions"),
                                          ),
                                          const MenuDivider(),
                                          MenuButton(
                                            onPressed: (_) {},
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
                                icon: const Icon(
                                  LucideIcons.settings,
                                  size: 16,
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                      Text(widget.column[i].data.description).muted.xSmall,
                    ],
                  ).gap(16),
                ),
              ),
          ],
        ).gap(16),
      ),
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
                          onPressed: () {},
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

  ColumnData({required this.id, required this.title, required this.color});

  ColumnData copyWith({String? title, Color? color}) {
    return ColumnData(
      id: id,
      title: title ?? this.title,
      color: color ?? this.color,
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
