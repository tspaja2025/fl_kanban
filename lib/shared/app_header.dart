import 'package:fl_kanban/app/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:go_router/go_router.dart';

class AppHeader extends ConsumerWidget {
  final bool showBackButton;

  const AppHeader({super.key, this.showBackButton = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final notifier = ref.read(themeProvider.notifier);

    return AppBar(
      leading: showBackButton
          ? [
              IconButton.outline(
                onPressed: () {
                  context.pop(context);
                },
                icon: const Icon(LucideIcons.chevronLeft, size: 16),
              ),
            ]
          : [],
      title: const Text("Kanban Board"),
      trailing: [
        SizedBox(
          width: 250,
          child: TextField(
            placeholder: const Text("Search"),
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
        IconButton.ghost(
          onPressed: notifier.toggle,
          icon: Icon(
            themeMode == ThemeMode.dark ? LucideIcons.sun : LucideIcons.moon,
            size: 16,
          ),
        ),
      ],
    );
  }
}
