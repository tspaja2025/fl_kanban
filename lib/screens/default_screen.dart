import 'package:fl_kanban/providers/kanban_provider.dart';
import 'package:fl_kanban/providers/router_provider.dart';
import 'package:fl_kanban/providers/theme_provider.dart';
import 'package:fl_kanban/widgets/project_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class DefaultScreen extends ConsumerWidget {
  const DefaultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final notifier = ref.read(themeProvider.notifier);
    final router = ref.watch(routerProvider);
    final boards = ref.watch(projectBoardProvider);

    return Scaffold(
      headers: [
        AppBar(
          title: const Text("Your Kanban Board"),
          trailing: [
            SizedBox(
              width: 250,
              child: TextField(
                placeholder: const Text("Search..."),
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
            PrimaryButton(
              onPressed: () {
                router.pushNamed("createProject");
              },
              leading: const Icon(LucideIcons.plus, size: 16),
              child: const Text("Create"),
            ),
            gap(8),
            IconButton.ghost(
              onPressed: notifier.toggle,
              icon: Icon(
                themeMode == ThemeMode.dark
                    ? LucideIcons.sun
                    : LucideIcons.moon,
                size: 16,
              ),
            ),
            gap(8),
            IconButton.ghost(
              onPressed: () {},
              icon: const Icon(LucideIcons.user, size: 16),
            ),
          ],
        ),
        const Divider(),
      ],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < boards.length; i++)
                  ProjectCard(
                    onTap: () {
                      router.pushNamed(
                        "projectsDetail",
                        pathParameters: {"id": boards[i].data.id},
                      );
                    },
                    title: boards[i].data.title,
                    description: boards[i].data.description,
                  ),
              ],
            ).gap(16),
          ],
        ),
      ),
    );
  }
}

// TODO:
// 1. Unified provider for project -> column -> tasks
// 2. CRUD Operations
// 3. Google Firebase?
