import 'package:fl_kanban/widgets/badge.dart';
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
      title: "Flutter Kanban",
      theme: ThemeData(colorScheme: ColorSchemes.lightNeutral),
      // darkTheme: ThemeData.dark(colorScheme: ColorSchemes.darkNeutral),
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
  //   // Helper to return list of avatars
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
          trailing: [
            IconButton.ghost(
              onPressed: () {},
              icon: const Icon(LucideIcons.bell, size: 16),
            ),
            IconButton.ghost(
              onPressed: () {},
              icon: const Icon(LucideIcons.circleHelp, size: 16),
            ),
            Builder(
              builder: (context) {
                return IconButton.ghost(
                  onPressed: () {
                    showDropdown(
                      context: context,
                      builder: (context) {
                        return const DropdownMenu(
                          children: [
                            MenuLabel(child: Text("Account")),
                            MenuButton(child: Text("Manage Account")),
                            MenuDivider(),
                            MenuLabel(child: Text("Kanban")),
                            MenuButton(child: Text("About this board")),
                            MenuButton(child: Text("Activity")),
                            MenuButton(child: Text("Settings")),
                            MenuDivider(),
                            MenuButton(child: Text("Create New Board")),
                            MenuDivider(),
                            MenuButton(child: Text("Help")),
                            MenuButton(child: Text("Shortcuts")),
                            MenuDivider(),
                            MenuButton(child: Text("Log out")),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(LucideIcons.user, size: 16),
                );
              },
            ),
          ],
          child: Row(
            children: [
              const Text("Flutter Kanban").bold,
              const Spacer(),
              SizedBox(
                width: 800,
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
                            return const Icon(
                              Icons.search,
                            ).iconMutedForeground();
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
              const Spacer(),
            ],
          ),
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
                title: "Column 1",
                color: Colors.blue,
                children: [
                  KanbanColumnItem(
                    title: "Item title 1",
                    priority: "High",
                    priorityColor: Colors.red,
                    children: [
                      const Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                      ),
                      const SizedBox(height: 16),
                      AvatarGroup.toLeft(children: getAvatars()),
                    ],
                  ),
                  KanbanColumnItem(
                    title: "Item title 2",
                    priority: "Medium",
                    priorityColor: Colors.orange,
                    children: [
                      const Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                      ),
                      const SizedBox(height: 16),
                      AvatarGroup.toLeft(children: getAvatars()),
                    ],
                  ),
                  KanbanColumnItem(
                    title: "Item title 3",
                    priority: "Low",
                    priorityColor: Colors.blue,
                    children: [
                      const Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                      ),
                      const SizedBox(height: 16),
                      AvatarGroup.toLeft(children: getAvatars()),
                    ],
                  ),
                  KanbanColumnItem(
                    title: "Item title 4",
                    priority: "High",
                    priorityColor: Colors.red,
                    children: [
                      const Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                      ),
                      const SizedBox(height: 16),
                      AvatarGroup.toLeft(children: getAvatars()),
                    ],
                  ),
                ],
              ),
              KanbanColumn(
                title: "Column 2",
                color: Colors.red,
                children: [
                  KanbanColumnItem(
                    title: "Item title 1",
                    priority: "High",
                    priorityColor: Colors.red,
                    children: [
                      const Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                      ),
                      const SizedBox(height: 16),
                      AvatarGroup.toLeft(children: getAvatars()),
                    ],
                  ),
                  KanbanColumnItem(
                    title: "Item title 2",
                    priority: "Medium",
                    priorityColor: Colors.orange,
                    children: [
                      const Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                      ),
                      const SizedBox(height: 16),
                      AvatarGroup.toLeft(children: getAvatars()),
                    ],
                  ),
                  KanbanColumnItem(
                    title: "Item title 3",
                    priority: "Low",
                    priorityColor: Colors.blue,
                    children: [
                      const Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                      ),
                      const SizedBox(height: 16),
                      AvatarGroup.toLeft(children: getAvatars()),
                    ],
                  ),
                ],
              ),
              KanbanColumn(
                title: "Column 3",
                color: Colors.green,
                children: [
                  KanbanColumnItem(
                    title: "Item title 1",
                    priority: "High",
                    priorityColor: Colors.red,
                    children: [
                      const Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                      ),
                      const SizedBox(height: 16),
                      AvatarGroup.toLeft(children: getAvatars()),
                    ],
                  ),
                  KanbanColumnItem(
                    title: "Item title 2",
                    priority: "Medium",
                    priorityColor: Colors.orange,
                    children: [
                      const Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                      ),
                      const SizedBox(height: 16),
                      AvatarGroup.toLeft(children: getAvatars()),
                    ],
                  ),
                ],
              ),
              KanbanColumn(
                title: "Column 4",
                color: Colors.pink,
                children: [
                  KanbanColumnItem(
                    title: "Item title 1",
                    priority: "High",
                    priorityColor: Colors.red,
                    children: [
                      const Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                      ),
                      const SizedBox(height: 16),
                      AvatarGroup.toLeft(children: getAvatars()),
                    ],
                  ),
                ],
              ),
              KanbanColumn(
                title: "Column 5",
                color: Colors.blue,
                children: [
                  KanbanColumnItem(
                    title: "Item title 1",
                    priority: "High",
                    priorityColor: Colors.red,
                    children: [
                      const Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                      ),
                      const SizedBox(height: 16),
                      AvatarGroup.toLeft(children: getAvatars()),
                    ],
                  ),
                  KanbanColumnItem(
                    title: "Item title 2",
                    priority: "Medium",
                    priorityColor: Colors.orange,
                    children: [
                      const Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                      ),
                      const SizedBox(height: 16),
                      AvatarGroup.toLeft(children: getAvatars()),
                    ],
                  ),
                  KanbanColumnItem(
                    title: "Item title 3",
                    priority: "Low",
                    priorityColor: Colors.blue,
                    children: [
                      const Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                      ),
                      const SizedBox(height: 16),
                      AvatarGroup.toLeft(children: getAvatars()),
                    ],
                  ),
                  KanbanColumnItem(
                    title: "Item title 4",
                    priority: "High",
                    priorityColor: Colors.red,
                    children: [
                      const Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                      ),
                      const SizedBox(height: 16),
                      AvatarGroup.toLeft(children: getAvatars()),
                    ],
                  ),
                ],
              ),
              KanbanColumn(
                title: "Column 6",
                color: Colors.red,
                children: [
                  KanbanColumnItem(
                    title: "Item title 1",
                    priority: "High",
                    priorityColor: Colors.red,
                    children: [
                      const Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                      ),
                      const SizedBox(height: 16),
                      AvatarGroup.toLeft(children: getAvatars()),
                    ],
                  ),
                  KanbanColumnItem(
                    title: "Item title 2",
                    priority: "Medium",
                    priorityColor: Colors.orange,
                    children: [
                      const Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                      ),
                      const SizedBox(height: 16),
                      AvatarGroup.toLeft(children: getAvatars()),
                    ],
                  ),
                  KanbanColumnItem(
                    title: "Item title 3",
                    priority: "Low",
                    priorityColor: Colors.blue,
                    children: [
                      const Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                      ),
                      const SizedBox(height: 16),
                      AvatarGroup.toLeft(children: getAvatars()),
                    ],
                  ),
                ],
              ),
              KanbanColumn(
                title: "Column 7",
                color: Colors.green,
                children: [
                  KanbanColumnItem(
                    title: "Item title 1",
                    priority: "High",
                    priorityColor: Colors.red,
                    children: [
                      const Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                      ),
                      const SizedBox(height: 16),
                      AvatarGroup.toLeft(children: getAvatars()),
                    ],
                  ),
                  KanbanColumnItem(
                    title: "Item title 2",
                    priority: "Medium",
                    priorityColor: Colors.orange,
                    children: [
                      const Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                      ),
                      const SizedBox(height: 16),
                      AvatarGroup.toLeft(children: getAvatars()),
                    ],
                  ),
                ],
              ),
              KanbanColumn(
                title: "Column 8",
                color: Colors.pink,
                children: [
                  KanbanColumnItem(
                    title: "Item title 1",
                    priority: "High",
                    priorityColor: Colors.red,
                    children: [
                      const Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                      ),
                      const SizedBox(height: 16),
                      AvatarGroup.toLeft(children: getAvatars()),
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

class KanbanColumn extends StatefulWidget {
  final String title;
  final List<Widget> children;
  final Color? color;

  const KanbanColumn({
    super.key,
    required this.title,
    required this.children,
    this.color,
  });

  @override
  State<KanbanColumn> createState() => _KanbanColumnState();
}

class _KanbanColumnState extends State<KanbanColumn> {
  ColorDerivative cardColor = ColorDerivative.fromColor(Colors.blue);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 272,
      child: Card(
        filled: true,
        fillColor: widget.color,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(widget.title).bold,
                const Spacer(),
                ColumnItemDialog(),
              ],
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height - 180,
              child: SingleChildScrollView(
                child: Column(children: widget.children).gap(16),
              ),
            ),
          ],
        ).gap(16),
      ),
    );
  }
}

class KanbanColumnItem extends StatefulWidget {
  final String title;
  final String priority;
  final Color? priorityColor;
  final List<Widget> children;

  const KanbanColumnItem({
    super.key,
    required this.title,
    required this.priority,
    required this.priorityColor,
    required this.children,
  });

  @override
  State<KanbanColumnItem> createState() => _KanbanColumnItemState();
}

class _KanbanColumnItemState extends State<KanbanColumnItem> {
  ColorDerivative cardColor = ColorDerivative.fromColor(Colors.blue);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(widget.title).semiBold,
              const Spacer(),
              ColumnItemDialog(),
            ],
          ),

          const SizedBox(height: 8),

          ...widget.children,
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            children: [
              Badge(color: widget.priorityColor, child: widget.priority),
              const Spacer(),
              const Icon(LucideIcons.paperclip, size: 16),
              const Text("2"),
              const Icon(LucideIcons.messageSquare, size: 16),
              const Text("4"),
            ],
          ).gap(4),
        ],
      ),
    );
  }
}

class ColumnItemDialog extends StatefulWidget {
  const ColumnItemDialog({super.key});

  @override
  State<ColumnItemDialog> createState() => _ColumnItemDialogState();
}

class _ColumnItemDialogState extends State<ColumnItemDialog> {
  ColorDerivative cardColor = ColorDerivative.fromColor(Colors.blue);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return IconButton.ghost(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                final FormController controller = FormController();
                return AlertDialog(
                  title: const Text("Card Title"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 800,
                          minWidth: 400,
                        ),
                        child: Form(
                          controller: controller,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: FormField(
                                  key: FormKey(#title),
                                  label: const Text("Title"),
                                  child: TextField(),
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: FormField(
                                  key: FormKey(#color),
                                  label: const Text("Card Color"),
                                  child: ColorInput(
                                    value: cardColor,
                                    promptMode: PromptMode.dialog,
                                    dialogTitle: const Text("Select Color"),
                                    onChanged: (value) {
                                      setState(() {
                                        cardColor = value;
                                      });
                                    },
                                    showLabel: true,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: FormField(
                                  key: FormKey(#description),
                                  label: const Text("Description"),
                                  child: TextArea(
                                    expandableHeight: true,
                                    initialHeight: 150,
                                  ),
                                ),
                              ),
                            ],
                          ).gap(16),
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
                      child: const Text("Save"),
                    ),
                  ],
                );
              },
            );
          },
          icon: const Icon(LucideIcons.pencilLine, size: 16),
        );
      },
    );
  }
}
