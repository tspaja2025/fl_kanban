import 'package:fl_kanban/providers/kanban_provider.dart';
import 'package:fl_kanban/providers/router_provider.dart';
import 'package:fl_kanban/providers/theme_provider.dart';
import 'package:fl_kanban/widgets/badge.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class ProjectBoardScreen extends ConsumerStatefulWidget {
  final String? projectId;

  const ProjectBoardScreen({super.key, required this.projectId});

  @override
  ConsumerState<ProjectBoardScreen> createState() => _ProjectBoardScreenState();
}

class _ProjectBoardScreenState extends ConsumerState<ProjectBoardScreen> {
  final scrollController = ScrollController();

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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final notifier = ref.read(themeProvider.notifier);
    final columns = ref.watch(kanbanProvider);
    final router = ref.watch(routerProvider);

    return Scaffold(
      headers: [
        AppBar(
          leading: [
            IconButton.outline(
              onPressed: () {
                router.pop();
              },
              density: ButtonDensity.iconDense,
              icon: const Icon(LucideIcons.chevronLeft),
            ),
          ],
          title: const Text("Your Kanban Board"),
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
            PrimaryButton(
              onPressed: () {
                router.pushNamed("createProject");
              },
              leading: const Icon(LucideIcons.plus, size: 16),
              child: const Text("Create"),
            ),
            gap(8),
            IconButton.ghost(
              onPressed: notifier.toggle,
              icon: Icon(
                themeMode == ThemeMode.dark
                    ? LucideIcons.sun
                    : LucideIcons.moon,
                size: 16,
              ),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
        notifier.moveTask(value, column.data.tasks, column.data.tasks.length);
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

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: column.data.tasks.length,
              itemBuilder: (context, taskIndex) {
                return Sortable<TaskData>(
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
                );
              },
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
          margin: const EdgeInsets.only(bottom: 16),
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
