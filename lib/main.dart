import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: const FlKanban()));
}

class FlKanban extends StatelessWidget {
  const FlKanban({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadcnApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter Kanban Board",
      theme: ThemeData(colorScheme: ColorSchemes.lightNeutral),
      darkTheme: ThemeData.dark(colorScheme: ColorSchemes.darkNeutral),
      home: const DefaultScreen(),
    );
  }
}

class DefaultScreen extends StatefulWidget {
  const DefaultScreen({super.key});

  @override
  State<DefaultScreen> createState() => _DefaultScreenState();
}

class _DefaultScreenState extends State<DefaultScreen> {
  // Helper to return list of avatars
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
  Widget build(BuildContext context) {
    return Scaffold(
      headers: [
        AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryForeground,
          title: const Text("Flutter Kanban Board"),
          trailing: [
            SizedBox(
              width: 150,
              child: TextField(
                placeholder: const Text("Search..."),
                features: [
                  InputFeature.leading(
                    StatedWidget.builder(
                      builder: (context, states) {
                        if (states.hovered) {
                          return const Icon(Icons.search);
                        } else {
                          return const Icon(Icons.search).iconMutedForeground();
                        }
                      },
                    ),
                    visibility: InputFeatureVisibility.textEmpty,
                  ),
                  InputFeature.clear(
                    visibility:
                        (InputFeatureVisibility.textNotEmpty &
                            InputFeatureVisibility.focused) |
                        InputFeatureVisibility.hovered,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            PrimaryButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Add New Column"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 400),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const TextField(
                                  placeholder: Text("Enter column name"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        SecondaryButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"),
                        ),
                        PrimaryButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Create Column"),
                        ),
                      ],
                    );
                  },
                );
              },
              leading: const Icon(LucideIcons.plus, size: 16),
              child: const Text("Add Column"),
            ),
            const SizedBox(width: 4),
            Builder(
              builder: (context) {
                return IconButton.ghost(
                  onPressed: () {
                    showDropdown(
                      context: context,
                      builder: (context) {
                        return const DropdownMenu(
                          children: [
                            MenuButton(
                              leading: Icon(LucideIcons.settings, size: 16),
                              child: Text("Settings"),
                            ),
                            MenuDivider(),
                            MenuButton(
                              leading: Icon(LucideIcons.logOut, size: 16),
                              child: Text("Log Out"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Avatar(
                    size: 24,
                    initials: Avatar.getInitials("TS"),
                    provider: const NetworkImage(
                      "https://avatars.githubusercontent.com/u/213942709?s=400&v=4",
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
      child: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              KanbanColumn(
                title: "Column Title 1",
                itemCount: 4,
                children: [
                  KanbanColumnItem(
                    title: "Item 1",
                    priority: "High",
                    children: [
                      const Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                      ),
                      const SizedBox(height: 16),
                      AvatarGroup.toLeft(children: getAvatars()),
                    ],
                  ),
                  KanbanColumnItem(
                    title: "Item 2",
                    priority: "Medium",
                    children: [
                      const Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                      ),
                    ],
                  ),
                  KanbanColumnItem(
                    title: "Item 3",
                    priority: "Low",
                    children: [
                      const Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                      ),
                    ],
                  ),
                  KanbanColumnItem(
                    title: "Item 4",
                    priority: "High",
                    children: [
                      const Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                      ),
                    ],
                  ),
                ],
              ),
              KanbanColumn(
                title: "Column Title 2",
                itemCount: 3,
                children: [
                  KanbanColumnItem(
                    title: "Item 1",
                    priority: "High",
                    children: [
                      const Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                      ),
                    ],
                  ),
                  KanbanColumnItem(
                    title: "Item 2",
                    priority: "Medium",
                    children: [
                      const Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                      ),
                    ],
                  ),
                  KanbanColumnItem(
                    title: "Item 3",
                    priority: "Low",
                    children: [
                      const Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                      ),
                    ],
                  ),
                ],
              ),
              KanbanColumn(
                title: "Column Title 3",
                itemCount: 2,
                children: [
                  KanbanColumnItem(
                    title: "Item 1",
                    priority: "High",
                    children: [
                      const Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                      ),
                    ],
                  ),
                  KanbanColumnItem(
                    title: "Item 2",
                    priority: "Medium",
                    children: [
                      const Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ).gap(16),
        ),
      ),
    );
  }
}

class KanbanColumn extends StatelessWidget {
  final String title;
  final double itemCount;
  final List<Widget> children;

  const KanbanColumn({
    super.key,
    required this.title,
    required this.itemCount,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 4),
                Chip(child: Text("$itemCount")),
                const Spacer(),
                IconButton.ghost(
                  onPressed: () {},
                  density: ButtonDensity.iconDense,
                  icon: const Icon(LucideIcons.gripVertical, size: 16),
                ),
                Builder(
                  builder: (context) {
                    return IconButton.ghost(
                      onPressed: () {
                        showDropdown(
                          context: context,
                          builder: (context) {
                            return DropdownMenu(
                              children: [
                                MenuButton(
                                  onPressed: (_) {},
                                  leading: const Icon(LucideIcons.plus),
                                  child: const Text("New Task"),
                                ),
                                MenuButton(
                                  onPressed: (_) {},
                                  leading: const Icon(LucideIcons.pencil),
                                  child: const Text("Edit Column"),
                                ),
                                MenuButton(
                                  onPressed: (_) {},
                                  leading: const Icon(LucideIcons.trash2),
                                  child: const Text("Delete Column"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      density: ButtonDensity.iconDense,
                      icon: const Icon(LucideIcons.menu, size: 16),
                    );
                  },
                ),
              ],
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height - 180,
              child: SingleChildScrollView(
                child: Column(children: children).gap(16),
              ),
            ),
          ],
        ).gap(16),
      ),
    );
  }
}

class KanbanColumnItem extends StatelessWidget {
  final String title;
  final String priority;
  final List<Widget> children;

  const KanbanColumnItem({
    super.key,
    required this.title,
    required this.priority,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.grab,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(title).bold,
                const Spacer(),
                Builder(
                  builder: (context) {
                    return IconButton.ghost(
                      onPressed: () {
                        showDropdown(
                          context: context,
                          builder: (context) {
                            return const DropdownMenu(
                              children: [
                                MenuButton(
                                  leading: Icon(LucideIcons.pencil),
                                  child: Text("Edit"),
                                ),
                                MenuButton(
                                  leading: Icon(LucideIcons.trash2),
                                  child: Text("Delete"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      density: ButtonDensity.iconDense,
                      icon: const Icon(LucideIcons.menu, size: 16),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: [
                PrimaryBadge(child: Text(priority)),
                const Spacer(),
                const Icon(LucideIcons.paperclip, size: 16),
                const Text("2"),
                const Icon(LucideIcons.messageSquare, size: 16),
                const Text("4"),
              ],
            ).gap(4),
          ],
        ),
      ),
    );
  }
}
