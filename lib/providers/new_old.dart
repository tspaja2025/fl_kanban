// final projectsProvider = NotifierProvider<ProjectsNotifier, List<Project>>(
//   ProjectsNotifier.new,
// );

// class ProjectsNotifier extends Notifier<List<Project>> {
//   @override
//   List<Project> build() {
//     // Load from storage or use default data
//     return _getDefaultProjects();
//   }

//   List<Project> _getDefaultProjects() {
//     return [
//       Project(
//         id: 'project_1',
//         title: 'Project Velocity',
//         description: 'System architecture and interface modeling for the Q4 kinetic engine update.',
//         columns: [
//           ColumnData(
//             title: 'To Do',
//             tasks: [
//               TaskData(
//                 title: 'Competitor Spatial Analysis',
//                 description: 'Benchmarking the ease of movement in competing architect platforms.',
//                 tags: [const Tag(id: 'research', name: 'Research', color: Colors.blue)],
//                 priority: Priority.high,
//               ),
//               TaskData(
//                 title: 'V3 Iconography Pack',
//                 description: 'Exporting all stroke-based icons for the new shadcn library.',
//                 tags: [const Tag(id: 'asset', name: 'Asset', color: Colors.green)],
//                 priority: Priority.medium,
//                 dueDate: DateTime.now().add(const Duration(days: 3)),
//               ),
//             ],
//           ),
//           ColumnData(
//             title: 'In Progress',
//             tasks: [
//               TaskData(
//                 title: 'Kinetic Physics Engine',
//                 description: 'Refining the spring animations for the dashboard cards transitions.',
//                 tags: [const Tag(id: 'engineering', name: 'Engineering', color: Colors.orange)],
//                 priority: Priority.low,
//                 assignees: ['user_1'],
//               ),
//             ],
//           ),
//           ColumnData(
//             title: 'Review',
//             tasks: [
//               TaskData(
//                 title: 'Auth Flow Refactor',
//                 description: 'Security audit and 2FA implementation for enterprise users.',
//                 tags: [const Tag(id: 'security', name: 'Security', color: Colors.red)],
//                 priority: Priority.high,
//                 dueDate: DateTime.now().add(const Duration(days: 1)),
//                 assignees: ['user_1', 'user_2'],
//               ),
//             ],
//           ),
//         ],
//         tags: ['velocity', 'q4', 'kinetic'],
//         teamMembers: [
//           TeamMember(id: 'user_1', name: 'John Doe', email: 'john@example.com'),
//           TeamMember(id: 'user_2', name: 'Jane Smith', email: 'jane@example.com'),
//         ],
//       ),
//     ];
//   }

//   // Project CRUD operations
//   void addProject(Project project) {
//     state = [...state, project];
//   }

//   void updateProject(String projectId, Project updatedProject) {
//     final index = state.indexWhere((p) => p.id == projectId);
//     if (index != -1) {
//       final newState = [...state];
//       newState[index] = updatedProject;
//       state = newState;
//     }
//   }

//   void deleteProject(String projectId) {
//     state = state.where((p) => p.id != projectId).toList();
//   }

//   Project? getProject(String projectId) {
//     try {
//       return state.firstWhere((p) => p.id == projectId);
//     } catch (_) {
//       return null;
//     }
//   }

//   // Column operations for a specific project
//   void addColumn(String projectId, ColumnData column) {
//     final project = getProject(projectId);
//     if (project != null) {
//       final updatedProject = project.copyWith(
//         columns: [...project.columns, column],
//       );
//       updateProject(projectId, updatedProject);
//     }
//   }

//   void updateColumn(String projectId, int columnIndex, ColumnData updatedColumn) {
//     final project = getProject(projectId);
//     if (project != null && columnIndex < project.columns.length) {
//       final newColumns = [...project.columns];
//       newColumns[columnIndex] = updatedColumn;
//       final updatedProject = project.copyWith(columns: newColumns);
//       updateProject(projectId, updatedProject);
//     }
//   }

//   void deleteColumn(String projectId, int columnIndex) {
//     final project = getProject(projectId);
//     if (project != null && columnIndex < project.columns.length) {
//       final newColumns = [...project.columns]..removeAt(columnIndex);
//       final updatedProject = project.copyWith(columns: newColumns);
//       updateProject(projectId, updatedProject);
//     }
//   }

//   // Task operations for a specific project and column
//   void addTask(String projectId, int columnIndex, TaskData task) {
//     final project = getProject(projectId);
//     if (project != null && columnIndex < project.columns.length) {
//       final column = project.columns[columnIndex];
//       final updatedColumn = column.copyWith(
//         tasks: [...column.tasks, task],
//       );
//       updateColumn(projectId, columnIndex, updatedColumn);
//     }
//   }

//   void moveTask(
//     String projectId,
//     TaskData task,
//     int sourceColumnIndex,
//     int targetColumnIndex,
//     int targetPosition,
//   ) {
//     final project = getProject(projectId);
//     if (project == null) return;

//     final newColumns = [...project.columns];
//     final sourceColumn = newColumns[sourceColumnIndex];
//     final targetColumn = newColumns[targetColumnIndex];

//     // Remove from source
//     final sourceTasks = [...sourceColumn.tasks]..remove(task);
//     final updatedSourceColumn = sourceColumn.copyWith(tasks: sourceTasks);

//     // Insert into target
//     final targetTasks = [...targetColumn.tasks];
//     final safePosition = targetPosition.clamp(0, targetTasks.length);
//     targetTasks.insert(safePosition, task);
//     final updatedTargetColumn = targetColumn.copyWith(tasks: targetTasks);

//     // Update columns
//     newColumns[sourceColumnIndex] = updatedSourceColumn;
//     newColumns[targetColumnIndex] = updatedTargetColumn;

//     final updatedProject = project.copyWith(columns: newColumns);
//     updateProject(projectId, updatedProject);
//   }

//   void updateTask(
//     String projectId,
//     int columnIndex,
//     int taskIndex,
//     TaskData updatedTask,
//   ) {
//     final project = getProject(projectId);
//     if (project != null && columnIndex < project.columns.length) {
//       final column = project.columns[columnIndex];
//       if (taskIndex < column.tasks.length) {
//         final newTasks = [...column.tasks];
//         newTasks[taskIndex] = updatedTask;
//         final updatedColumn = column.copyWith(tasks: newTasks);
//         updateColumn(projectId, columnIndex, updatedColumn);
//       }
//     }
//   }

//   void deleteTask(String projectId, int columnIndex, int taskIndex) {
//     final project = getProject(projectId);
//     if (project != null && columnIndex < project.columns.length) {
//       final column = project.columns[columnIndex];
//       if (taskIndex < column.tasks.length) {
//         final newTasks = [...column.tasks]..removeAt(taskIndex);
//         final updatedColumn = column.copyWith(tasks: newTasks);
//         updateColumn(projectId, columnIndex, updatedColumn);
//       }
//     }
//   }
// }

// // Provider for a single project (derived state)
// final projectProvider = Provider.family<Project?, String>((ref, projectId) {
//   final projects = ref.watch(projectsProvider);
//   return projects.firstWhere((p) => p.id == projectId, orElse: () => null);
// });

// // Provider for project columns
// final projectColumnsProvider = Provider.family<List<ColumnData>, String>((ref, projectId) {
//   final project = ref.watch(projectProvider(projectId));
//   return project?.columns ?? [];
// });

// // screens/default_screen.dart
// class _DefaultScreen extends ConsumerState<DefaultScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final projects = ref.watch(projectsProvider);
//     final router = ref.watch(routerProvider); // if using go_router

//     return Scaffold(
//       headers: [
//         AppBar(
//           title: const Text("Your Kanban Board"),
//           trailing: [
//             // ... existing widgets ...
//             PrimaryButton(
//               onPressed: () {
//                 router.push('/create-project'); // Navigate to create project
//               },
//               leading: const Icon(LucideIcons.plus, size: 16),
//               child: const Text("Create"),
//             ),
//             // ... rest of AppBar widgets ...
//           ],
//         ),
//         const Divider(),
//       ],
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: GridView.builder(
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 3,
//             childAspectRatio: 1.5,
//           ),
//           itemCount: projects.length,
//           itemBuilder: (context, index) {
//             final project = projects[index];
//             return ProjectCard(
//               onTap: () {
//                 // Navigate to project detail
//                 context.push('/project/${project.id}');
//               },
//               title: project.title,
//               description: project.description,
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// // screens/project_board_screen.dart
// class ProjectBoardScreen extends ConsumerStatefulWidget {
//   final String projectId;

//   const ProjectBoardScreen({
//     super.key,
//     required this.projectId,
//   });

//   @override
//   ConsumerState<ProjectBoardScreen> createState() => _ProjectBoardScreenState();
// }

// class _ProjectBoardScreenState extends ConsumerState<ProjectBoardScreen> {
//   final scrollController = ScrollController();

//   @override
//   Widget build(BuildContext context) {
//     final project = ref.watch(projectProvider(widget.projectId));
//     final columns = ref.watch(projectColumnsProvider(widget.projectId));
//     final notifier = ref.read(projectsProvider.notifier);

//     if (project == null) {
//       return const Center(child: Text('Project not found'));
//     }

//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 IconButton.outline(
//                   onPressed: () => Navigator.pop(context),
//                   density: ButtonDensity.iconDense,
//                   icon: const Icon(LucideIcons.chevronLeft),
//                 ),
//                 gap(8),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(project.title).x2Large.bold,
//                     gap(8),
//                     Text(project.description).muted,
//                   ],
//                 ),
//                 const Spacer(),
//                 AvatarGroup.toLeft(
//                   children: project.teamMembers.map((member) {
//                     return Avatar(
//                       initials: Avatar.getInitials(member.name),
//                       provider: member.avatarUrl != null
//                           ? NetworkImage(member.avatarUrl!)
//                           : null,
//                       size: 32,
//                     );
//                   }).toList(),
//                 ),
//               ],
//             ),
//             gap(16),
//             Scrollbar(
//               controller: scrollController,
//               interactive: true,
//               child: SingleChildScrollView(
//                 controller: scrollController,
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     for (int colIndex = 0; colIndex < columns.length; colIndex++)
//                       KanbanColumn(
//                         projectId: widget.projectId,
//                         colIndex: colIndex,
//                       ),
//                     // Add column button
//                     _buildAddColumnButton(),
//                   ],
//                 ).gap(16),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAddColumnButton() {
//     return Container(
//       width: 360,
//       height: 100,
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.withOpacity(0.3)),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: InkWell(
//         onTap: () {
//           // Show dialog to add new column
//           _showAddColumnDialog();
//         },
//         borderRadius: BorderRadius.circular(12),
//         child: const Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(LucideIcons.plus),
//               SizedBox(height: 8),
//               Text('Add Column'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showAddColumnDialog() {
//     // Implement dialog for adding a new column
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Add Column'),
//         content: TextField(
//           decoration: const InputDecoration(
//             hintText: 'Column title',
//           ),
//           onSubmitted: (value) {
//             if (value.isNotEmpty) {
//               final notifier = ref.read(projectsProvider.notifier);
//               notifier.addColumn(
//                 widget.projectId,
//                 ColumnData(title: value, tasks: []),
//               );
//               Navigator.pop(context);
//             }
//           },
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               // Get the text field value
//               final textField = context.findAncestorWidgetOfExactType<TextField>();
//               // Implement proper way to get value
//               Navigator.pop(context);
//             },
//             child: const Text('Add'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // widgets/kanban_column.dart
// class KanbanColumn extends ConsumerStatefulWidget {
//   final String projectId;
//   final int colIndex;

//   const KanbanColumn({
//     super.key,
//     required this.projectId,
//     required this.colIndex,
//   });

//   @override
//   ConsumerState<KanbanColumn> createState() => _KanbanColumnState();
// }

// class _KanbanColumnState extends ConsumerState<KanbanColumn> {
//   @override
//   Widget build(BuildContext context) {
//     final columns = ref.watch(projectColumnsProvider(widget.projectId));
//     final notifier = ref.read(projectsProvider.notifier);

//     if (widget.colIndex >= columns.length) {
//       return const SizedBox.shrink();
//     }

//     final column = columns[widget.colIndex];

//     return Container(
//       width: 360,
//       decoration: BoxDecoration(
//         color: Colors.gray.shade100,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Text(column.title),
//               gap(8),
//               PrimaryBadge(child: Text("${column.tasks.length}")),
//               const Spacer(),
//               IconButton.ghost(
//                 onPressed: () {
//                   // Show column options menu
//                   _showColumnOptions();
//                 },
//                 icon: const Icon(LucideIcons.ellipsis),
//               ),
//             ],
//           ),
//           ListView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: column.tasks.length,
//             itemBuilder: (context, taskIndex) {
//               final task = column.tasks[taskIndex];
//               return KanbanColumnItem(
//                 task: task,
//                 onTap: () {
//                   // Navigate to task detail
//                 },
//               );
//             },
//           ),
//           _buildAddTaskButton(),
//         ].gap(16),
//       ),
//     );
//   }

//   Widget _buildAddTaskButton() {
//     return MouseRegion(
//       cursor: SystemMouseCursors.click,
//       child: GestureDetector(
//         onTap: () => _showAddTaskDialog(),
//         child: Container(
//           width: double.infinity,
//           height: 64,
//           decoration: BoxDecoration(
//             border: Border.all(
//               color: Theme.of(context).colorScheme.border,
//             ),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: const Center(
//             child: Icon(LucideIcons.plus, color: Colors.gray),
//           ),
//         ),
//       ),
//     );
//   }

//   void _showColumnOptions() {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) => SafeArea(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: const Icon(LucideIcons.edit),
//               title: const Text('Edit Column'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _showEditColumnDialog();
//               },
//             ),
//             ListTile(
//               leading: const Icon(LucideIcons.trash, color: Colors.red),
//               title: const Text('Delete Column', style: TextStyle(color: Colors.red)),
//               onTap: () {
//                 Navigator.pop(context);
//                 _confirmDeleteColumn();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showEditColumnDialog() {
//     final column = ref.watch(projectColumnsProvider(widget.projectId))[widget.colIndex];
//     final controller = TextEditingController(text: column.title);

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Edit Column'),
//         content: TextField(
//           controller: controller,
//           decoration: const InputDecoration(
//             hintText: 'Column title',
//           ),
//           autofocus: true,
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               if (controller.text.isNotEmpty) {
//                 final notifier = ref.read(projectsProvider.notifier);
//                 final updatedColumn = column.copyWith(title: controller.text);
//                 notifier.updateColumn(
//                   widget.projectId,
//                   widget.colIndex,
//                   updatedColumn,
//                 );
//                 Navigator.pop(context);
//               }
//             },
//             child: const Text('Save'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _confirmDeleteColumn() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete Column'),
//         content: const Text('Are you sure you want to delete this column and all its tasks?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               final notifier = ref.read(projectsProvider.notifier);
//               notifier.deleteColumn(widget.projectId, widget.colIndex);
//               Navigator.pop(context);
//             },
//             style: TextButton.styleFrom(foregroundColor: Colors.red),
//             child: const Text('Delete'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showAddTaskDialog() {
//     // Implement add task dialog
//     showDialog(
//       context: context,
//       builder: (context) => const AddTaskDialog(),
//     ).then((task) {
//       if (task != null) {
//         final notifier = ref.read(projectsProvider.notifier);
//         notifier.addTask(widget.projectId, widget.colIndex, task);
//       }
//     });
//   }
// }

// // widgets/add_task_dialog.dart
// class AddTaskDialog extends StatefulWidget {
//   const AddTaskDialog({super.key});

//   @override
//   State<AddTaskDialog> createState() => _AddTaskDialogState();
// }

// class _AddTaskDialogState extends State<AddTaskDialog> {
//   final titleController = TextEditingController();
//   final descriptionController = TextEditingController();
//   Priority selectedPriority = Priority.medium;
//   DateTime? dueDate;
//   List<Tag> selectedTags = [];

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Add Task'),
//       content: SizedBox(
//         width: 500,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: titleController,
//               decoration: const InputDecoration(
//                 labelText: 'Title',
//                 hintText: 'Enter task title',
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: descriptionController,
//               decoration: const InputDecoration(
//                 labelText: 'Description',
//                 hintText: 'Enter task description',
//               ),
//               maxLines: 3,
//             ),
//             const SizedBox(height: 16),
//             DropdownButtonFormField<Priority>(
//               value: selectedPriority,
//               decoration: const InputDecoration(labelText: 'Priority'),
//               items: Priority.values.map((priority) {
//                 return DropdownMenuItem(
//                   value: priority,
//                   child: Row(
//                     children: [
//                       Container(
//                         width: 12,
//                         height: 12,
//                         decoration: BoxDecoration(
//                           color: priority.color,
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Text(priority.label),
//                     ],
//                   ),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 if (value != null) {
//                   setState(() {
//                     selectedPriority = value;
//                   });
//                 }
//               },
//             ),
//             const SizedBox(height: 16),
//             // Add more fields for tags, assignees, due date, etc.
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text('Cancel'),
//         ),
//         TextButton(
//           onPressed: () {
//             if (titleController.text.isNotEmpty) {
//               final task = TaskData(
//                 title: titleController.text,
//                 description: descriptionController.text,
//                 tags: selectedTags,
//                 priority: selectedPriority,
//                 dueDate: dueDate,
//               );
//               Navigator.pop(context, task);
//             }
//           },
//           child: const Text('Add'),
//         ),
//       ],
//     );
//   }

//   @override
//   void dispose() {
//     titleController.dispose();
//     descriptionController.dispose();
//     super.dispose();
//   }
// }

// // screens/create_new_project_screen.dart
// class CreateNewProjectScreen extends ConsumerStatefulWidget {
//   const CreateNewProjectScreen({super.key});

//   @override
//   ConsumerState<CreateNewProjectScreen> createState() => _CreateNewProjectScreenState();
// }

// class _CreateNewProjectScreenState extends ConsumerState<CreateNewProjectScreen> {
//   final titleController = TextEditingController();
//   final descriptionController = TextEditingController();
//   List<String> selectedTags = [];
//   DateTime? startDate;
//   DateTime? endDate;
//   List<TeamMember> teamMembers = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Create New Project'),
//         leading: IconButton(
//           icon: const Icon(LucideIcons.chevronLeft),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Center(
//           child: SizedBox(
//             width: 800,
//             child: Form(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   TextField(
//                     controller: titleController,
//                     decoration: const InputDecoration(
//                       labelText: 'Title',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   TextField(
//                     controller: descriptionController,
//                     decoration: const InputDecoration(
//                       labelText: 'Description',
//                       border: OutlineInputBorder(),
//                     ),
//                     maxLines: 4,
//                   ),
//                   const SizedBox(height: 16),
//                   // Tags field
//                   // Timeline pickers
//                   // Team members
//                   const SizedBox(height: 24),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       OutlineButton(
//                         onPressed: () => Navigator.pop(context),
//                         child: const Text('Cancel'),
//                       ),
//                       const SizedBox(width: 8),
//                       PrimaryButton(
//                         onPressed: _createProject,
//                         child: const Text('Create Project'),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _createProject() {
//     if (titleController.text.isEmpty) return;

//     final project = Project(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       title: titleController.text,
//       description: descriptionController.text,
//       columns: [
//         ColumnData(title: 'To Do', tasks: []),
//         ColumnData(title: 'In Progress', tasks: []),
//         ColumnData(title: 'Review', tasks: []),
//         ColumnData(title: 'Done', tasks: []),
//       ],
//       tags: selectedTags,
//       teamMembers: teamMembers,
//     );

//     ref.read(projectsProvider.notifier).addProject(project);
//     Navigator.pop(context);
//   }

//   @override
//   void dispose() {
//     titleController.dispose();
//     descriptionController.dispose();
//     super.dispose();
//   }
// }
