import 'package:fl_kanban/shared/app_scaffold.dart';
import 'package:fl_kanban/widgets/badge.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const ProviderScope(child: FlKanban()));
}

class FlKanban extends ConsumerWidget {
  const FlKanban({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final router = ref.watch(routerProvider);

    return ShadcnApp.router(
      debugShowCheckedModeBanner: false,
      title: "Your Kanban Board",
      theme: ThemeData(colorScheme: ColorSchemes.lightNeutral),
      darkTheme: ThemeData(colorScheme: ColorSchemes.darkNeutral),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}

// ============== DATA MODELS ==============

class KanbanBoardData {
  final String id;
  final String title;
  final String description;

  const KanbanBoardData({
    required this.id,
    required this.title,
    required this.description,
  });
}

class KanbanColumnData {
  final String id;
  final String title;
  final List<SortableData<KanbanTaskData>> tasks;

  KanbanColumnData({
    required this.id,
    required this.title,
    required this.tasks,
  });
}

class KanbanTaskData {
  final String id;
  final String title;
  final String description;
  final String priority;
  final Color color;

  KanbanTaskData({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.color,
  });
}

// ============== PROVIDERS ==============

final kanbanBoardProvider =
    NotifierProvider<KanbanBoardNotifier, List<KanbanBoardData>>(
      KanbanBoardNotifier.new,
    );

class KanbanBoardNotifier extends Notifier<List<KanbanBoardData>> {
  @override
  List<KanbanBoardData> build() {
    return [
      KanbanBoardData(
        id: "1",
        title: "Project Velocity",
        description:
            "System architecture and interface modeling for the Q4 kinetic engine update.",
      ),
    ];
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: "/",
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          final showBackButton = state.uri.path != "/";
          return AppScaffold(showBackButton: showBackButton, child: child);
        },
        routes: [
          GoRoute(
            path: "/",
            name: "projects",
            builder: (context, state) => const KanbanProjectScreen(),
          ),
          GoRoute(
            path: "/projects/:id",
            name: "kanbanProjectDetail",
            builder: (context, state) {
              final projectId = state.pathParameters["id"]!;
              return KanbanBoardScreen(projectId: projectId);
            },
          ),
          GoRoute(
            path: "/create-project",
            name: "createProject",
            builder: (context, state) => const CreateNewProjectScreen(),
          ),
        ],
      ),
    ],
  );
});

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(
  ThemeNotifier.new,
);

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    return ThemeMode.light;
  }

  void toggle() {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }
}

// ============== SCREENS ==============

class KanbanProjectScreen extends ConsumerWidget {
  const KanbanProjectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boards = ref.watch(kanbanBoardProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            for (final board in boards)
              KanbanProjectCard(
                onTap: () => context.pushNamed(
                  "kanbanProjectDetail",
                  pathParameters: {"id": board.id},
                ),
                title: board.title,
                description: board.description,
              ),
            KanbanEmptyProjectCard(
              onTap: () => context.pushNamed("createProject"),
            ),
          ],
        ),
      ],
    );
  }
}

class KanbanBoardScreen extends ConsumerStatefulWidget {
  final String projectId;

  const KanbanBoardScreen({super.key, required this.projectId});

  @override
  ConsumerState<KanbanBoardScreen> createState() => _KanbanBoardScreenState();
}

class _KanbanBoardScreenState extends ConsumerState<KanbanBoardScreen> {
  late List<SortableData<KanbanColumnData>> columns;

  @override
  void initState() {
    super.initState();
    _initializeColumns();
  }

  void _initializeColumns() {
    columns = [
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

  void _moveTask(
    SortableData<KanbanTaskData> task,
    int targetColumnIndex,
    int targetTaskIndex,
  ) {
    setState(() {
      // Find source column and remove task
      SortableData<KanbanColumnData>? sourceColumn;
      SortableData<KanbanTaskData>? removedTask;

      for (var column in columns) {
        final taskIndex = column.data.tasks.indexWhere((t) => t == task);
        if (taskIndex != -1) {
          sourceColumn = column;
          removedTask = column.data.tasks.removeAt(taskIndex);
          break;
        }
      }

      if (removedTask == null) return;

      // Add to target column
      final targetColumn = columns[targetColumnIndex];
      if (targetTaskIndex >= targetColumn.data.tasks.length) {
        targetColumn.data.tasks.add(removedTask);
      } else {
        targetColumn.data.tasks.insert(targetTaskIndex, removedTask);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                onMoveTask: _moveTask,
              ),
          ],
        ).gap(16),
      ),
    );
  }
}

class KanbanColumn extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 360,
      decoration: BoxDecoration(
        color: Colors.gray.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: SortableDropFallback<KanbanTaskData>(
        onAccept: (value) {
          onMoveTask(value, columnIndex, column.data.tasks.length);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [_buildColumnHeader(), ..._buildTaskList()],
        ).gap(16),
      ),
    );
  }

  Widget _buildColumnHeader() {
    return Row(
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
    );
  }

  List<Widget> _buildTaskList() {
    return List.generate(column.data.tasks.length, (taskIndex) {
      final task = column.data.tasks[taskIndex];

      return Sortable<KanbanTaskData>(
        data: task,
        onAcceptTop: (value) {
          onMoveTask(value, columnIndex, taskIndex);
        },
        onAcceptBottom: (value) {
          onMoveTask(value, columnIndex, taskIndex + 1);
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

class CreateNewProjectScreen extends ConsumerWidget {
  const CreateNewProjectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [const Text("Create project screen")],
    );
  }
}

// ============== CUSTOM WIDGETS ==============

class KanbanProjectCard extends ConsumerStatefulWidget {
  final VoidCallback onTap;
  final String title;
  final String description;

  const KanbanProjectCard({
    super.key,
    required this.onTap,
    required this.title,
    required this.description,
  });

  @override
  ConsumerState<KanbanProjectCard> createState() => _KanbanProjectCard();
}

class _KanbanProjectCard extends ConsumerState<KanbanProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: SizedBox(
          width: 360,
          child: Card(
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.6)
                    : Colors.black.withValues(alpha: _hovered ? 0.15 : 0.1),
                blurRadius: _hovered ? 8 : 2,
                offset: const Offset(0, 4),
              ),
            ],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_buildHeader(), Text(widget.description)],
            ).gap(16),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(widget.title).semiBold],
        ),
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
                        MenuButton(child: Text("Edit")),
                        MenuButton(child: Text("Delete")),
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
}

class KanbanEmptyProjectCard extends ConsumerStatefulWidget {
  final VoidCallback onTap;

  const KanbanEmptyProjectCard({super.key, required this.onTap});

  @override
  ConsumerState<KanbanEmptyProjectCard> createState() =>
      _KanbanEmptyProjectCardState();
}

class _KanbanEmptyProjectCardState
    extends ConsumerState<KanbanEmptyProjectCard> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: SizedBox(
          width: 360,
          height: 125,
          child: Card(
            borderColor: Theme.of(context).colorScheme.border,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [const Text("Create New Project")],
            ).gap(16),
          ),
        ),
      ),
    );
  }
}
