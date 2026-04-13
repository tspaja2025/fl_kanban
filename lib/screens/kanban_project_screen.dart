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
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}

class NewProjectForm extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  const NewProjectForm({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.descriptionController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FormField(
              key: const FormKey(#title),
              label: const Text("Title"),
              child: TextField(controller: titleController),
            ),
            const Gap(KanbanConstants.gapSize),
            FormField(
              key: const FormKey(#description),
              label: const Text("Description"),
              child: TextArea(controller: descriptionController, maxLines: 3),
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectCard extends ConsumerWidget {
  final String projectId;
  final VoidCallback onTap;
  final String title;
  final String description;
  final ProjectStatus status;
  final Color backgroundColor;
  final Color foregroundColor;
  final String dueDate;

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
  });

  List<AvatarWidget> getAvatars() {
    return [
      Avatar(
        initials: Avatar.getInitials("TS"),
        backgroundColor: Colors.red,
        size: 24,
      ),
      Avatar(
        initials: Avatar.getInitials("TS"),
        backgroundColor: Colors.green,
        size: 24,
      ),
      Avatar(
        initials: Avatar.getInitials("TS"),
        backgroundColor: Colors.blue,
        size: 24,
      ),
      Avatar(
        initials: Avatar.getInitials("TS"),
        backgroundColor: Colors.yellow,
        size: 24,
      ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CardContainer(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(ref),
          const Gap(16),
          Text(title).large.semiBold,
          const Gap(16),
          Text(description),
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
          text: status.displayName,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
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
                              projectId,
                              title,
                              description,
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
                                    "Are you sure you want to delete '$title'? This action cannot be undone.",
                                  ),
                                  actions: [
                                    OutlineButton(
                                      onPressed: () =>
                                          Navigator.pop(dialogContext),
                                      child: const Text("Cancel"),
                                    ),
                                    PrimaryButton(
                                      onPressed: () {
                                        Navigator.pop(
                                          dialogContext,
                                        ); // Close confirmation dialog

                                        // Delete the project
                                        notifier.deleteProject(projectId);

                                        // Show toast notification
                                        _showDeleteToast(context, title);
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
        AvatarGroup.toLeft(children: getAvatars()),
        const Spacer(),
        Text(dueDate).muted,
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
  ) {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController(text: currentTitle);
    final descriptionController = TextEditingController(
      text: currentDescription,
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Edit Project"),
          content: NewProjectForm(
            formKey: formKey,
            titleController: titleController,
            descriptionController: descriptionController,
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
                  status: ProjectStatus
                      .inProgress, // Keep existing status or add status picker
                  backgroundColor: const Color(0xFFE0F2FE),
                  foregroundColor: const Color(0xFF075985),
                  dueDate: "3 days left",
                  columns: [], // You should fetch existing columns
                );

                Navigator.pop(dialogContext);

                // You need to add this method to your KanbanNotifier
                ref.read(kanbanProvider.notifier).updateProject(updatedProject);

                // Show success toast
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

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("New Project"),
          content: NewProjectForm(
            formKey: formKey,
            titleController: titleController,
            descriptionController: descriptionController,
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
                          title: Text("Created project: ${newProject.title}"),
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
  }
}
