import 'package:fl_kanban/screens/auth_screen.dart';
import 'package:fl_kanban/screens/kanban_board_screen.dart';
import 'package:fl_kanban/screens/kanban_screen.dart';
import 'package:fl_kanban/shared/app_scaffold.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: "/",
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          final isAuth = state.uri.path == "/";
          final showBackButton = state.uri.path != "/projects";

          return AppScaffold(
            showBackButton: showBackButton,
            showHeader: !isAuth,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: "/",
            name: "auth",
            builder: (context, state) => const AuthScreen(),
          ),
          GoRoute(
            path: "/projects",
            name: "projects",
            builder: (context, state) => const KanbanScreen(),
          ),
          GoRoute(
            path: "/projects/:id",
            name: "kanbanProjectDetail",
            builder: (context, state) {
              final projectId = state.pathParameters["id"]!;
              return KanbanBoardScreen(projectId: projectId);
            },
          ),
        ],
      ),
    ],
  );
});
