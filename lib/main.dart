import 'package:fl_kanban/providers/router_provider.dart';
import 'package:fl_kanban/providers/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

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
      key: ValueKey(themeMode),
      debugShowCheckedModeBanner: false,
      title: "Your Kanban Board",
      theme: ThemeData(colorScheme: ColorSchemes.lightNeutral),
      darkTheme: ThemeData(colorScheme: ColorSchemes.darkNeutral),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}

// import 'package:shadcn_flutter/shadcn_flutter.dart';

// class KanbanData {
//   final String id;
//   final String title;
//   final String description;
//   final ProjectStatus status;
//   final Color backgroundColor;
//   final Color foregroundColor;
//   final String dueDate;
//   final List<SortableData<KanbanColumnData>> columns;

//   const KanbanData({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.status,
//     this.backgroundColor = const Color(0xFFE0F2FE),
//     this.foregroundColor = const Color(0xFF075985),
//     required this.dueDate,
//     required this.columns,
//   });

//   KanbanData copyWith({
//     String? id,
//     String? title,
//     String? description,
//     ProjectStatus? status,
//     Color? backgroundColor,
//     Color? foregroundColor,
//     String? dueDate,
//     List<SortableData<KanbanColumnData>>? columns,
//   }) {
//     return KanbanData(
//       id: id ?? this.id,
//       title: title ?? this.title,
//       description: description ?? this.description,
//       status: status ?? this.status,
//       backgroundColor: backgroundColor ?? this.backgroundColor,
//       foregroundColor: foregroundColor ?? this.foregroundColor,
//       dueDate: dueDate ?? this.dueDate,
//       columns: columns ?? this.columns,
//     );
//   }
// }

// class KanbanColumnData {
//   final String id;
//   final String title;
//   final List<SortableData<KanbanTaskData>> tasks;

//   KanbanColumnData({
//     required this.id,
//     required this.title,
//     required this.tasks,
//   });

//   KanbanColumnData copyWith({
//     String? id,
//     String? title,
//     List<SortableData<KanbanTaskData>>? tasks,
//   }) {
//     return KanbanColumnData(
//       id: id ?? this.id,
//       title: title ?? this.title,
//       tasks: tasks ?? this.tasks,
//     );
//   }
// }

// class KanbanTaskData {
//   final String id;
//   final String title;
//   final String description;
//   final TaskPriority priority;
//   final Color? color;
//   final DateTime? dueDate;

//   KanbanTaskData({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.priority,
//     this.color,
//     this.dueDate,
//   });

//   KanbanTaskData copyWith({
//     String? id,
//     String? title,
//     String? description,
//     TaskPriority? priority,
//     Color? color,
//     DateTime? dueDate,
//   }) {
//     return KanbanTaskData(
//       id: id ?? this.id,
//       title: title ?? this.title,
//       description: description ?? this.description,
//       priority: priority ?? this.priority,
//       color: color ?? this.color,
//       dueDate: dueDate ?? this.dueDate,
//     );
//   }

//   Color get effectiveColor => color ?? priority.color;
// }

// enum TaskPriority { high, medium, low }

// extension TaskPriorityExtension on TaskPriority {
//   String get displayName {
//     switch (this) {
//       case TaskPriority.high:
//         return "High";
//       case TaskPriority.medium:
//         return "Medium";
//       case TaskPriority.low:
//         return "Low";
//     }
//   }

//   Color get color {
//     switch (this) {
//       case TaskPriority.high:
//         return Colors.red;
//       case TaskPriority.medium:
//         return Colors.orange;
//       case TaskPriority.low:
//         return Colors.green;
//     }
//   }
// }

// enum ProjectStatus { delayed, inProgress, completed }

// extension ProjectStatusExtension on ProjectStatus {
//   String get displayName {
//     switch (this) {
//       case ProjectStatus.delayed:
//         return "Delayed";
//       case ProjectStatus.inProgress:
//         return "In Progress";
//       case ProjectStatus.completed:
//         return "Completed";
//     }
//   }

//   Color get color {
//     switch (this) {
//       case ProjectStatus.delayed:
//         return Colors.red;
//       case ProjectStatus.inProgress:
//         return Colors.orange;
//       case ProjectStatus.completed:
//         return Colors.green;
//     }
//   }
// }

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:kanban/models/models.dart';
// import 'package:shadcn_flutter/shadcn_flutter.dart';

// final kanbanProvider = NotifierProvider<KanbanNotifier, List<KanbanData>>(
//   KanbanNotifier.new,
// );

// class KanbanNotifier extends Notifier<List<KanbanData>> {
//   String _searchQuery = "";
//   String _taskSearchQuery = "";

//   String get searchQuery => _searchQuery;
//   String get taskSearchQuery => _taskSearchQuery;

//   @override
//   List<KanbanData> build() {
//     return [
//       KanbanData(
//         id: "1",
//         title: "Alpha Redesign",
//         description:
//             "Complete overhaul of the core user interface focusing on accessbility.",
//         status: ProjectStatus.inProgress,
//         backgroundColor: const Color(0xFFE0F2FE),
//         foregroundColor: const Color(0xFF075985),
//         dueDate: "3 days left",
//         columns: [
//           SortableData(
//             KanbanColumnData(
//               id: "1",
//               title: "To Do",
//               tasks: [
//                 SortableData(
//                   KanbanTaskData(
//                     id: "1",
//                     title: "Competitor Spatial Analysis",
//                     description:
//                         "Benchmarking the ease of movement in competing architect platforms.",
//                     priority: TaskPriority.high,
//                     color: Colors.red,
//                     dueDate: DateTime(2026, 4, 10),
//                   ),
//                 ),
//                 SortableData(
//                   KanbanTaskData(
//                     id: "2",
//                     title: "V3 Iconography Pack",
//                     description:
//                         "Exporting all stroke-based icons for the new shadcn library.",
//                     priority: TaskPriority.medium,
//                     color: Colors.orange,
//                     dueDate: DateTime(2026, 4, 10),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SortableData(
//             KanbanColumnData(
//               id: "2",
//               title: "In Progress",
//               tasks: [
//                 SortableData(
//                   KanbanTaskData(
//                     id: "3",
//                     title: "Kinetic Physics Engine",
//                     description:
//                         "Refining the spring animations for the dashboard cards transitions.",
//                     priority: TaskPriority.low,
//                     color: Colors.green,
//                     dueDate: DateTime(2026, 4, 10),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SortableData(
//             KanbanColumnData(
//               id: "3",
//               title: "Review",
//               tasks: [
//                 SortableData(
//                   KanbanTaskData(
//                     id: "4",
//                     title: "Auth Flow Refactor",
//                     description:
//                         "Security audit and 2FA implementation for enterprise users.",
//                     priority: TaskPriority.high,
//                     color: Colors.red,
//                     dueDate: DateTime(2026, 4, 10),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       KanbanData(
//         id: "2",
//         title: "Q3 Marketing Site",
//         description: "Brand expansion for the new enterprise tier launch.",
//         status: ProjectStatus.completed,
//         backgroundColor: Color(0xFFDCFCE7),
//         foregroundColor: Color(0xFF166534),
//         dueDate: "3 days left",
//         columns: [
//           SortableData(
//             KanbanColumnData(
//               id: "1",
//               title: "To Do",
//               tasks: [
//                 SortableData(
//                   KanbanTaskData(
//                     id: "1",
//                     title: "Competitor Spatial Analysis",
//                     description:
//                         "Benchmarking the ease of movement in competing architect platforms.",
//                     priority: TaskPriority.high,
//                     color: Colors.red,
//                     dueDate: DateTime(2026, 4, 10),
//                   ),
//                 ),
//                 SortableData(
//                   KanbanTaskData(
//                     id: "2",
//                     title: "V3 Iconography Pack",
//                     description:
//                         "Exporting all stroke-based icons for the new shadcn library.",
//                     priority: TaskPriority.medium,
//                     color: Colors.orange,
//                     dueDate: DateTime(2026, 4, 10),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SortableData(
//             KanbanColumnData(
//               id: "2",
//               title: "In Progress",
//               tasks: [
//                 SortableData(
//                   KanbanTaskData(
//                     id: "3",
//                     title: "Kinetic Physics Engine",
//                     description:
//                         "Refining the spring animations for the dashboard cards transitions.",
//                     priority: TaskPriority.low,
//                     color: Colors.green,
//                     dueDate: DateTime(2026, 4, 10),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SortableData(
//             KanbanColumnData(
//               id: "3",
//               title: "Review",
//               tasks: [
//                 SortableData(
//                   KanbanTaskData(
//                     id: "4",
//                     title: "Auth Flow Refactor",
//                     description:
//                         "Security audit and 2FA implementation for enterprise users.",
//                     priority: TaskPriority.high,
//                     color: Colors.red,
//                     dueDate: DateTime(2026, 4, 10),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       KanbanData(
//         id: "3",
//         title: "API Documentation",
//         description: "Developing a new Swagger-based documentation system.",
//         status: ProjectStatus.delayed,
//         backgroundColor: Color(0xFFFEE2E2),
//         foregroundColor: Color(0xFF991B1B),
//         dueDate: "3 days left",
//         columns: [
//           SortableData(
//             KanbanColumnData(
//               id: "1",
//               title: "To Do",
//               tasks: [
//                 SortableData(
//                   KanbanTaskData(
//                     id: "1",
//                     title: "Competitor Spatial Analysis",
//                     description:
//                         "Benchmarking the ease of movement in competing architect platforms.",
//                     priority: TaskPriority.high,
//                     color: Colors.red,
//                     dueDate: DateTime(2026, 4, 10),
//                   ),
//                 ),
//                 SortableData(
//                   KanbanTaskData(
//                     id: "2",
//                     title: "V3 Iconography Pack",
//                     description:
//                         "Exporting all stroke-based icons for the new shadcn library.",
//                     priority: TaskPriority.medium,
//                     color: Colors.orange,
//                     dueDate: DateTime(2026, 4, 10),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SortableData(
//             KanbanColumnData(
//               id: "2",
//               title: "In Progress",
//               tasks: [
//                 SortableData(
//                   KanbanTaskData(
//                     id: "3",
//                     title: "Kinetic Physics Engine",
//                     description:
//                         "Refining the spring animations for the dashboard cards transitions.",
//                     priority: TaskPriority.low,
//                     color: Colors.green,
//                     dueDate: DateTime(2026, 4, 10),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SortableData(
//             KanbanColumnData(
//               id: "3",
//               title: "Review",
//               tasks: [
//                 SortableData(
//                   KanbanTaskData(
//                     id: "4",
//                     title: "Auth Flow Refactor",
//                     description:
//                         "Security audit and 2FA implementation for enterprise users.",
//                     priority: TaskPriority.high,
//                     color: Colors.red,
//                     dueDate: DateTime(2026, 4, 10),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       KanbanData(
//         id: "4",
//         title: "Security Audit",
//         description:
//             "Quarterly review of our infastructure and data encryption.",
//         status: ProjectStatus.inProgress,
//         backgroundColor: const Color(0xFFE0F2FE),
//         foregroundColor: const Color(0xFF075985),
//         dueDate: "3 days left",
//         columns: [
//           SortableData(
//             KanbanColumnData(
//               id: "1",
//               title: "To Do",
//               tasks: [
//                 SortableData(
//                   KanbanTaskData(
//                     id: "1",
//                     title: "Competitor Spatial Analysis",
//                     description:
//                         "Benchmarking the ease of movement in competing architect platforms.",
//                     priority: TaskPriority.high,
//                     color: Colors.red,
//                     dueDate: DateTime(2026, 4, 10),
//                   ),
//                 ),
//                 SortableData(
//                   KanbanTaskData(
//                     id: "2",
//                     title: "V3 Iconography Pack",
//                     description:
//                         "Exporting all stroke-based icons for the new shadcn library.",
//                     priority: TaskPriority.medium,
//                     color: Colors.orange,
//                     dueDate: DateTime(2026, 4, 10),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SortableData(
//             KanbanColumnData(
//               id: "2",
//               title: "In Progress",
//               tasks: [
//                 SortableData(
//                   KanbanTaskData(
//                     id: "3",
//                     title: "Kinetic Physics Engine",
//                     description:
//                         "Refining the spring animations for the dashboard cards transitions.",
//                     priority: TaskPriority.low,
//                     color: Colors.green,
//                     dueDate: DateTime(2026, 4, 10),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SortableData(
//             KanbanColumnData(
//               id: "3",
//               title: "Review",
//               tasks: [
//                 SortableData(
//                   KanbanTaskData(
//                     id: "4",
//                     title: "Auth Flow Refactor",
//                     description:
//                         "Security audit and 2FA implementation for enterprise users.",
//                     priority: TaskPriority.high,
//                     color: Colors.red,
//                     dueDate: DateTime(2026, 4, 10),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     ];
//   }

//   List<KanbanData> get filteredProjects {
//     if (_searchQuery.isEmpty) {
//       return state;
//     }

//     final query = _searchQuery.trim().toLowerCase();
//     return state.where((project) {
//       return project.title.toLowerCase().contains(query) ||
//           project.description.toLowerCase().contains(query);
//     }).toList();
//   }

//   List<SortableData<KanbanColumnData>> getFilteredColumns(String projectId) {
//     final project = state.firstWhere((p) => p.id == projectId);

//     if (_taskSearchQuery.isEmpty) {
//       return project.columns;
//     }

//     final query = _taskSearchQuery.trim().toLowerCase();

//     // Filter tasks in each column
//     return project.columns.map((column) {
//       final filteredTasks = column.data.tasks.where((task) {
//         return task.data.title.toLowerCase().contains(query) ||
//             task.data.description.toLowerCase().contains(query);
//       }).toList();

//       return SortableData(column.data.copyWith(tasks: filteredTasks));
//     }).toList();
//   }

//   void updateSearchQuery(String query) {
//     _searchQuery = query;
//     state = [...state];
//   }

//   void updateTaskSearchQuery(String query) {
//     _taskSearchQuery = query;
//     state = [...state];
//   }

//   void moveTask(
//     SortableData<KanbanTaskData> task,
//     int targetColumnIndex,
//     int targetTaskIndex,
//   ) {
//     final projects = [...state];
//     if (projects.isEmpty) return;

//     final columns = List<SortableData<KanbanColumnData>>.from(
//       projects[0].columns,
//     );

//     SortableData<KanbanTaskData>? removedTask;
//     int sourceColumnIndex = -1;

//     // Find and remove the task
//     for (int i = 0; i < columns.length; i++) {
//       final taskIndex = columns[i].data.tasks.indexWhere((t) => t == task);
//       if (taskIndex != -1) {
//         removedTask = columns[i].data.tasks.removeAt(taskIndex);
//         sourceColumnIndex = i;
//         break;
//       }
//     }

//     if (removedTask == null) return;

//     // Insert at new position
//     final targetColumn = columns[targetColumnIndex];
//     if (targetTaskIndex >= targetColumn.data.tasks.length) {
//       targetColumn.data.tasks.add(removedTask);
//     } else {
//       targetColumn.data.tasks.insert(targetTaskIndex, removedTask);
//     }

//     // Update state
//     state = [projects[0].copyWith(columns: columns), ...projects.skip(1)];
//   }

//   void addTask(String projectId, String columnId, KanbanTaskData task) {
//     final projects = [...state];
//     final projectIndex = projects.indexWhere((p) => p.id == projectId);

//     if (projectIndex == -1) return;

//     final columns = List<SortableData<KanbanColumnData>>.from(
//       projects[projectIndex].columns,
//     );
//     final columnIndex = columns.indexWhere((c) => c.data.id == columnId);

//     if (columnIndex != -1) {
//       // Wrap the new task in SortableData
//       columns[columnIndex].data.tasks.add(SortableData(task));
//       state = [
//         ...projects.take(projectIndex),
//         projects[projectIndex].copyWith(columns: columns),
//         ...projects.skip(projectIndex + 1),
//       ];
//     }
//   }

//   void editTask(
//     String projectId,
//     String columnId,
//     String taskId,
//     KanbanTaskData updatedTask,
//   ) {
//     final projects = [...state];
//     final projectIndex = projects.indexWhere((p) => p.id == projectId);

//     if (projectIndex == -1) return;

//     final columns = List<SortableData<KanbanColumnData>>.from(
//       projects[projectIndex].columns,
//     );
//     final columnIndex = columns.indexWhere((c) => c.data.id == columnId);

//     if (columnIndex != -1) {
//       final taskIndex = columns[columnIndex].data.tasks.indexWhere(
//         (t) => t.data.id == taskId,
//       );
//       if (taskIndex != -1) {
//         columns[columnIndex].data.tasks[taskIndex] = SortableData(updatedTask);
//         state = [
//           ...projects.take(projectIndex),
//           projects[projectIndex].copyWith(columns: columns),
//           ...projects.skip(projectIndex + 1),
//         ];
//       }
//     }
//   }

//   void deleteTask(String projectId, String columnId, String taskId) {
//     final projects = [...state];
//     final projectIndex = projects.indexWhere((p) => p.id == projectId);

//     if (projectIndex == -1) return;

//     final columns = List<SortableData<KanbanColumnData>>.from(
//       projects[projectIndex].columns,
//     );
//     final columnIndex = columns.indexWhere((c) => c.data.id == columnId);

//     if (columnIndex != -1) {
//       columns[columnIndex].data.tasks.removeWhere((t) => t.data.id == taskId);
//       state = [
//         ...projects.take(projectIndex),
//         projects[projectIndex].copyWith(columns: columns),
//         ...projects.skip(projectIndex + 1),
//       ];
//     }
//   }

//   void addColumn(String projectId, KanbanColumnData column) {
//     final projects = [...state];
//     final projectIndex = projects.indexWhere((p) => p.id == projectId);

//     if (projectIndex == -1) return;

//     final columns = List<SortableData<KanbanColumnData>>.from(
//       projects[projectIndex].columns,
//     );
//     // Wrap the new column in SortableData
//     columns.add(SortableData(column));

//     // Update the project with new columns
//     state = [
//       ...projects.take(projectIndex),
//       projects[projectIndex].copyWith(columns: columns),
//       ...projects.skip(projectIndex + 1),
//     ];
//   }

//   void editColumn(String projectId, String columnId, String newTitle) {
//     final projects = [...state];
//     final projectIndex = projects.indexWhere((p) => p.id == projectId);

//     if (projectIndex == -1) return;

//     final columns = List<SortableData<KanbanColumnData>>.from(
//       projects[projectIndex].columns,
//     );
//     final columnIndex = columns.indexWhere((c) => c.data.id == columnId);

//     if (columnIndex != -1) {
//       final updatedColumn = columns[columnIndex].data.copyWith(title: newTitle);
//       columns[columnIndex] = SortableData(updatedColumn);
//       state = [
//         ...projects.take(projectIndex),
//         projects[projectIndex].copyWith(columns: columns),
//         ...projects.skip(projectIndex + 1),
//       ];
//     }
//   }

//   void deleteColumn(String projectId, String columnId) {
//     final projects = [...state];
//     final projectIndex = projects.indexWhere((p) => p.id == projectId);

//     if (projectIndex == -1) return;

//     final columns = List<SortableData<KanbanColumnData>>.from(
//       projects[projectIndex].columns,
//     );
//     columns.removeWhere((c) => c.data.id == columnId);

//     if (columns.isEmpty) {
//       columns.add(
//         SortableData(
//           KanbanColumnData(
//             id: DateTime.now().millisecondsSinceEpoch.toString(),
//             title: "To Do",
//             tasks: [],
//           ),
//         ),
//       );
//     }

//     state = [
//       ...projects.take(projectIndex),
//       projects[projectIndex].copyWith(columns: columns),
//       ...projects.skip(projectIndex + 1),
//     ];
//   }

//   void addProject(KanbanData project) {
//     state = [...state, project];
//   }

//   void editProject(String projectId, KanbanData updatedProject) {
//     final projectIndex = state.indexWhere((p) => p.id == projectId);

//     if (projectIndex != -1) {
//       state = [
//         ...state.take(projectIndex),
//         updatedProject,
//         ...state.skip(projectIndex + 1),
//       ];
//     }
//   }

//   void deleteProject(String projectId) {
//     state = state.where((p) => p.id != projectId).toList();
//   }
// }

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:kanban/screens/home_screen.dart';
// import 'package:kanban/screens/kanban_board_screen.dart';
// import 'package:kanban/shared/app_scaffold.dart';

// final routerProvider = Provider<GoRouter>((ref) {
//   return GoRouter(
//     initialLocation: "/",
//     routes: [
//       ShellRoute(
//         builder: (context, state, child) {
//           final showBackButton = state.uri.path != "/";
//           return AppScaffold(showBackButton: showBackButton, child: child);
//         },
//         routes: [
//           GoRoute(
//             path: "/",
//             name: "projects",
//             builder: (context, state) => const HomeScreen(),
//           ),
//           GoRoute(
//             path: "/projects/:id",
//             name: "kanbanProjectDetail",
//             builder: (context, state) {
//               final projectId = state.pathParameters["id"]!;
//               return KanbanBoardScreen(projectId: projectId);
//             },
//           ),
//         ],
//       ),
//     ],
//   );
// });

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shadcn_flutter/shadcn_flutter.dart';

// final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(
//   ThemeNotifier.new,
// );

// class ThemeNotifier extends Notifier<ThemeMode> {
//   @override
//   ThemeMode build() {
//     return ThemeMode.light;
//   }

//   void toggle() {
//     state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
//   }
// }

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:kanban/models/models.dart';
// import 'package:kanban/providers/kanban_provider.dart';
// import 'package:kanban/shared/kanban_constants.dart';
// import 'package:kanban/widgets/badge.dart';
// import 'package:kanban/widgets/card_container.dart';
// import 'package:shadcn_flutter/shadcn_flutter.dart';
// import 'package:go_router/go_router.dart';

// class HomeScreen extends ConsumerStatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   ConsumerState<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends ConsumerState<HomeScreen> {
//   int tabIndex = 0;

//   final TextEditingController _searchController = TextEditingController();
//   final ScrollController scrollController = ScrollController();

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final projects = ref.watch(kanbanProvider);

//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         Flexible(
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text("Projects").large.bold,
//                         const Text(
//                           "Manage and track your projects.",
//                         ).small.muted,
//                       ],
//                     ),
//                     const Spacer(),
//                     Tabs(
//                       index: tabIndex,
//                       children: const [
//                         TabItem(child: Text("All")),
//                         TabItem(child: Text("Active")),
//                         TabItem(child: Text("Archived")),
//                       ],
//                       onChanged: (int value) {
//                         setState(() {
//                           tabIndex = value;
//                         });
//                       },
//                     ),
//                   ],
//                 ),

//                 const Gap(16),

//                 IndexedStack(
//                   index: tabIndex,
//                   children: [
//                     Wrap(
//                       spacing: 16,
//                       runSpacing: 16,
//                       children: [
//                         for (final board in projects)
//                           ProjectCard(
//                             onTap: () => context.pushNamed(
//                               "kanbanProjectDetail",
//                               pathParameters: {"id": board.id},
//                             ),
//                             projectId: board.id,
//                             title: board.title,
//                             description: board.description,
//                             status: board.status,
//                             backgroundColor: board.backgroundColor,
//                             foregroundColor: board.foregroundColor,
//                             dueDate: board.dueDate,
//                           ),
//                         const CreateProjectCard(),
//                       ],
//                     ),
//                     Column(children: [const Text("Active")]),
//                     Column(children: [const Text("Archived")]),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class ProjectCard extends ConsumerWidget {
//   final String projectId;
//   final VoidCallback? onTap;
//   final String title;
//   final String description;
//   final ProjectStatus status;
//   final Color backgroundColor;
//   final Color foregroundColor;
//   final String dueDate;

//   const ProjectCard({
//     super.key,
//     required this.projectId,
//     required this.onTap,
//     required this.title,
//     required this.description,
//     required this.status,
//     this.backgroundColor = const Color(0xFFE0F2FE),
//     this.foregroundColor = const Color(0xFF075985),
//     required this.dueDate,
//   });

//   List<AvatarWidget> getAvatars() {
//     return [
//       Avatar(
//         initials: Avatar.getInitials("TS"),
//         backgroundColor: Colors.red,
//         size: 24,
//       ),
//       Avatar(
//         initials: Avatar.getInitials("TS"),
//         backgroundColor: Colors.green,
//         size: 24,
//       ),
//       Avatar(
//         initials: Avatar.getInitials("TS"),
//         backgroundColor: Colors.blue,
//         size: 24,
//       ),
//       Avatar(
//         initials: Avatar.getInitials("TS"),
//         backgroundColor: Colors.yellow,
//         size: 24,
//       ),
//     ];
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return CardContainer(
//       onTap: onTap,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildHeader(),
//           const Gap(16),
//           Text(title).large.semiBold,
//           const Gap(16),
//           Text(description),
//           const Gap(16),
//           const Divider(),
//           const Gap(16),
//           _buildFooter(),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Row(
//       children: [
//         Badge(
//           text: status.displayName,
//           backgroundColor: backgroundColor,
//           foregroundColor: foregroundColor,
//         ),
//         const Spacer(),
//         Builder(
//           builder: (context) {
//             return IconButton.ghost(
//               onPressed: () {
//                 showDropdown(
//                   context: context,
//                   builder: (context) {
//                     return const DropdownMenu(
//                       children: [
//                         MenuLabel(child: Text("Actions")),
//                         MenuDivider(),
//                         MenuButton(child: Text("Edit")),
//                         MenuButton(child: Text("Delete")),
//                       ],
//                     );
//                   },
//                 );
//               },
//               icon: const Icon(LucideIcons.ellipsis, size: 16),
//             );
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildFooter() {
//     return Row(
//       children: [
//         AvatarGroup.toLeft(children: getAvatars()),
//         const Spacer(),
//         Text(dueDate).muted,
//       ],
//     );
//   }
// }

// class CreateProjectCard extends ConsumerWidget {
//   const CreateProjectCard({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return CardContainer(
//       onTap: () => _showNewProjectDialog(context, ref),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(LucideIcons.plus, size: 32),
//           const Gap(16),
//           const Text("Initiate Project").large.bold,
//           const Gap(16),
//           const Text("Ready to build something new?").muted.small,
//           const Text("Click here to start.").muted.small,
//         ],
//       ),
//     );
//   }

//   void _showNewProjectDialog(BuildContext context, WidgetRef ref) {
//     final formKey = GlobalKey<FormState>();
//     final titleController = TextEditingController();
//     final descriptionController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("New Project"),
//           content: NewProjectForm(
//             formKey: formKey,
//             titleController: titleController,
//             descriptionController: descriptionController,
//           ),
//           actions: [
//             OutlineButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel"),
//             ),
//             PrimaryButton(
//               onPressed: () {
//                 final newProject = KanbanData(
//                   id: DateTime.now().millisecondsSinceEpoch.toString(),
//                   title: titleController.text,
//                   description: descriptionController.text,
//                   status: ProjectStatus.inProgress,
//                   backgroundColor: const Color(0xFFE0F2FE),
//                   foregroundColor: const Color(0xFF075985),
//                   dueDate: "3 days left",
//                   columns: [],
//                 );

//                 ref.read(kanbanProvider.notifier).addProject(newProject);
//                 Navigator.pop(context);
//               },
//               child: const Text("Save"),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// class NewProjectForm extends ConsumerWidget {
//   final GlobalKey<FormState> formKey;
//   final TextEditingController titleController;
//   final TextEditingController descriptionController;

//   const NewProjectForm({
//     super.key,
//     required this.formKey,
//     required this.titleController,
//     required this.descriptionController,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return ConstrainedBox(
//       constraints: const BoxConstraints(maxWidth: 400),
//       child: Form(
//         key: formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             FormField(
//               key: const FormKey(#title),
//               label: const Text("Title"),
//               child: TextField(controller: titleController),
//             ),
//             const Gap(KanbanConstants.gapSize),
//             FormField(
//               key: const FormKey(#description),
//               label: const Text("Description"),
//               child: TextArea(controller: descriptionController, maxLines: 3),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:kanban/models/models.dart';
// import 'package:kanban/providers/kanban_provider.dart';
// import 'package:kanban/shared/kanban_constants.dart';
// import 'package:kanban/widgets/badge.dart';
// import 'package:kanban/widgets/card_container.dart';
// import 'package:shadcn_flutter/shadcn_flutter.dart';

// class KanbanBoardScreen extends ConsumerStatefulWidget {
//   final String projectId;

//   const KanbanBoardScreen({super.key, required this.projectId});

//   @override
//   ConsumerState<KanbanBoardScreen> createState() => _KanbanBoardScreen();
// }

// class _KanbanBoardScreen extends ConsumerState<KanbanBoardScreen> {
//   final TextEditingController _taskSearchController = TextEditingController();

//   @override
//   void dispose() {
//     _taskSearchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final projects = ref.watch(kanbanProvider);
//     final currentProject = projects.firstWhere(
//       (project) => project.id == widget.projectId,
//       orElse: () => projects.first,
//     );
//     final filteredColumns = ref
//         .read(kanbanProvider.notifier)
//         .getFilteredColumns(widget.projectId);

//     final notifier = ref.read(kanbanProvider.notifier);
//     final ScrollController scrollController = ScrollController();

//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(currentProject.title).large.bold,
//           Text(currentProject.description),

//           const Gap(16),

//           Scrollbar(
//             controller: scrollController,
//             thumbVisibility: true,
//             trackVisibility: true,
//             interactive: true,
//             child: SingleChildScrollView(
//               controller: scrollController,
//               scrollDirection: Axis.horizontal,
//               child: SortableLayer(
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     for (int i = 0; i < filteredColumns.length; i++)
//                       KanbanColumn(
//                         key: ValueKey(filteredColumns[i].data.id),
//                         projectId: widget.projectId,
//                         column: filteredColumns[i],
//                         columnIndex: i,
//                         onMoveTask: notifier.moveTask,
//                         isSearchActive: _taskSearchController.text.isNotEmpty,
//                       ),
//                     if (_taskSearchController.text.isEmpty)
//                       KanbanColumnEmpty(
//                         projectId: widget.projectId,
//                         onAddColumn: (title) {
//                           notifier.addColumn(
//                             widget.projectId,
//                             KanbanColumnData(
//                               id: DateTime.now().millisecondsSinceEpoch
//                                   .toString(),
//                               title: title,
//                               tasks: [],
//                             ),
//                           );
//                         },
//                       ),
//                   ],
//                 ).gap(KanbanConstants.gapSize),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class KanbanColumn extends ConsumerStatefulWidget {
//   final String projectId;
//   final SortableData<KanbanColumnData> column;
//   final int columnIndex;
//   final void Function(SortableData<KanbanTaskData>, int, int) onMoveTask;
//   final bool isSearchActive;

//   const KanbanColumn({
//     super.key,
//     required this.projectId,
//     required this.column,
//     required this.columnIndex,
//     required this.onMoveTask,
//     this.isSearchActive = false,
//   });

//   @override
//   ConsumerState<KanbanColumn> createState() => _KanbanColumnState();
// }

// class _KanbanColumnState extends ConsumerState<KanbanColumn> {
//   @override
//   Widget build(BuildContext context) {
//     final hasSearchResults =
//         widget.isSearchActive && widget.column.data.tasks.isNotEmpty;

//     return Container(
//       width: KanbanConstants.columnWidth,
//       height: widget.isSearchActive
//           ? MediaQuery.of(context).size.height - 155
//           : MediaQuery.of(context).size.height - 150,
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.card,
//         border: Border.all(
//           color: hasSearchResults
//               ? Theme.of(context).colorScheme.primary
//               : Theme.of(context).colorScheme.border,
//           width: hasSearchResults ? 2 : 1,
//         ),
//         borderRadius: BorderRadius.circular(KanbanConstants.borderRadius),
//       ),
//       padding: const EdgeInsets.all(KanbanConstants.columnPadding),
//       child: SortableDropFallback<KanbanTaskData>(
//         onAccept: widget.isSearchActive
//             ? null
//             : (value) {
//                 widget.onMoveTask(
//                   value,
//                   widget.columnIndex,
//                   widget.column.data.tasks.length,
//                 );
//               },
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             _buildColumnHeader(),
//             if (widget.isSearchActive && widget.column.data.tasks.isEmpty)
//               Expanded(child: Center(child: Text("No matching tasks").muted))
//             else
//               ..._buildTaskList(),
//             if (!widget.isSearchActive)
//               OutlineButton(
//                 onPressed: () => _showNewTaskDialog(context),
//                 alignment: Alignment.center,
//                 child: const Text("New Task"),
//               ),
//           ],
//         ).gap(KanbanConstants.gapSize),
//       ),
//     );
//   }

//   Widget _buildColumnHeader() {
//     return Row(
//       children: [
//         Text(widget.column.data.title),
//         const Gap(8),
//         PrimaryBadge(child: Text("${widget.column.data.tasks.length}")),
//         const Spacer(),
//         Builder(
//           builder: (context) {
//             return IconButton.ghost(
//               onPressed: () => _showColumnMenu(context),
//               icon: const Icon(LucideIcons.ellipsis, size: 16),
//             );
//           },
//         ),
//       ],
//     );
//   }

//   void _showColumnMenu(BuildContext context) {
//     final notifier = ref.read(kanbanProvider.notifier);
//     showDropdown(
//       context: context,
//       builder: (context) {
//         return DropdownMenu(
//           children: [
//             const MenuLabel(child: Text("Actions")),
//             const MenuDivider(),
//             MenuButton(
//               onPressed: (_) {
//                 _showNewTaskDialog(context);
//               },
//               child: const Text("Add Task"),
//             ),
//             MenuButton(
//               onPressed: (_) {
//                 _showEditColumnDialog(context);
//               },
//               child: const Text("Edit Column"),
//             ),
//             MenuButton(
//               onPressed: (_) {
//                 notifier.deleteColumn(widget.projectId, widget.column.data.id);
//               },
//               child: const Text("Delete Column"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showEditColumnDialog(BuildContext context) {
//     final controller = FormController();

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Edit Column"),
//           content: ConstrainedBox(
//             constraints: const BoxConstraints(maxWidth: 400),
//             child: Form(
//               controller: controller,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   FormField(
//                     key: const FormKey(#columnTitle),
//                     label: const Text("Column Title"),
//                     child: TextField(initialValue: widget.column.data.title),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           actions: [
//             OutlineButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel"),
//             ),
//             PrimaryButton(
//               onPressed: () {
//                 final title = controller.values[#columnTitle] as String;
//                 final notifier = ref.read(kanbanProvider.notifier);
//                 notifier.editColumn(
//                   widget.projectId,
//                   widget.column.data.id,
//                   title,
//                 );
//                 Navigator.pop(context);
//               },
//               child: const Text("Save"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showNewTaskDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => NewTaskDialog(
//         projectId: widget.projectId,
//         columnId: widget.column.data.id,
//       ),
//     );
//   }

//   List<Widget> _buildTaskList() {
//     return List.generate(widget.column.data.tasks.length, (taskIndex) {
//       final task = widget.column.data.tasks[taskIndex];

//       return Sortable<KanbanTaskData>(
//         data: task,
//         onAcceptTop: (value) {
//           widget.onMoveTask(value, widget.columnIndex, taskIndex);
//         },
//         onAcceptBottom: (value) {
//           widget.onMoveTask(value, widget.columnIndex, taskIndex + 1);
//         },
//         child: KanbanColumnItem(
//           projectId: widget.projectId,
//           columnId: widget.column.data.id,
//           taskId: task.data.id,
//           title: task.data.title,
//           description: task.data.description,
//           priority: task.data.priority,
//           color: task.data.effectiveColor,
//           dueDate: task.data.dueDate,
//         ),
//       );
//     });
//   }
// }

// class NewTaskDialog extends ConsumerStatefulWidget {
//   final String projectId;
//   final String columnId;

//   const NewTaskDialog({
//     super.key,
//     required this.projectId,
//     required this.columnId,
//   });

//   @override
//   ConsumerState<NewTaskDialog> createState() => _NewTaskDialogState();
// }

// class _NewTaskDialogState extends ConsumerState<NewTaskDialog> {
//   final titleController = TextEditingController();
//   final descriptionController = TextEditingController();
//   TaskPriority? selectedPriority;
//   DateTime? dueDate;

//   @override
//   void dispose() {
//     titleController.dispose();
//     descriptionController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text("New Task"),
//       content: NewTaskForm(
//         titleController: titleController,
//         descriptionController: descriptionController,
//         selectedPriority: selectedPriority,
//         dueDate: dueDate,
//         onPriorityChanged: (priority) =>
//             setState(() => selectedPriority = priority),
//         onDueDateChanged: (date) => setState(() => dueDate = date),
//       ),
//       actions: [
//         OutlineButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text("Cancel"),
//         ),
//         PrimaryButton(
//           onPressed: () {
//             final title = titleController.text.trim();
//             final description = descriptionController.text.trim();

//             if (title.isNotEmpty) {
//               final notifier = ref.read(kanbanProvider.notifier);

//               final newTask = KanbanTaskData(
//                 id: DateTime.now().millisecondsSinceEpoch.toString(),
//                 title: title,
//                 description: description,
//                 priority: selectedPriority ?? TaskPriority.medium,
//                 dueDate: dueDate,
//               );

//               notifier.addTask(widget.projectId, widget.columnId, newTask);
//               Navigator.pop(context);
//             }
//           },
//           child: const Text("Save"),
//         ),
//       ],
//     );
//   }
// }

// class NewTaskForm extends ConsumerWidget {
//   final TextEditingController titleController;
//   final TextEditingController descriptionController;
//   final TaskPriority? selectedPriority;
//   final DateTime? dueDate;
//   final ValueChanged<TaskPriority?> onPriorityChanged;
//   final ValueChanged<DateTime?> onDueDateChanged;

//   const NewTaskForm({
//     super.key,
//     required this.titleController,
//     required this.descriptionController,
//     required this.selectedPriority,
//     required this.dueDate,
//     required this.onPriorityChanged,
//     required this.onDueDateChanged,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return ConstrainedBox(
//       constraints: const BoxConstraints(maxWidth: 400),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           const Text("Title"),
//           const Gap(8),
//           TextField(
//             controller: titleController,
//             autofocus: true,
//             placeholder: const Text("Enter task title"),
//           ),
//           const Gap(16),
//           const Text("Description"),
//           const Gap(8),
//           TextField(
//             controller: descriptionController,
//             maxLines: 3,
//             placeholder: const Text("Enter task description"),
//           ),
//           const Gap(16),
//           const Text("Priority"),
//           const Gap(8),
//           Select<TaskPriority>(
//             itemBuilder: (context, item) => Text(item.displayName),
//             popupConstraints: const BoxConstraints(
//               maxHeight: 300,
//               maxWidth: 200,
//             ),
//             onChanged: onPriorityChanged,
//             value: selectedPriority,
//             placeholder: const Text("Select priority"),
//             popup: const SelectPopup(
//               items: SelectItemList(
//                 children: [
//                   SelectItemButton(
//                     value: TaskPriority.high,
//                     child: Text("High"),
//                   ),
//                   SelectItemButton(
//                     value: TaskPriority.medium,
//                     child: Text("Medium"),
//                   ),
//                   SelectItemButton(value: TaskPriority.low, child: Text("Low")),
//                 ],
//               ),
//             ).call,
//           ),
//           const Gap(16),
//           const Text("Due Date"),
//           const Gap(8),
//           DatePicker(
//             value: dueDate,
//             mode: PromptMode.popover,
//             onChanged: onDueDateChanged,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class PriorityFormField extends ConsumerWidget {
//   final TaskPriority? value;
//   final ValueChanged<TaskPriority?> onChanged;

//   const PriorityFormField({
//     super.key,
//     required this.value,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return FormField(
//       key: const FormKey(#priority),
//       label: const Text("Priority"),
//       child: Select<TaskPriority>(
//         itemBuilder: (context, item) => Text(item.displayName),
//         popupConstraints: const BoxConstraints(maxHeight: 300, maxWidth: 200),
//         onChanged: onChanged,
//         value: value,
//         placeholder: const Text("Select priority"),
//         popup: const SelectPopup(
//           items: SelectItemList(
//             children: [
//               SelectItemButton(value: TaskPriority.high, child: Text("High")),
//               SelectItemButton(
//                 value: TaskPriority.medium,
//                 child: Text("Medium"),
//               ),
//               SelectItemButton(value: TaskPriority.low, child: Text("Low")),
//             ],
//           ),
//         ).call,
//       ),
//     );
//   }
// }

// class DueDateFormField extends ConsumerWidget {
//   final DateTime? value;
//   final ValueChanged<DateTime?> onChanged;

//   const DueDateFormField({
//     super.key,
//     required this.value,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return FormField(
//       key: FormKey(#dueDate),
//       label: const Text("Due Date"),
//       child: DatePicker(
//         value: value,
//         mode: PromptMode.popover,
//         stateBuilder: (date) {
//           return date.isBefore(DateTime.now().subtract(const Duration(days: 1)))
//               ? DateState.disabled
//               : DateState.enabled;
//         },
//         onChanged: onChanged,
//       ),
//     );
//   }
// }

// class KanbanColumnEmpty extends ConsumerWidget {
//   final String projectId;
//   final void Function(String title) onAddColumn;

//   const KanbanColumnEmpty({
//     super.key,
//     required this.projectId,
//     required this.onAddColumn,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return MouseRegion(
//       cursor: SystemMouseCursors.click,
//       child: GestureDetector(
//         onTap: () => _showNewColumnDialog(context),
//         child: Container(
//           width: KanbanConstants.columnWidth,
//           decoration: BoxDecoration(
//             color: Theme.of(context).colorScheme.card,
//             border: Border.all(color: Theme.of(context).colorScheme.border),
//             borderRadius: BorderRadius.circular(KanbanConstants.borderRadius),
//           ),
//           padding: const EdgeInsets.all(KanbanConstants.columnPadding),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [const Icon(LucideIcons.plus, size: 32)],
//           ).gap(KanbanConstants.gapSize),
//         ),
//       ),
//     );
//   }

//   void _showNewColumnDialog(BuildContext context) {
//     final titleController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("New Column"),
//           content: ConstrainedBox(
//             constraints: const BoxConstraints(maxWidth: 400),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 const Text("Column Title"),
//                 const Gap(8),
//                 TextField(
//                   controller: titleController,
//                   autofocus: true,
//                   placeholder: const Text("Enter column title"),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             OutlineButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel"),
//             ),
//             PrimaryButton(
//               onPressed: () {
//                 final title = titleController.text.trim();
//                 if (title.isNotEmpty) {
//                   onAddColumn(title);
//                   Navigator.pop(context);
//                 }
//               },
//               child: const Text("Save"),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// class KanbanColumnItem extends ConsumerWidget {
//   final String projectId;
//   final String columnId;
//   final String taskId;
//   final String title;
//   final String description;
//   final TaskPriority priority;
//   final Color color;
//   final DateTime? dueDate;

//   const KanbanColumnItem({
//     super.key,
//     required this.projectId,
//     required this.columnId,
//     required this.taskId,
//     required this.title,
//     required this.description,
//     required this.priority,
//     required this.color,
//     this.dueDate,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return CardContainer(
//       height: 190,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Text(title).semiBold,
//               const Spacer(),
//               Builder(
//                 builder: (context) {
//                   return IconButton.ghost(
//                     onPressed: () {
//                       showDropdown(
//                         context: context,
//                         builder: (context) {
//                           return DropdownMenu(
//                             children: [
//                               MenuLabel(child: const Text("Actions")),
//                               MenuDivider(),
//                               MenuButton(
//                                 onPressed: (_) {
//                                   _showEditTaskDialog(context, ref);
//                                 },
//                                 child: const Text("Edit"),
//                               ),
//                               MenuButton(
//                                 onPressed: (_) {
//                                   _showDeleteTaskDialog(context, ref);
//                                 },
//                                 child: const Text("Delete"),
//                               ),
//                             ],
//                           );
//                         },
//                       );
//                     },
//                     icon: const Icon(LucideIcons.ellipsis, size: 16),
//                   );
//                 },
//               ),
//             ],
//           ),
//           const Gap(KanbanConstants.gapSize),
//           Text(description),
//           const Gap(KanbanConstants.gapSize),
//           _buildFooter(context),
//         ],
//       ),
//     );
//   }

//   void _showEditTaskDialog(BuildContext context, WidgetRef ref) {
//     final titleController = TextEditingController(text: title);
//     final descriptionController = TextEditingController(text: description);
//     TaskPriority? selectedPriority = priority;
//     DateTime? dueDate;

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Edit Task"),
//           content: NewTaskForm(
//             titleController: titleController,
//             descriptionController: descriptionController,
//             selectedPriority: selectedPriority,
//             dueDate: dueDate,
//             onPriorityChanged: (priority) => selectedPriority = priority,
//             onDueDateChanged: (date) => dueDate = date,
//           ),
//           actions: [
//             OutlineButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel"),
//             ),
//             PrimaryButton(
//               onPressed: () {
//                 final newTitle = titleController.text.trim();
//                 final newDescription = descriptionController.text.trim();

//                 if (newTitle.isNotEmpty) {
//                   final notifier = ref.read(kanbanProvider.notifier);

//                   final updatedTask = KanbanTaskData(
//                     id: taskId,
//                     title: newTitle,
//                     description: newDescription,
//                     priority: selectedPriority ?? TaskPriority.medium,
//                     dueDate: dueDate,
//                   );

//                   notifier.editTask(projectId, columnId, taskId, updatedTask);
//                   Navigator.pop(context);
//                 }
//               },
//               child: const Text("Save"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showDeleteTaskDialog(BuildContext context, WidgetRef ref) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Delete Task"),
//           content: const Text("Are you sure you want to delete this task?"),
//           actions: [
//             OutlineButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel"),
//             ),
//             PrimaryButton(
//               onPressed: () {
//                 final notifier = ref.read(kanbanProvider.notifier);
//                 notifier.deleteTask(projectId, columnId, taskId);
//                 Navigator.pop(context);
//               },
//               child: const Text("Delete"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildFooter(BuildContext context) {
//     String dueDateText = "";

//     if (dueDate != null) {
//       dueDateText = "${dueDate!.month}/${dueDate!.day}";
//     } else {
//       dueDateText = "No Date";
//     }

//     final isOverdue = dueDate != null && dueDate!.isBefore(DateTime.now());

//     return Row(
//       children: [
//         const Icon(LucideIcons.calendar, size: 16),
//         const Gap(8),
//         Text(
//           dueDateText,
//           style: isOverdue
//               ? TextStyle(color: Theme.of(context).colorScheme.destructive)
//               : null,
//         ),
//         const Gap(8),
//         Badge(text: priority.displayName, backgroundColor: color),
//         const Spacer(),
//         Avatar(
//           size: 24,
//           initials: Avatar.getInitials("ts paja"),
//           provider: const NetworkImage(
//             "https://avatars.githubusercontent.com/u/213942709?s=400&v=4",
//           ),
//         ),
//       ],
//     );
//   }
// }

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:kanban/providers/theme_provider.dart';
// import 'package:shadcn_flutter/shadcn_flutter.dart';
// import 'package:go_router/go_router.dart';

// class AppHeader extends ConsumerWidget {
//   final bool showBackButton;

//   const AppHeader({super.key, this.showBackButton = false});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final themeMode = ref.watch(themeProvider);

//     return AppBar(
//       leading: showBackButton
//           ? [
//               IconButton.outline(
//                 onPressed: () => context.pop(),
//                 icon: const Icon(LucideIcons.chevronLeft, size: 16),
//               ),
//             ]
//           : [],
//       title: const Text("Kanban Board"),
//       trailing: [
//         _buildSearch(),
//         const Gap(8),
//         IconButton.ghost(
//           onPressed: () => ref.read(themeProvider.notifier).toggle(),
//           icon: Icon(
//             themeMode == ThemeMode.dark ? LucideIcons.sun : LucideIcons.moon,
//             size: 16,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildSearch() {
//     final TextEditingController searchController = TextEditingController();

//     return SizedBox(
//       width: 250,
//       child: TextField(
//         controller: searchController,
//         placeholder: const Text("Search something..."),
//         features: [
//           // Leading icon only visible when the text is empty
//           InputFeature.leading(
//             StatedWidget.builder(
//               builder: (context, states) {
//                 // Use a muted icon normally, switch to the full icon on hover
//                 if (states.hovered) {
//                   return const Icon(Icons.search);
//                 } else {
//                   return const Icon(Icons.search).iconMutedForeground();
//                 }
//               },
//             ),
//             visibility: InputFeatureVisibility.textEmpty,
//           ),
//           // Clear button visible when there is text and the field is focused,
//           // or whenever the field is hovered
//           InputFeature.clear(
//             visibility:
//                 (InputFeatureVisibility.textNotEmpty &
//                     InputFeatureVisibility.focused) |
//                 InputFeatureVisibility.hovered,
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:kanban/shared/app_header.dart';
// import 'package:shadcn_flutter/shadcn_flutter.dart';

// class AppScaffold extends ConsumerWidget {
//   final Widget child;
//   final bool showBackButton;

//   const AppScaffold({
//     super.key,
//     required this.child,
//     this.showBackButton = false,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       headers: [
//         AppHeader(showBackButton: showBackButton),
//         const Divider(),
//       ],
//       child: child,
//     );
//   }
// }

// class KanbanConstants {
//   static const double columnWidth = 360;
//   static const double columnPadding = 16;
//   static const double borderRadius = 12;
//   static const double gapSize = 16;
//   const KanbanConstants._();
// }

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shadcn_flutter/shadcn_flutter.dart';

// class Badge extends ConsumerWidget {
//   final String text;
//   final Color backgroundColor;
//   final Color foregroundColor;
//   final EdgeInsets padding;
//   final double borderRadius;
//   final double fontSize;

//   const Badge({
//     super.key,
//     required this.text,
//     this.backgroundColor = const Color(0xFFE5E7EB),
//     this.foregroundColor = const Color(0xFF111827),
//     this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//     this.borderRadius = 6,
//     this.fontSize = 12,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Container(
//       padding: padding,
//       decoration: BoxDecoration(
//         color: backgroundColor,
//         borderRadius: BorderRadius.circular(borderRadius),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           color: foregroundColor,
//           fontSize: fontSize,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }
// }

// // class BadgeVariants {
// //   static Badge success(String text) => Badge(
// //     text: text,
// //     backgroundColor: Color(0xFFDCFCE7),
// //     foregroundColor: Color(0xFF166534),
// //   );

// //   static Badge warning(String text) => Badge(
// //     text: text,
// //     backgroundColor: Color(0xFFFEF9C3),
// //     foregroundColor: Color(0xFF854D0E),
// //   );

// //   static Badge danger(String text) => Badge(
// //     text: text,
// //     backgroundColor: Color(0xFFFEE2E2),
// //     foregroundColor: Color(0xFF991B1B),
// //   );

// //   static Badge info(String text) => Badge(
// //     text: text,
// //     backgroundColor: Color(0xFFE0F2FE),
// //     foregroundColor: Color(0xFF075985),
// //   );
// // }

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shadcn_flutter/shadcn_flutter.dart';

// class CardContainer extends ConsumerStatefulWidget {
//   final Widget child;
//   final VoidCallback? onTap;
//   final double width;
//   final double height;

//   const CardContainer({
//     super.key,
//     required this.child,
//     this.onTap,
//     this.width = 360,
//     this.height = 220,
//   });

//   @override
//   ConsumerState<CardContainer> createState() => _CardContainerState();
// }

// class _CardContainerState extends ConsumerState<CardContainer> {
//   bool _hovered = false;

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return MouseRegion(
//       cursor: SystemMouseCursors.click,
//       onEnter: (_) => setState(() => _hovered = true),
//       onExit: (_) => setState(() => _hovered = false),
//       child: GestureDetector(
//         onTap: widget.onTap,
//         child: SizedBox(
//           width: widget.width,
//           height: widget.height,
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 200),
//             curve: Curves.easeInOut,
//             decoration: BoxDecoration(
//               color: Theme.of(context).colorScheme.card,
//               border: Border.all(color: Theme.of(context).colorScheme.border),
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: isDark
//                       ? Colors.black.withValues(alpha: 0.6)
//                       : Colors.black.withValues(alpha: _hovered ? 0.15 : 0.1),
//                   blurRadius: _hovered ? 12 : 0,
//                   offset: _hovered ? const Offset(0, 6) : const Offset(0, 0),
//                 ),
//               ],
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: widget.child,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:shadcn_flutter/shadcn_flutter.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// void main() {
//   runApp(const ProviderScope(child: KanbanApp()));
// }

// class KanbanApp extends StatelessWidget {
//   const KanbanApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ShadcnApp(
//       debugShowCheckedModeBanner: false,
//       title: "Kanban Demo Project",
//       theme: ThemeData(colorScheme: ColorSchemes.lightNeutral),
//       darkTheme: ThemeData(colorScheme: ColorSchemes.darkNeutral),
//       home: const HomeScreen(),
//     );
//   }
// }

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(child: AuthScreen());
//   }
// }

// class AuthScreen extends ConsumerStatefulWidget {
//   const AuthScreen({super.key});

//   @override
//   ConsumerState<AuthScreen> createState() => _AuthScreenState();
// }

// class _AuthScreenState extends ConsumerState<AuthScreen> {
//   AuthMode _mode = AuthMode.signIn;

//   void _toggleMode() {
//     setState(() {
//       _mode = _mode == AuthMode.signIn ? AuthMode.signUp : AuthMode.signIn;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         const AuthLogo(),
//         const Gap(16),
//         const InfoSection(),
//         const Gap(16),
//         AuthFormContainer(mode: _mode, onModeChange: _toggleMode),
//         const Gap(16),
//         ToggleAccountLink(mode: _mode, onModeChange: _toggleMode),
//       ],
//     );
//   }
// }

// class AuthLogo extends StatelessWidget {
//   const AuthLogo({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 48,
//       height: 48,
//       decoration: BoxDecoration(
//         color: Colors.gray,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: const Icon(LucideIcons.layoutDashboard),
//     );
//   }
// }

// class InfoSection extends StatelessWidget {
//   const InfoSection({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const Text("Kanban Board").x2Large.bold,
//         const Gap(8),
//         const Text("The editorial workspace for modern teams.").muted.small,
//       ],
//     );
//   }
// }

// class AuthFormContainer extends StatelessWidget {
//   final AuthMode mode;
//   final VoidCallback onModeChange;

//   const AuthFormContainer({
//     super.key,
//     required this.mode,
//     required this.onModeChange,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isSignIn = mode == AuthMode.signIn;

//     return Card(
//       child: Form(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(isSignIn ? "Sign in" : "Sign Up").large.semiBold,
//             const Gap(4),
//             const Text("Welcome back to your workspace.").muted.small,
//             const Gap(16),
//             const EmailField(),
//             const Gap(16),
//             PasswordField(showForgotPassword: isSignIn),
//             if (!isSignIn) ...[const Gap(16), const RepeatPasswordField()],
//             const Gap(16),
//             SubmitButton(isSignIn: isSignIn),
//             if (isSignIn) ...[
//               const Gap(16),
//               const Text("or continue with", textAlign: TextAlign.center),
//               const Gap(16),
//               const SocialLoginButtons(),
//             ],
//           ],
//         ),
//       ),
//     ).intrinsicWidth(stepWidth: 400);
//   }
// }

// class EmailField extends StatelessWidget {
//   const EmailField({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const FormField(
//       key: FormKey(#email),
//       label: Text("Email Address"),
//       validator: NonNullValidator(message: "Please enter valid email."),
//       child: TextField(
//         placeholder: Text("example@example.com"),
//         features: [
//           InputFeature.clear(visibility: InputFeatureVisibility.textNotEmpty),
//         ],
//       ),
//     );
//   }
// }

// class PasswordField extends StatelessWidget {
//   final bool showForgotPassword;

//   const PasswordField({super.key, required this.showForgotPassword});

//   @override
//   Widget build(BuildContext context) {
//     return FormField(
//       key: const FormKey(#password),
//       label: const Text("Password"),
//       trailingLabel: showForgotPassword
//           ? LinkButton(
//               onPressed: () {},
//               density: ButtonDensity.iconDense,
//               child: const Text("Forgot Password?"),
//             )
//           : null,
//       validator: const NonNullValidator(
//         message: "Please enter valid password.",
//       ),
//       child: const TextField(
//         placeholder: Text("********"),
//         features: [
//           InputFeature.passwordToggle(mode: PasswordPeekMode.hold),
//           InputFeature.clear(visibility: InputFeatureVisibility.textNotEmpty),
//         ],
//       ),
//     );
//   }
// }

// class RepeatPasswordField extends StatelessWidget {
//   const RepeatPasswordField({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const FormField(
//       key: FormKey(#repeatPassword),
//       label: Text("Repeat Password"),
//       validator: NonNullValidator(message: "Please repeat password."),
//       child: TextField(
//         placeholder: Text("********"),
//         features: [
//           InputFeature.passwordToggle(mode: PasswordPeekMode.hold),
//           InputFeature.clear(visibility: InputFeatureVisibility.textNotEmpty),
//         ],
//       ),
//     );
//   }
// }

// class SubmitButton extends StatelessWidget {
//   final bool isSignIn;

//   const SubmitButton({super.key, required this.isSignIn});

//   @override
//   Widget build(BuildContext context) {
//     return PrimaryButton(
//       onPressed: () {},
//       alignment: Alignment.center,
//       child: Text(isSignIn ? "Sign In" : "Sign Up"),
//     );
//   }
// }

// class SocialLoginButtons extends StatelessWidget {
//   const SocialLoginButtons({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Expanded(
//           child: OutlineButton(
//             onPressed: () {},
//             alignment: Alignment.center,
//             child: const Text("Sign in with Google"),
//           ),
//         ),
//         const Gap(16),
//         Expanded(
//           child: OutlineButton(
//             onPressed: () {},
//             alignment: Alignment.center,
//             child: const Text("Sign in with Github"),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class ToggleAccountLink extends StatelessWidget {
//   final AuthMode mode;
//   final VoidCallback onModeChange;

//   const ToggleAccountLink({
//     super.key,
//     required this.mode,
//     required this.onModeChange,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isSignIn = mode == AuthMode.signIn;

//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(isSignIn ? "Don't have an account?" : "Already have an account?"),
//         const Gap(4),
//         LinkButton(
//           onPressed: onModeChange,
//           density: ButtonDensity.iconDense,
//           child: Text(isSignIn ? "Create an account" : "Sign In"),
//         ),
//       ],
//     );
//   }
// }

// enum AuthMode { signIn, signUp, forgotPassword }

// class AuthFormState {
//   final String email;
//   final String password;
//   final String repeatPassword;

//   const AuthFormState({
//     this.email = '',
//     this.password = '',
//     this.repeatPassword = '',
//   });

//   AuthFormState copyWith({
//     String? email,
//     String? password,
//     String? repeatPassword,
//   }) {
//     return AuthFormState(
//       email: email ?? this.email,
//       password: password ?? this.password,
//       repeatPassword: repeatPassword ?? this.repeatPassword,
//     );
//   }
// }
