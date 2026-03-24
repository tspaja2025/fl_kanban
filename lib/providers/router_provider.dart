import 'package:fl_kanban/screens/create_new_project_screen.dart';
import 'package:fl_kanban/screens/default_screen.dart';
import 'package:fl_kanban/screens/project_board_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: "/",
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return Scaffold(child: child);
        },
        routes: [
          GoRoute(
            path: "/",
            name: "projects",
            builder: (context, state) => const DefaultScreen(),
          ),
          GoRoute(
            path: "/projects/:id",
            name: "projectsDetail",
            builder: (context, state) {
              final projectId = state.pathParameters["id"]!;
              return ProjectBoardScreen(projectId: projectId);
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
