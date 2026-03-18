// import 'package:fl_kanban/screens/default_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

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
  List<BoardColumn> board = [
    BoardColumn(
      column: ColumnData(id: 1, title: "Backlog", color: Colors.red),
      items: [
        SortableData(
          TaskItem(
            id: 1,
            title: "Integrate Stripe payment gateway",
            description:
                "Compile competitor landing page designs for inspiration.",
            color: Colors.red,
            priority: "High",
          ),
        ),
        SortableData(
          TaskItem(
            id: 2,
            title: "Redesign marketing homepage",
            description:
                "Compile competitor landing page designs for inspiration.",
            color: Colors.red,
            priority: "Medium",
          ),
        ),
        SortableData(
          TaskItem(
            id: 3,
            title: "Set up automated backups",
            description:
                "Compile competitor landing page designs for inspiration.",
            color: Colors.red,
            priority: "Low",
          ),
        ),
        SortableData(
          TaskItem(
            id: 4,
            title: "Implement blog search functionality",
            description:
                "Compile competitor landing page designs for inspiration.",
            color: Colors.red,
            priority: "Medium",
          ),
        ),
      ],
    ),
    BoardColumn(
      column: ColumnData(id: 2, title: "In Progress", color: Colors.orange),
      items: [
        SortableData(
          TaskItem(
            id: 5,
            title: "Dark mode toggle implementation",
            description:
                "Compile competitor landing page designs for inspiration.",
            color: Colors.yellow,
            priority: "High",
          ),
        ),
        SortableData(
          TaskItem(
            id: 6,
            title: "Database schema refactoring",
            description:
                "Compile competitor landing page designs for inspiration.",
            color: Colors.yellow,
            priority: "Medium",
          ),
        ),
        SortableData(
          TaskItem(
            id: 7,
            title: "Accessibility improvements",
            description:
                "Compile competitor landing page designs for inspiration.",
            color: Colors.yellow,
            priority: "Low",
          ),
        ),
      ],
    ),
    BoardColumn(
      column: ColumnData(id: 3, title: "Done", color: Colors.green),
      items: [
        SortableData(
          TaskItem(
            id: 8,
            title: "Set up CI/CD pipeline",
            description:
                "Compile competitor landing page designs for inspiration.",
            color: Colors.green,
            priority: "High",
          ),
        ),
        SortableData(
          TaskItem(
            id: 9,
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
          lock: true,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (int colIndex = 0; colIndex < board.length; colIndex++)
                Sortable<int>(
                  key: ValueKey(board[colIndex].column.id),
                  data: SortableData(board[colIndex].column.id),

                  // move column left
                  onAcceptLeft: (value) {
                    setState(() {
                      moveColumn(value.data, colIndex);
                    });
                  },

                  // move column right
                  onAcceptRight: (value) {
                    setState(() {
                      moveColumn(value.data, colIndex + 1);
                    });
                  },

                  child: buildColumn(colIndex),
                ),
            ],
          ).gap(16),
        ),
      ),
    );
  }

  Widget buildColumn(int colIndex) {
    final column = board[colIndex];

    return Container(
      width: 360,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: column.column.color, width: 4)),
        color: column.column.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: SortableDropFallback<TaskItem>(
        onAccept: (value) {
          setState(() {
            moveTask(value, colIndex, column.items.length);
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SortableDragHandle(
                  child: Icon(LucideIcons.gripVertical, size: 16),
                ),
                const SizedBox(width: 8),
                Text(column.column.title).semiBold,
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

            Column(
              children: [
                for (int i = 0; i < column.items.length; i++) ...[
                  // 👇 DROP ZONE ABOVE
                  SortableDropFallback<TaskItem>(
                    onAccept: (value) {
                      setState(() {
                        moveTask(value, colIndex, i);
                      });
                    },
                    child: const SizedBox(height: 8),
                  ),

                  // 👇 ACTUAL ITEM
                  Sortable<TaskItem>(
                    key: ValueKey(column.items[i].data.id),
                    data: column.items[i],
                    child: buildTask(column.items[i].data),
                  ),
                ],

                // 👇 DROP ZONE AT END
                SortableDropFallback<TaskItem>(
                  onAccept: (value) {
                    setState(() {
                      moveTask(value, colIndex, column.items.length);
                    });
                  },
                  child: const SizedBox(height: 20),
                ),
              ],
            ),

            // SortableDropFallback<TaskItem>(
            //   onAccept: (value) {
            //     print('SortableDropFallback triggered fro column $colIndex');
            //     setState(() {
            //       moveTask(value, colIndex, column.items.length);
            //     });
            //   },
            //   child: Column(
            //     children: [
            //       for (int i = 0; i < column.items.length; i++)
            //         Sortable<TaskItem>(
            //           key: ValueKey(column.items[i].data.id),
            //           data: column.items[i],
            //           child: buildTask(column.items[i].data),
            //         ),
            //     ],
            //   ).gap(16),
            // ),
          ],
        ).gap(16),
      ),
    );
  }

  Widget buildTask(TaskItem task) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: task.color, width: 4)),
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
              Expanded(child: Text(task.title).semiBold.small),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _getPriorityColor(task.priority),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(task.priority).xSmall.bold,
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
                    icon: const Icon(LucideIcons.settings, size: 16),
                  );
                },
              ),
            ],
          ),
          Text(task.description),
        ],
      ),
    );
  }

  void moveTask(
    SortableData<TaskItem> value,
    int targetColumnIndex,
    int targetIndex,
  ) {
    SortableData<TaskItem>? removed;
    int? sourceColumnIndex;
    int? sourceIndex;

    print(
      'moveTask called: targetColumn=$targetColumnIndex, targetIndex=$targetIndex',
    );
    print('Moving task with id: ${value.data.id}');

    // Find the source column and remove the task
    for (int colIndex = 0; colIndex < board.length; colIndex++) {
      final col = board[colIndex];
      final index = col.items.indexWhere((e) => e.data.id == value.data.id);

      if (index != -1) {
        removed = col.items.removeAt(index);
        sourceColumnIndex = colIndex;
        sourceIndex = index;
        break;
      }
    }

    if (removed == null) return;

    final targetList = board[targetColumnIndex].items;

    // Adjust target index for same-column moves
    if (sourceColumnIndex == targetColumnIndex) {
      if (sourceIndex! < targetIndex) {
        targetIndex -= 1;
      }
    }

    // Clamp the target index to valid range
    targetIndex = targetIndex.clamp(0, targetList.length);

    // Insert at the new position
    targetList.insert(targetIndex, removed);
  }

  void moveColumn(int from, int to) {
    if (from == to) return;

    final column = board.removeAt(from);

    if (from < to) {
      to -= 1;
    }

    board.insert(to, column);
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case "high":
        return Colors.red.shade100;
      case "medium":
        return Colors.orange.shade100;
      case "low":
        return Colors.green.shade100;
      default:
        return Colors.green.shade100;
    }
  }
}

class ColumnData {
  final int id;
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
  final int id;
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

class BoardColumn {
  final ColumnData column;
  final List<SortableData<TaskItem>> items;

  BoardColumn({required this.column, required this.items});
}

// Problems:
// Can't move tasks cross-column.
// Currently debug prints fire within column not cross-column.
// onAcceptTop triggered: col=1, index=1
// moveTask called: targetColumn=1, targetIndex=1
// Moving task with id: 7
