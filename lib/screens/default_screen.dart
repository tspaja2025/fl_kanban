import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

// TODO:
// Cross-column dragging
// Move state to riverpod
// Search tasks functionality

class DefaultScreen extends ConsumerStatefulWidget {
  const DefaultScreen({super.key});

  @override
  ConsumerState<DefaultScreen> createState() => _DefaultScreenState();
}

class _DefaultScreenState extends ConsumerState<DefaultScreen> {
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
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SortableLayer(
                lock: true,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (int i = 0; i < columns.length; i++)
                      Sortable(
                        key: ValueKey(i),
                        data: columns[i],
                        onAcceptLeft: (value) {
                          setState(() {
                            columns.swapItem(value, i);
                          });
                        },
                        onAcceptRight: (value) {
                          setState(() {
                            columns.swapItem(value, i + 1);
                          });
                        },
                        child: KanbanColumn(
                          title: columns[i].data.title,
                          color: columns[i].data.color,
                          items: columns[i].data.items,
                        ),
                      ),
                    EmptyKanbanColumn(),
                  ],
                ).gap(16),
              ),
            );
          },
        ),
      ),
    );
  }
}

class KanbanColumn extends ConsumerStatefulWidget {
  final String title;
  final Color color;
  final List<TaskItem> items;

  const KanbanColumn({
    super.key,
    required this.title,
    required this.color,
    required this.items,
  });

  @override
  ConsumerState<KanbanColumn> createState() => _KanbanColumnState();
}

class _KanbanColumnState extends ConsumerState<KanbanColumn> {
  ColorDerivative colorValue = ColorDerivative.fromColor(Colors.blue);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      child: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: widget.color, width: 4)),
          color: widget.color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
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
                // Column settings
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

            SortableLayer(
              child: Column(
                children: [
                  for (int i = 0; i < widget.items.length; i++)
                    Sortable(
                      key: ValueKey(widget.items[i].id),
                      data: SortableData(widget.items[i]),
                      onAcceptTop: (value) {
                        setState(() {
                          final fromIndex = widget.items.indexOf(value.data);
                          final item = widget.items.removeAt(fromIndex);
                          widget.items.insert(i, item);
                        });
                      },
                      onAcceptBottom: (value) {
                        setState(() {
                          final fromIndex = widget.items.indexOf(value.data);
                          final item = widget.items.removeAt(fromIndex);
                          widget.items.insert(i + 1, item);
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

            PrimaryButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return KanbanItemDialog(isNewTask: true);
                  },
                );
              },
              alignment: Alignment.center,
              child: const Text("Add Task"),
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
  List<AvatarWidget> getAvatars() {
    return [
      Avatar(
        initials: Avatar.getInitials("ts"),
        backgroundColor: Colors.red,
        size: 24,
      ),
      Avatar(
        initials: Avatar.getInitials("ts"),
        backgroundColor: Colors.green,
        size: 24,
      ),
      Avatar(
        initials: Avatar.getInitials("ts"),
        backgroundColor: Colors.blue,
        size: 24,
      ),
      Avatar(
        initials: Avatar.getInitials("ts"),
        backgroundColor: Colors.yellow,
        size: 24,
      ),
    ];
  }

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

          const SizedBox(height: 16),

          Text(widget.description).muted.xSmall,
        ],
      ),
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

// class DefaultScreen extends ConsumerStatefulWidget {
//   const DefaultScreen({super.key});

//   @override
//   ConsumerState<DefaultScreen> createState() => _DefaultScreenState();
// }

// class _DefaultScreenState extends ConsumerState<DefaultScreen> {
//   List<SortableData<ColumnData>> columns = [
//     SortableData(
//       ColumnData(
//         id: "backlog",
//         title: "Backlog",
//         color: Colors.red,
//         items: [
//           TaskItem(
//             id: "task1",
//             title: "Integrate Stripe payment gateway",
//             description:
//                 "Compile competitor landing page designs for inspiration.",
//             color: Colors.red,
//             priority: "High",
//           ),
//           TaskItem(
//             id: "task2",
//             title: "Redesign marketing homepage",
//             description:
//                 "Compile competitor landing page designs for inspiration.",
//             color: Colors.red,
//             priority: "Medium",
//           ),
//           TaskItem(
//             id: "task3",
//             title: "Set up automated backups",
//             description:
//                 "Compile competitor landing page designs for inspiration.",
//             color: Colors.red,
//             priority: "Low",
//           ),
//           TaskItem(
//             id: "task4",
//             title: "Implement blog search functionality",
//             description:
//                 "Compile competitor landing page designs for inspiration.",
//             color: Colors.red,
//             priority: "Medium",
//           ),
//         ],
//       ),
//     ),
//     SortableData(
//       ColumnData(
//         id: "inprogress",
//         title: "In Progress",
//         color: Colors.yellow,
//         items: [
//           TaskItem(
//             id: "task5",
//             title: "Dark mode toggle implementation",
//             description:
//                 "Compile competitor landing page designs for inspiration.",
//             color: Colors.yellow,
//             priority: "High",
//           ),
//           TaskItem(
//             id: "task6",
//             title: "Databse schema refactoring",
//             description:
//                 "Compile competitor landing page designs for inspiration.",
//             color: Colors.yellow,
//             priority: "Medium",
//           ),
//           TaskItem(
//             id: "task7",
//             title: "Accessibility improvements",
//             description:
//                 "Compile competitor landing page designs for inspiration.",
//             color: Colors.yellow,
//             priority: "Low",
//           ),
//         ],
//       ),
//     ),
//     SortableData(
//       ColumnData(
//         id: "done",
//         title: "Done",
//         color: Colors.green,
//         items: [
//           TaskItem(
//             id: "task8",
//             title: "Set up CI/CD pipeline",
//             description:
//                 "Compile competitor landing page designs for inspiration.",
//             color: Colors.green,
//             priority: "High",
//           ),
//           TaskItem(
//             id: "task9",
//             title: "Initial project setup",
//             description:
//                 "Compile competitor landing page designs for inspiration.",
//             color: Colors.green,
//             priority: "Medium",
//           ),
//         ],
//       ),
//     ),
//   ];

//   List<List<TaskItem>> get allLists =>
//       columns.map((c) => c.data.items).toList();

//   void moveTask(TaskItem item, int toColumn, int index) {
//     setState(() {
//       for (final column in columns) {
//         column.data.items.remove(item);
//       }

//       columns[toColumn].data.items.insert(index, item);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       headers: [
//         AppBar(
//           backgroundColor: Theme.of(context).colorScheme.primaryForeground,
//           child: Row(
//             children: [
//               const Spacer(),
//               Expanded(
//                 child: TextField(
//                   placeholder: const Text("Search tasks"),
//                   features: [
//                     InputFeature.leading(
//                       StatedWidget.builder(
//                         builder: (context, states) {
//                           if (states.hovered) {
//                             return const Icon(Icons.search);
//                           } else {
//                             return const Icon(
//                               Icons.search,
//                             ).iconMutedForeground();
//                           }
//                         },
//                       ),
//                       visibility: InputFeatureVisibility.textEmpty,
//                     ),
//                     InputFeature.clear(
//                       visibility:
//                           (InputFeatureVisibility.textNotEmpty &
//                               InputFeatureVisibility.focused) |
//                           InputFeatureVisibility.hovered,
//                     ),
//                   ],
//                 ),
//               ),
//               const Spacer(),
//             ],
//           ),
//         ),
//         const Divider(),
//       ],
//       child: SafeArea(
//         minimum: const EdgeInsets.all(16),
//         child: LayoutBuilder(
//           builder: (BuildContext context, BoxConstraints constraints) {
//             return SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: SortableLayer(
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     for (int i = 0; i < columns.length; i++)
//                       Sortable(
//                         key: ValueKey("column_${columns[i].data.id}"),
//                         data: columns[i],
//                         onAcceptLeft: (value) {
//                           setState(() {
//                             columns.swapItem(value, i);
//                           });
//                         },
//                         onAcceptRight: (value) {
//                           setState(() {
//                             columns.swapItem(value, i + 1);
//                           });
//                         },
//                         child: KanbanColumn(
//                           title: columns[i].data.title,
//                           color: columns[i].data.color,
//                           items: columns[i].data.items,
//                           allLists: allLists,
//                           columnIndex: i,
//                           onItemsReordered: (newItems) {
//                             setState(() {
//                               columns[i].data.items = newItems;
//                             });
//                           },
//                           onItemDropped: moveTask,
//                         ),
//                       ),
//                     EmptyKanbanColumn(),
//                   ],
//                 ).gap(16),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// class KanbanColumn extends ConsumerStatefulWidget {
//   final String title;
//   final Color color;
//   final List<TaskItem> items;
//   final List<List<TaskItem>> allLists;
//   final int columnIndex;
//   final ValueChanged<List<TaskItem>> onItemsReordered;
//   final Function(TaskItem item, int toColumn, int index) onItemDropped;

//   const KanbanColumn({
//     super.key,
//     required this.title,
//     required this.color,
//     required this.items,
//     required this.allLists,
//     required this.columnIndex,
//     required this.onItemsReordered,
//     required this.onItemDropped,
//   });

//   @override
//   ConsumerState<KanbanColumn> createState() => _KanbanColumnState();
// }

// class _KanbanColumnState extends ConsumerState<KanbanColumn> {
//   ColorDerivative colorValue = ColorDerivative.fromColor(Colors.blue);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 360,
//       child: Container(
//         decoration: BoxDecoration(
//           border: Border(top: BorderSide(color: widget.color, width: 4)),
//           color: widget.color.withValues(alpha: 0.1),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Row(
//               children: [
//                 const SortableDragHandle(
//                   child: Icon(LucideIcons.gripVertical, size: 16),
//                 ),
//                 const SizedBox(width: 8),
//                 Text(widget.title).semiBold,
//                 const Spacer(),
//                 // Column settings
//                 Builder(
//                   builder: (BuildContext context) {
//                     return IconButton.ghost(
//                       onPressed: () {
//                         showDropdown(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return DropdownMenu(
//                               children: [
//                                 const MenuLabel(child: Text("Actions")),
//                                 const MenuDivider(),
//                                 MenuButton(
//                                   onPressed: (_) {
//                                     showDialog(
//                                       context: context,
//                                       builder: (BuildContext context) {
//                                         return KanbanItemDialog(
//                                           isNewTask: true,
//                                         );
//                                       },
//                                     );
//                                   },
//                                   child: const Text("Edit"),
//                                 ),
//                                 const MenuDivider(),
//                                 MenuButton(
//                                   onPressed: (_) {},
//                                   child: const Text("Delete"),
//                                 ),
//                               ],
//                             );
//                           },
//                         );
//                       },
//                       icon: const Icon(LucideIcons.settings, size: 16),
//                     );
//                   },
//                 ),
//               ],
//             ),

//             Column(
//               children: [
//                 for (int i = 0; i < widget.items.length; i++)
//                   Sortable(
//                     key: ValueKey(widget.items[i].id),
//                     data: SortableData(widget.items[i]),
//                     onAcceptTop: (value) {
//                       final item = value.data;

//                       if (widget.items.contains(item)) {
//                         final newItems = List<TaskItem>.from(widget.items);
//                         newItems.remove(item);
//                         newItems.insert(i, item);
//                         widget.onItemsReordered(newItems);
//                       } else {
//                         widget.onItemDropped(item, widget.columnIndex, i);
//                       }
//                     },
//                     onAcceptBottom: (value) {
//                       final item = value.data;

//                       if (widget.items.contains(item)) {
//                         final newItems = List<TaskItem>.from(widget.items);
//                         newItems.remove(item);
//                         newItems.insert(i, item);
//                         widget.onItemsReordered(newItems);
//                       } else {
//                         widget.onItemDropped(item, widget.columnIndex, i + 1);
//                       }
//                     },
//                     child: KanbanColumnItem(
//                       title: widget.items[i].title,
//                       description: widget.items[i].description,
//                       color: widget.items[i].color,
//                     ),
//                   ),
//               ],
//             ).gap(16),

//             PrimaryButton(
//               onPressed: () {
//                 showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return KanbanItemDialog(isNewTask: true);
//                   },
//                 );
//               },
//               alignment: Alignment.center,
//               child: const Text("Add Task"),
//             ),
//           ],
//         ).gap(16),
//       ),
//     );
//   }
// }

// class EmptyKanbanColumn extends ConsumerStatefulWidget {
//   const EmptyKanbanColumn({super.key});

//   @override
//   ConsumerState<EmptyKanbanColumn> createState() => _EmptyKanbanColumnState();
// }

// class _EmptyKanbanColumnState extends ConsumerState<EmptyKanbanColumn> {
//   ColorDerivative colorValue = ColorDerivative.fromColor(Colors.blue);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 360,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.gray.shade100,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             PrimaryButton(
//               onPressed: () {
//                 showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return AlertDialog(
//                       title: const Text("Add New Column"),
//                       content: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           ConstrainedBox(
//                             constraints: const BoxConstraints(maxWidth: 320),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.stretch,
//                               children: [
//                                 FormField(
//                                   key: FormKey(#title),
//                                   label: const Text("Title"),
//                                   child: TextField(
//                                     placeholder: const Text("Column title"),
//                                   ),
//                                 ),

//                                 FormField(
//                                   key: FormKey(#color),
//                                   label: const Text("Color"),
//                                   child: SizedBox(
//                                     width: 32,
//                                     height: 32,
//                                     child: ColorInput(
//                                       value: colorValue,
//                                       orientation: Axis.horizontal,
//                                       promptMode: PromptMode.dialog,
//                                       onChanged: (value) {
//                                         setState(() {
//                                           colorValue = value;
//                                         });
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ).gap(16),
//                           ),
//                         ],
//                       ),
//                       actions: [
//                         SecondaryButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                           child: const Text("Cancel"),
//                         ),
//                         PrimaryButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                           child: const Text("Create Column"),
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               },
//               alignment: Alignment.center,
//               child: const Text("Add New Column"),
//             ),
//           ],
//         ).gap(16),
//       ),
//     );
//   }
// }

// class KanbanColumnItem extends ConsumerStatefulWidget {
//   final String title;
//   final String description;
//   final Color color;

//   const KanbanColumnItem({
//     super.key,
//     required this.title,
//     required this.description,
//     required this.color,
//   });

//   @override
//   ConsumerState<KanbanColumnItem> createState() => _KanbanColumnItemState();
// }

// class _KanbanColumnItemState extends ConsumerState<KanbanColumnItem> {
//   List<AvatarWidget> getAvatars() {
//     return [
//       Avatar(
//         initials: Avatar.getInitials("ts"),
//         backgroundColor: Colors.red,
//         size: 24,
//       ),
//       Avatar(
//         initials: Avatar.getInitials("ts"),
//         backgroundColor: Colors.green,
//         size: 24,
//       ),
//       Avatar(
//         initials: Avatar.getInitials("ts"),
//         backgroundColor: Colors.blue,
//         size: 24,
//       ),
//       Avatar(
//         initials: Avatar.getInitials("ts"),
//         backgroundColor: Colors.yellow,
//         size: 24,
//       ),
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border(left: BorderSide(color: widget.color, width: 4)),
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.1),
//             blurRadius: 2,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.all(8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               const SortableDragHandle(
//                 child: Icon(LucideIcons.gripVertical, size: 16),
//               ),
//               const SizedBox(width: 8),
//               Expanded(child: Text(widget.title).semiBold.small),
//               Builder(
//                 builder: (BuildContext context) {
//                   return IconButton.ghost(
//                     onPressed: () {
//                       showDropdown(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return DropdownMenu(
//                             children: [
//                               const MenuLabel(child: Text("Actions")),
//                               const MenuDivider(),
//                               MenuButton(
//                                 onPressed: (_) {
//                                   showDialog(
//                                     context: context,
//                                     builder: (BuildContext context) {
//                                       return KanbanItemDialog();
//                                     },
//                                   );
//                                 },
//                                 child: const Text("Edit"),
//                               ),
//                               const MenuDivider(),
//                               MenuButton(
//                                 onPressed: (_) {},
//                                 child: const Text("Delete"),
//                               ),
//                             ],
//                           );
//                         },
//                       );
//                     },
//                     icon: const Icon(LucideIcons.settings, size: 16),
//                   );
//                 },
//               ),
//             ],
//           ),

//           const SizedBox(height: 16),

//           Text(widget.description).muted.xSmall,
//         ],
//       ),
//     );
//   }
// }

// class KanbanItemDialog extends StatelessWidget {
//   final bool isNewTask;

//   const KanbanItemDialog({super.key, this.isNewTask = false});

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: isNewTask ? Text("Create New Task") : Text("Edit Task"),
//       content: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           ConstrainedBox(
//             constraints: const BoxConstraints(maxWidth: 320),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 if (isNewTask)
//                   const Text("Add a new task to your board")
//                 else
//                   const Text("Edit a task on your board"),

//                 FormField(
//                   key: FormKey(#title),
//                   label: const Text("Title"),
//                   child: TextField(placeholder: const Text("Enter task title")),
//                 ),

//                 FormField(
//                   key: FormKey(#description),
//                   label: const Text("Description"),
//                   child: TextArea(
//                     placeholder: const Text(
//                       "Enter task description (optional)",
//                     ),
//                     expandableHeight: true,
//                     initialHeight: 75,
//                   ),
//                 ),
//               ],
//             ).gap(16),
//           ),
//         ],
//       ).gap(16),
//       actions: [
//         SecondaryButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           child: const Text("Cancel"),
//         ),
//         PrimaryButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           child: isNewTask ? Text("Create Task") : Text("Update"),
//         ),
//       ],
//     );
//   }
// }

// class ColumnData {
//   final String id;
//   String title;
//   Color color;
//   List<TaskItem> items;

//   ColumnData({
//     required this.id,
//     required this.title,
//     required this.color,
//     required this.items,
//   });
// }

// class TaskItem {
//   final String id;
//   String title;
//   String description;
//   Color color;
//   String priority;

//   TaskItem({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.color,
//     required this.priority,
//   });
// }
