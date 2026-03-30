import 'package:fl_kanban/models/models.dart';
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
