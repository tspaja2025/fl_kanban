import 'package:fl_kanban/widgets/logo.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:go_router/go_router.dart';

class AppHeader extends StatelessWidget {
  final bool showBackButton;

  const AppHeader({super.key, this.showBackButton = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showBackButton
          ? [
              IconButton.outline(
                onPressed: () => context.pop(),
                icon: const Icon(LucideIcons.chevronLeft, size: 16),
              ),
            ]
          : [Logo(width: 32, height: 32, size: 16)],
      title: const Text("Kanban Board"),
      trailing: [
        IconButton.ghost(
          onPressed: () {},
          icon: Icon(LucideIcons.bell, size: 16),
        ),
        IconButton.ghost(
          onPressed: () => context.pushNamed("settings"),
          icon: Icon(LucideIcons.settings, size: 16),
        ),
        IconButton.ghost(
          onPressed: () => context.pushNamed("auth"),
          icon: Icon(LucideIcons.logOut, size: 16),
        ),
      ],
    );
  }
}
