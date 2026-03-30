import 'package:fl_kanban/screens/kanban_board_screen.dart';
import 'package:fl_kanban/screens/kanban_create_project_screen.dart';
import 'package:fl_kanban/screens/kanban_project_screen.dart';
import 'package:fl_kanban/shared/app_scaffold.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
            builder: (context, state) => const KanbanCreateProjectScreen(),
          ),
        ],
      ),
    ],
  );
});
