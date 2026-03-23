import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:shadcn_flutter/shadcn_flutter.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final scrollController = ScrollController();

  Key? selected = const ValueKey(0);

  List<AvatarWidget> getAvatars() {
    return [
      Avatar(
        initials: Avatar.getInitials("TS"),
        backgroundColor: Colors.red,
        size: 32,
      ),
      Avatar(
        initials: Avatar.getInitials("TS"),
        backgroundColor: Colors.green,
        size: 32,
      ),
      Avatar(
        initials: Avatar.getInitials("TS"),
        backgroundColor: Colors.blue,
        size: 32,
      ),
      Avatar(
        initials: Avatar.getInitials("TS"),
        backgroundColor: Colors.yellow,
        size: 32,
      ),
    ];
  }

  Widget buildButton(String label, IconData icon, Key key) {
    return NavigationItem(
      key: key,
      label: Text(label),
      child: Icon(icon, size: 16),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final columns = ref.watch(kanbanProvider);

    return Scaffold(
      headers: [
        AppBar(
          title: const Text("Kanban Board"),
          trailing: [
            SizedBox(
              width: 250,
              child: TextField(
                placeholder: const Text("Search..."),
                features: [
                  // Leading icon only visible when the text is empty
                  InputFeature.leading(
                    StatedWidget.builder(
                      builder: (context, states) {
                        // Use a muted icon normally, switch to the full icon on hover
                        if (states.hovered) {
                          return const Icon(Icons.search);
                        } else {
                          return const Icon(Icons.search).iconMutedForeground();
                        }
                      },
                    ),
                    visibility: InputFeatureVisibility.textEmpty,
                  ),
                  // Clear button visible when there is text and the field is focused,
                  // or whenever the field is hovered
                  InputFeature.clear(
                    visibility:
                        (InputFeatureVisibility.textNotEmpty &
                            InputFeatureVisibility.focused) |
                        InputFeatureVisibility.hovered,
                  ),
                ],
              ),
            ),
            gap(8),
            IconButton.ghost(
              onPressed: () {},
              icon: const Icon(LucideIcons.bell, size: 16),
            ),
            gap(8),
            IconButton.ghost(
              onPressed: () {},
              icon: const Icon(LucideIcons.moon, size: 16),
            ),
            gap(8),
            IconButton.ghost(
              onPressed: () {},
              icon: const Icon(LucideIcons.settings, size: 16),
            ),
            gap(8),
            IconButton.ghost(
              onPressed: () {},
              icon: const Icon(LucideIcons.user, size: 16),
            ),
          ],
        ),
        const Divider(),
      ],
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 240,
            height: MediaQuery.of(context).size.height,
            child: NavigationSidebar(
              selectedKey: selected,
              onSelected: (key) {
                setState(() {
                  selected = key;
                });
              },
              children: [
                NavigationButton(
                  onPressed: () {},
                  style: ButtonStyle.primary(),
                  label: const Text("New Project"),
                  child: const Icon(LucideIcons.plus, size: 16),
                ),
                const NavigationDivider(),
                buildButton("Projects", LucideIcons.folder, ValueKey(0)),
                buildButton("Archive", LucideIcons.archive, ValueKey(1)),
                buildButton("Team", LucideIcons.users, ValueKey(2)),
              ],
            ),
          ),
          const VerticalDivider(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Project Velocity").x2Large.bold,
                          gap(8),
                          const Text(
                            "System architecture and interface modeling for the Q4 kinetic engine update.",
                          ).muted,
                        ],
                      ),
                      const Spacer(),
                      AvatarGroup.toLeft(children: getAvatars()),
                    ],
                  ),

                  gap(16),

                  Scrollbar(
                    controller: scrollController,
                    interactive: true,
                    child: SingleChildScrollView(
                      controller: scrollController,
                      scrollDirection: Axis.horizontal,
                      child: SortableLayer(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (
                              int colIndex = 0;
                              colIndex < columns.length;
                              colIndex++
                            )
                              KanbanColumn(colIndex: colIndex),
                          ],
                        ).gap(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class KanbanColumn extends ConsumerStatefulWidget {
  final int colIndex;

  const KanbanColumn({super.key, required this.colIndex});

  @override
  ConsumerState<KanbanColumn> createState() => _KanbanColumnState();
}

class _KanbanColumnState extends ConsumerState<KanbanColumn> {
  @override
  Widget build(BuildContext context) {
    final columns = ref.watch(kanbanProvider);
    final notifier = ref.read(kanbanProvider.notifier);
    final column = columns[widget.colIndex];

    return SortableDropFallback<TaskData>(
      onAccept: (value) {
        setState(() {
          notifier.moveTask(value, column.data.tasks, column.data.tasks.length);
        });
      },
      child: Container(
        width: 360,
        decoration: BoxDecoration(
          color: Colors.gray.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(column.data.title),
                gap(8),
                PrimaryBadge(child: Text("${column.data.tasks.length}")),
                const Spacer(),
                IconButton.ghost(
                  onPressed: () {},
                  icon: const Icon(LucideIcons.ellipsis),
                ),
              ],
            ),

            for (
              int taskIndex = 0;
              taskIndex < column.data.tasks.length;
              taskIndex++
            )
              Sortable<TaskData>(
                data: column.data.tasks[taskIndex],
                onAcceptTop: (value) {
                  notifier.moveTask(value, column.data.tasks, taskIndex);
                },
                onAcceptBottom: (value) {
                  notifier.moveTask(value, column.data.tasks, taskIndex + 1);
                },
                child: KanbanColumnItem(
                  title: column.data.tasks[taskIndex].data.title,
                  description: column.data.tasks[taskIndex].data.description,
                  priority: column.data.tasks[taskIndex].data.priority,
                  priorityColor:
                      column.data.tasks[taskIndex].data.priorityColor,
                  tags: column.data.tasks[taskIndex].data.tags,
                ),
              ),

            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  height: 64,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.border,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: const Icon(LucideIcons.plus, color: Colors.gray),
                  ),
                ),
              ),
            ),
          ],
        ).gap(16),
      ),
    );
  }
}

class KanbanColumnItem extends StatefulWidget {
  final String title;
  final String description;
  final String priority;
  final Color priorityColor;
  final List<Widget> tags;

  const KanbanColumnItem({
    super.key,
    required this.title,
    required this.description,
    required this.priority,
    required this.priorityColor,
    required this.tags,
  });

  @override
  State<KanbanColumnItem> createState() => _KanbanColumnItemState();
}

class _KanbanColumnItemState extends State<KanbanColumnItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: _pressed ? SystemMouseCursors.grabbing : SystemMouseCursors.grab,
      child: Listener(
        onPointerDown: (_) {
          setState(() => _pressed = true);
        },
        onPointerUp: (_) {
          setState(() => _pressed = false);
        },
        onPointerCancel: (_) {
          setState(() => _pressed = false);
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
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
                  Text(widget.title).semiBold,
                  const Spacer(),
                  Badge(child: widget.priority, color: widget.priorityColor),
                ],
              ),

              gap(16),

              Text(widget.description),

              gap(16),

              ...widget.tags,

              gap(16),

              Row(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Badge extends StatelessWidget {
  final String child;
  final Color color;

  const Badge({super.key, required this.child, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Text(child, style: TextStyle(color: color)).small,
    );
  }
}

class ColumnData {
  final String title;
  final List<SortableData<TaskData>> tasks;

  ColumnData({required this.title, required this.tasks});
}

class TaskData {
  final String title;
  final String description;
  final List<Widget> tags;
  final String priority;
  final Color priorityColor;

  TaskData({
    required this.title,
    required this.description,
    required this.tags,
    required this.priority,
    required this.priorityColor,
  });
}

final kanbanProvider =
    NotifierProvider<KanbanNotifier, List<SortableData<ColumnData>>>(
      KanbanNotifier.new,
    );

class KanbanNotifier extends Notifier<List<SortableData<ColumnData>>> {
  @override
  List<SortableData<ColumnData>> build() {
    return [
      SortableData(
        ColumnData(
          title: "To Do",
          tasks: [
            SortableData(
              TaskData(
                title: "Competitor Spatial Analysis",
                description:
                    "Benchmarking the ease of movement in competing architect platforms.",
                tags: [const PrimaryBadge(child: Text("Research"))],
                priority: "High",
                priorityColor: Colors.red,
              ),
            ),
            SortableData(
              TaskData(
                title: "V3 Iconography Pack",
                description:
                    "Exporting all stroke-based icons for the new shadcn library.",
                tags: [const PrimaryBadge(child: Text("Asset"))],
                priority: "Medium",
                priorityColor: Colors.orange,
              ),
            ),
          ],
        ),
      ),
      SortableData(
        ColumnData(
          title: "In Progress",
          tasks: [
            SortableData(
              TaskData(
                title: "Kinetic Physics Engine",
                description:
                    "Refining the spring animations for the dashboard cards transitions.",
                tags: [const PrimaryBadge(child: Text("Engineering"))],
                priority: "Low",
                priorityColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
      SortableData(
        ColumnData(
          title: "Review",
          tasks: [
            SortableData(
              TaskData(
                title: "Auth Flow Refactor",
                description:
                    "Security audit and 2FA implementation for enterprise users.",
                tags: [const PrimaryBadge(child: Text("Security"))],
                priority: "High",
                priorityColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    ];
  }

  void moveTask(
    SortableData<TaskData> task,
    List<SortableData<TaskData>> targetList,
    int index,
  ) {
    List<SortableData<ColumnData>> newState = [...state];

    // Remove from all columns
    for (var col in newState) {
      col.data.tasks.remove(task);
    }

    if (index > targetList.length) {
      index = targetList.length;
    }

    targetList.insert(index, task);

    state = newState;
  }

  void addTask() {
    // TODO:
  }

  void updateTask() {
    // TODO:
  }

  void deleteTask() {
    // TODO:
  }
}
