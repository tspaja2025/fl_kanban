import 'package:fl_kanban/shared/kanban_constants.dart';
import 'package:fl_kanban/models/models.dart';
import 'package:fl_kanban/providers/kanban_board_provider.dart';
import 'package:fl_kanban/widgets/badge.dart';
import 'package:fl_kanban/widgets/card_container.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:go_router/go_router.dart';

class KanbanProjectScreen extends ConsumerStatefulWidget {
  const KanbanProjectScreen({super.key});

  @override
  ConsumerState<KanbanProjectScreen> createState() =>
      _KanbanProjectScreenState();
}

class _KanbanProjectScreenState extends ConsumerState<KanbanProjectScreen> {
  int tabIndex = 0;

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projectsAsync = ref.watch(kanbanProvider);
    final notifier = ref.read(kanbanProvider.notifier);

    return projectsAsync.when(
      data: (projects) {
        final boards = notifier.searchQuery.isEmpty
            ? projects
            : projects.where((project) {
                final query = notifier.searchQuery.toLowerCase();
                return project.title.toLowerCase().contains(query) ||
                    project.description.toLowerCase().contains(query);
              }).toList();

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ... your existing UI
                    IndexedStack(
                      index: tabIndex,
                      children: [
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            for (final board in boards)
                              ProjectCard(
                                key: ValueKey(board.id),
                                onTap: () => context.pushNamed(
                                  "kanbanProjectDetail",
                                  pathParameters: {"id": board.id},
                                ),
                                projectId: board.id,
                                title: board.title,
                                description: board.description,
                                status: board.status,
                                backgroundColor: board.backgroundColor,
                                foregroundColor: board.foregroundColor,
                                dueDate: board.dueDate,
                                teamMembers: board.teamMembers,
                              ),
                            const CreateProjectCard(),
                          ],
                        ),
                        Column(children: [const Text("Active")]),
                        Column(children: [const Text("Archived")]),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text("Error: $error")),
    );
  }
}

class NewProjectForm extends ConsumerStatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final List<TeamMember> initialMembers;
  final Function(List<TeamMember>)? onMembersChanged;

  const NewProjectForm({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.descriptionController,
    this.initialMembers = const [],
    this.onMembersChanged,
  });

  @override
  ConsumerState<NewProjectForm> createState() => _NewProjectFormState();
}

class _NewProjectFormState extends ConsumerState<NewProjectForm> {
  DateTime? _value;
  late List<TeamMember> _teamMembers;

  @override
  void initState() {
    super.initState();
    _teamMembers = List.from(widget.initialMembers);
  }

  List<TeamMember> get teamMembers => _teamMembers;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FormField(
              key: const FormKey(#title),
              label: const Text("Title"),
              child: TextField(controller: widget.titleController),
            ),
            const Gap(KanbanConstants.gapSize),
            FormField(
              key: const FormKey(#description),
              label: const Text("Description"),
              child: TextArea(
                controller: widget.descriptionController,
                maxLines: 3,
              ),
            ),
            const Gap(KanbanConstants.gapSize),
            FormField(
              key: const FormKey(#dueDate),
              label: const Text("Due Date"),
              child: DatePicker(
                value: _value,
                mode: PromptMode.popover,
                // Disable selecting dates after "today".
                stateBuilder: (date) {
                  return DateState.enabled;
                },
                onChanged: (value) {
                  setState(() {
                    _value = value;
                  });
                },
              ),
            ),
            const Gap(KanbanConstants.gapSize),
            TeamMemberSelector(
              selectedMembers: _teamMembers,
              onMembersChanged: (newMembers) {
                setState(() {
                  _teamMembers = newMembers;
                  widget.onMembersChanged?.call(newMembers);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectCard extends ConsumerStatefulWidget {
  final String projectId;
  final VoidCallback onTap;
  final String title;
  final String description;
  final ProjectStatus status;
  final Color backgroundColor;
  final Color foregroundColor;
  final String dueDate;
  final List<TeamMember> teamMembers;

  const ProjectCard({
    super.key,
    required this.projectId,
    required this.onTap,
    required this.title,
    required this.description,
    required this.status,
    this.backgroundColor = const Color(0xFFE0F2FE),
    this.foregroundColor = const Color(0xFF075985),
    required this.dueDate,
    this.teamMembers = const [],
  });

  @override
  ConsumerState<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends ConsumerState<ProjectCard> {
  List<AvatarWidget> getAvatars() {
    return widget.teamMembers.take(4).map((member) {
      return Avatar(
        initials: member.initials,
        backgroundColor: member.avatarColor,
        size: 24,
      );
    }).toList();
  }

  int get remainingMembersCount =>
      widget.teamMembers.length > 4 ? widget.teamMembers.length - 4 : 0;

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      onTap: widget.onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(ref),
          const Gap(16),
          Text(widget.title).large.semiBold,
          const Gap(16),
          Text(widget.description),
          const Gap(16),
          const Divider(),
          const Gap(16),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader(WidgetRef ref) {
    final notifier = ref.read(kanbanProvider.notifier);

    return Row(
      children: [
        Badge(
          text: widget.status.displayName,
          backgroundColor: widget.backgroundColor,
          foregroundColor: widget.foregroundColor,
        ),
        const Spacer(),
        Builder(
          builder: (context) {
            return IconButton.ghost(
              onPressed: () {
                showDropdown(
                  context: context,
                  builder: (dropdownContext) {
                    return DropdownMenu(
                      children: [
                        const MenuLabel(child: Text("Actions")),
                        const MenuDivider(),
                        MenuButton(
                          onPressed: (_) {
                            if (context.canPop()) {
                              context.pop();
                            }

                            _showEditProjectDialog(
                              context,
                              ref,
                              widget.projectId,
                              widget.title,
                              widget.description,
                              widget.teamMembers,
                            );
                          },
                          child: const Text("Edit Project"),
                        ),
                        MenuButton(
                          onPressed: (_) {
                            if (context.canPop()) {
                              context.pop();
                            }

                            showDialog(
                              context: context,
                              builder: (dialogContext) {
                                return AlertDialog(
                                  title: const Text("Delete Project"),
                                  content: Text(
                                    "Are you sure you want to delete '{$widget.title}'? This action cannot be undone.",
                                  ),
                                  actions: [
                                    OutlineButton(
                                      onPressed: () =>
                                          Navigator.pop(dialogContext),
                                      child: const Text("Cancel"),
                                    ),
                                    PrimaryButton(
                                      onPressed: () {
                                        Navigator.pop(dialogContext);

                                        notifier.deleteProject(
                                          widget.projectId,
                                        );

                                        _showDeleteToast(context, widget.title);
                                      },
                                      child: const Text("Delete"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Text("Delete Project"),
                        ),
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

  Widget _buildFooter() {
    return Row(
      children: [
        if (widget.teamMembers.isNotEmpty)
          Expanded(child: AvatarGroup.toLeft(children: getAvatars()))
        else
          const Text("No team members assigned").muted.small,
        const Spacer(),
        Text(widget.dueDate).muted,
      ],
    );
  }

  void _showDeleteToast(BuildContext context, String projectTitle) {
    final rootContext = Navigator.of(context, rootNavigator: true).context;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!rootContext.mounted) return;

      showToast(
        context: rootContext,
        location: ToastLocation.bottomRight,
        builder: (BuildContext toastContext, ToastOverlay overlay) {
          return SurfaceCard(
            child: Basic(
              trailing: PrimaryButton(
                size: ButtonSize.small,
                onPressed: () {
                  overlay.close();
                },
                child: const Text("Close"),
              ),
              title: Text("Deleted project: $projectTitle"),
              subtitle: const Text(
                "The project has been successfully removed.",
              ),
            ),
          );
        },
      );
    });
  }

  void _showEditProjectDialog(
    BuildContext context,
    WidgetRef ref,
    String projectId,
    String currentTitle,
    String currentDescription,
    List<TeamMember> currentMembers,
  ) {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController(text: currentTitle);
    final descriptionController = TextEditingController(
      text: currentDescription,
    );
    List<TeamMember> selectedMembers = List.from(currentMembers);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Edit Project"),
          content: NewProjectForm(
            formKey: formKey,
            titleController: titleController,
            descriptionController: descriptionController,
            onMembersChanged: (members) {
              setState(() {
                selectedMembers = members;
              });
            },
          ),
          actions: [
            OutlineButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel"),
            ),
            PrimaryButton(
              onPressed: () {
                final updatedProject = KanbanData(
                  id: projectId,
                  title: titleController.text,
                  description: descriptionController.text,
                  status: ProjectStatus.inProgress,
                  backgroundColor: const Color(0xFFE0F2FE),
                  foregroundColor: const Color(0xFF075985),
                  dueDate: "3 days left",
                  teamMembers: selectedMembers,
                  columns: [],
                );

                Navigator.pop(dialogContext);

                ref.read(kanbanProvider.notifier).updateProject(updatedProject);

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!context.mounted) return;

                  showToast(
                    context: context,
                    location: ToastLocation.bottomRight,
                    builder: (BuildContext toastContext, ToastOverlay overlay) {
                      return SurfaceCard(
                        child: Basic(
                          trailing: PrimaryButton(
                            size: ButtonSize.small,
                            onPressed: () {
                              overlay.close();
                            },
                            child: const Text("Close"),
                          ),
                          title: Text(
                            "Updated project: ${titleController.text}",
                          ),
                          subtitle: const Text(
                            "Your new project has been updated successfully.",
                          ),
                        ),
                      );
                    },
                  );
                });
              },
              child: const Text("Save Changes"),
            ),
          ],
        );
      },
    );
  }
}

class CreateProjectCard extends ConsumerWidget {
  const CreateProjectCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CardContainer(
      onTap: () => _showNewProjectDialog(context, ref),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(LucideIcons.plus, size: 32),
          const Gap(16),
          const Text("Initiate Project").large.bold,
          const Gap(16),
          const Text("Ready to build something new?"),
          const Text("Click here to start.").small.muted,
        ],
      ),
    );
  }

  void _showNewProjectDialog(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    List<TeamMember> selectedMembers = [];

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("New Project"),
              content: NewProjectForm(
                formKey: formKey,
                titleController: titleController,
                descriptionController: descriptionController,
                onMembersChanged: (members) {
                  setState(() {
                    selectedMembers = members;
                  });
                },
              ),
              actions: [
                OutlineButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text("Cancel"),
                ),
                PrimaryButton(
                  onPressed: () {
                    final newProject = KanbanData(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: titleController.text,
                      description: descriptionController.text,
                      status: ProjectStatus.inProgress,
                      backgroundColor: const Color(0xFFE0F2FE),
                      foregroundColor: const Color(0xFF075985),
                      dueDate: "3 days left",
                      teamMembers: selectedMembers,
                      columns: [],
                    );

                    Navigator.pop(dialogContext);

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!context.mounted) return;

                      showToast(
                        context: context,
                        location: ToastLocation.bottomRight,
                        builder: (BuildContext toastContext, ToastOverlay overlay) {
                          return SurfaceCard(
                            child: Basic(
                              trailing: PrimaryButton(
                                size: ButtonSize.small,
                                onPressed: () {
                                  overlay.close();
                                },
                                child: const Text("Close"),
                              ),
                              title: Text(
                                "Created project: ${newProject.title}",
                              ),
                              subtitle: const Text(
                                "Your new project has been added successfully.",
                              ),
                            ),
                          );
                        },
                      );
                    });

                    ref.read(kanbanProvider.notifier).addProject(newProject);
                  },
                  child: const Text("Create"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class TeamMemberSelector extends ConsumerStatefulWidget {
  final List<TeamMember> selectedMembers;
  final ValueChanged<List<TeamMember>> onMembersChanged;

  const TeamMemberSelector({
    super.key,
    required this.selectedMembers,
    required this.onMembersChanged,
  });

  @override
  ConsumerState<TeamMemberSelector> createState() => _TeamMemberSelector();
}

class _TeamMemberSelector extends ConsumerState<TeamMemberSelector> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  final List<TeamMember> _availableMembers = [
    const TeamMember(
      id: "1",
      name: "Alice Johnson",
      email: "alice@example.com",
      avatarColor: Color(0xFFE0F2FE),
    ),
    const TeamMember(
      id: "2",
      name: "Bob Smith",
      email: "bob@example.com",
      avatarColor: Color(0xFFDCFCE7),
    ),
    const TeamMember(
      id: "3",
      name: "Carol Davis",
      email: "carol@example.com",
      avatarColor: Color(0xFFFEE2E2),
    ),
  ];

  List<TeamMember> get _filteredMembers {
    if (_searchQuery.isEmpty) return _availableMembers;
    return _availableMembers
        .where(
          (member) =>
              member.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              member.email.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Team Members").medium.semiBold,
        const Gap(8),

        // Selected members chips
        if (widget.selectedMembers.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final member in widget.selectedMembers)
                Chip(
                  leading: Avatar(
                    initials: member.initials,
                    backgroundColor: member.avatarColor,
                    size: 24,
                  ),
                  child: Text(member.name),
                  onPressed: () {
                    final newMembers = List<TeamMember>.from(
                      widget.selectedMembers,
                    )..remove(member);
                    widget.onMembersChanged(newMembers);
                  },
                ),
            ],
          ),

        const Gap(8),

        // Add member button
        Builder(
          builder: (context) {
            return OutlineButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) {
                    return StatefulBuilder(
                      builder: (context, setDialogState) {
                        return AlertDialog(
                          title: const Text("Add Team Members"),
                          content: SizedBox(
                            width: 300,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: _searchController,
                                  placeholder: const Text("Search members..."),
                                  onChanged: (value) {
                                    setDialogState(() {
                                      _searchQuery = value;
                                    });
                                  },
                                ),
                                const Gap(16),
                                ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxHeight: 300,
                                  ),
                                  child: ListView(
                                    children: [
                                      for (final member in _filteredMembers)
                                        if (!widget.selectedMembers.contains(
                                          member,
                                        ))
                                          Card(
                                            child: Row(
                                              children: [
                                                Avatar(
                                                  initials: member.initials,
                                                  backgroundColor:
                                                      member.avatarColor,
                                                  size: 32,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(member.name),
                                                    Text(
                                                      member.email,
                                                    ).small.muted,
                                                  ],
                                                ),
                                                const Spacer(),
                                                IconButton.ghost(
                                                  onPressed: () {
                                                    final newMembers =
                                                        List<TeamMember>.from(
                                                          widget
                                                              .selectedMembers,
                                                        )..add(member);
                                                    widget.onMembersChanged(
                                                      newMembers,
                                                    );
                                                    Navigator.pop(
                                                      dialogContext,
                                                    );
                                                  },
                                                  icon: const Icon(
                                                    LucideIcons.plus,
                                                    size: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            OutlineButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              child: const Text("Close"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.userPlus, size: 16),
                  Gap(8),
                  Text("Add Team Member"),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
