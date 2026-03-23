import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:shadcn_flutter/shadcn_flutter.dart';

class DefaultScreen extends ConsumerStatefulWidget {
  final VoidCallback onThemeToggle;
  final ThemeMode themeMode;

  const DefaultScreen({
    super.key,
    required this.onThemeToggle,
    required this.themeMode,
  });

  @override
  ConsumerState<DefaultScreen> createState() => _DefaultScreen();
}

class _DefaultScreen extends ConsumerState<DefaultScreen> {
  String? selectedProjectId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      headers: [
        AppBar(
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
              onPressed: () {},
              leading: const Icon(LucideIcons.plus, size: 16),
              child: const Text("Create"),
            ),
            gap(8),
            IconButton.ghost(
              onPressed: widget.onThemeToggle,
              icon: Icon(
                widget.themeMode == ThemeMode.dark
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
      child: selectedProjectId == null
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProjectCard(
                        onTap: () {
                          setState(() {
                            selectedProjectId = "project_1";
                          });
                        },
                        title: "Project Velocity",
                        description:
                            "System architecture and interface modeling for the Q4 kinetic engine update.",
                      ),
                    ],
                  ),
                ],
              ),
            )
          : ProjectBoardScreen(
              projectId: selectedProjectId!,
              onBack: () {
                setState(() {
                  selectedProjectId = null;
                });
              },
            ),
    );
  }
}

class ProjectCard extends ConsumerStatefulWidget {
  final VoidCallback onTap;
  final String title;
  final String description;

  const ProjectCard({
    super.key,
    required this.onTap,
    required this.title,
    required this.description,
  });

  @override
  ConsumerState<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends ConsumerState<ProjectCard> {
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          transform: Matrix4.identity()..scale(_hovered ? 1.02 : 1.0),
          width: 360,
          decoration: BoxDecoration(
            color: theme.colorScheme.card,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.6)
                    : Colors.black.withValues(alpha: _hovered ? 0.15 : 0.1),
                blurRadius: _hovered ? 8 : 2,
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
              ),

              Text(widget.description).muted.small,
            ],
          ).gap(16),
        ),
      ),
    );
  }
}

class ProjectBoardScreen extends ConsumerStatefulWidget {
  final String? projectId;
  final VoidCallback onBack;

  const ProjectBoardScreen({
    super.key,
    required this.projectId,
    required this.onBack,
  });

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
  Widget build(BuildContext context) {
    final columns = ref.watch(kanbanProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton.outline(
                onPressed: widget.onBack,
                density: ButtonDensity.iconDense,
                icon: const Icon(LucideIcons.chevronLeft),
              ),
              gap(8),
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

class CreateNewProjectScreen extends ConsumerStatefulWidget {
  const CreateNewProjectScreen({super.key});

  @override
  ConsumerState<CreateNewProjectScreen> createState() =>
      _CreateNewProjectScreenState();
}

class _CreateNewProjectScreenState
    extends ConsumerState<CreateNewProjectScreen> {
  Iterable<String>? selectedValues;
  DateTime? _startValue;
  DateTime? _endValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Create New Project"),

          Center(
            child: SizedBox(
              width: 800,
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: FormField(
                        key: FormKey(#title),
                        label: const Text("Title"),
                        child: TextField(),
                      ),
                    ),

                    gap(16),

                    SizedBox(
                      width: double.infinity,
                      child: FormField(
                        key: FormKey(#description),
                        label: const Text("Description"),
                        child: TextArea(minLines: 4),
                      ),
                    ),

                    gap(16),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: FormField(
                            key: FormKey(#tags),
                            label: const Text("Tags"),
                            child: MultiSelect<String>(
                              itemBuilder: (context, item) {
                                return MultiSelectChip(
                                  value: item,
                                  child: Text(item),
                                );
                              },
                              constraints: const BoxConstraints(maxWidth: 200),
                              value: selectedValues,
                              placeholder: const Text("Select tags"),
                              popup: const SelectPopup(
                                items: SelectItemList(
                                  children: [
                                    SelectItemButton(
                                      value: "Work",
                                      child: Text("Work"),
                                    ),
                                    SelectItemButton(
                                      value: "Personal",
                                      child: Text("Personal"),
                                    ),
                                    SelectItemButton(
                                      value: "Ideas",
                                      child: Text("Ideas"),
                                    ),
                                  ],
                                ),
                              ).call,
                              onChanged: (value) {
                                setState(() {
                                  selectedValues = value;
                                });
                              },
                            ),
                          ),
                        ),
                        gap(8),
                        Tooltip(
                          tooltip: const TooltipContainer(
                            child: Text("New tag"),
                          ).call,
                          child: IconButton.primary(
                            onPressed: () {},
                            icon: const Icon(LucideIcons.plus),
                          ),
                        ),
                      ],
                    ),

                    gap(16),

                    FormField(
                      key: FormKey(#timeline),
                      label: const Text("Timeline"),
                      child: Row(
                        children: [
                          DatePicker(
                            value: _startValue,
                            mode: PromptMode.popover,
                            stateBuilder: (date) {
                              if (date.isAfter(DateTime.now())) {
                                return DateState.disabled;
                              }
                              return DateState.enabled;
                            },
                            onChanged: (value) {
                              setState(() {
                                _startValue = value;
                              });
                            },
                          ),
                          gap(16),
                          const Text("-"),
                          gap(16),
                          DatePicker(
                            value: _endValue,
                            mode: PromptMode.popover,
                            stateBuilder: (date) {
                              if (date.isAfter(DateTime.now())) {
                                return DateState.disabled;
                              }
                              return DateState.enabled;
                            },
                            onChanged: (value) {
                              setState(() {
                                _endValue = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    gap(16),

                    FormField(
                      key: FormKey(#team),
                      label: const Text("Team"),
                      child: PrimaryButton(
                        onPressed: () {},
                        leading: const Icon(LucideIcons.plus, size: 16),
                        child: const Text("New team member"),
                      ),
                    ),

                    gap(16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlineButton(
                          onPressed: () {},
                          leading: const Icon(LucideIcons.save, size: 16),
                          child: const Text("Save Draft"),
                        ),
                        PrimaryButton(
                          onPressed: () {},
                          leading: const Icon(LucideIcons.plus, size: 16),
                          child: const Text("Create"),
                        ),
                      ],
                    ).gap(8),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
