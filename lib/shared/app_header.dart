import 'package:fl_kanban/providers/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:go_router/go_router.dart';

class AppHeader extends ConsumerWidget {
  final bool showBackButton;

  const AppHeader({super.key, this.showBackButton = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return AppBar(
      leading: showBackButton
          ? [
              IconButton.outline(
                onPressed: () => context.pop(),
                icon: const Icon(LucideIcons.chevronLeft, size: 16),
              ),
            ]
          : [],
      title: const Text("Kanban Board"),
      trailing: [
        IconButton.ghost(
          onPressed: () => ref.read(themeProvider.notifier).toggle(),
          icon: Icon(
            themeMode == ThemeMode.dark ? LucideIcons.sun : LucideIcons.moon,
            size: 16,
          ),
        ),
        IconButton.ghost(
          onPressed: () {
            context.pushNamed("auth");
          },
          icon: const Icon(LucideIcons.logOut, size: 16),
        ),
      ],
    );
  }
}
