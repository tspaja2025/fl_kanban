import 'package:fl_kanban/providers/router_provider.dart';
import 'package:fl_kanban/providers/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class CreateNewProjectScreen extends ConsumerStatefulWidget {
  const CreateNewProjectScreen({super.key});

  @override
  ConsumerState<CreateNewProjectScreen> createState() =>
      _CreateNewProjectScreenState();
}

class _CreateNewProjectScreenState
    extends ConsumerState<CreateNewProjectScreen> {
  Iterable<String>? selectedValues;
  DateTime? _startValue;
  DateTime? _endValue;

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final notifier = ref.read(themeProvider.notifier);
    final router = ref.watch(routerProvider);

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SizedBox(
                width: 800,
                child: Form(
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

                      gap(16),

                      SizedBox(
                        width: double.infinity,
                        child: FormField(
                          key: FormKey(#description),
                          label: const Text("Description"),
                          child: TextArea(minLines: 4),
                        ),
                      ),

                      gap(16),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: FormField(
                              key: FormKey(#tags),
                              label: const Text("Tags"),
                              child: MultiSelect<String>(
                                itemBuilder: (context, item) {
                                  return MultiSelectChip(
                                    value: item,
                                    child: Text(item),
                                  );
                                },
                                constraints: const BoxConstraints(
                                  maxWidth: 200,
                                ),
                                value: selectedValues,
                                placeholder: const Text("Select tags"),
                                popup: const SelectPopup(
                                  items: SelectItemList(
                                    children: [
                                      SelectItemButton(
                                        value: "Work",
                                        child: Text("Work"),
                                      ),
                                      SelectItemButton(
                                        value: "Personal",
                                        child: Text("Personal"),
                                      ),
                                      SelectItemButton(
                                        value: "Ideas",
                                        child: Text("Ideas"),
                                      ),
                                    ],
                                  ),
                                ).call,
                                onChanged: (value) {
                                  setState(() {
                                    selectedValues = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          gap(8),
                          Tooltip(
                            tooltip: const TooltipContainer(
                              child: Text("New tag"),
                            ).call,
                            child: IconButton.primary(
                              onPressed: () {},
                              icon: const Icon(LucideIcons.plus),
                            ),
                          ),
                        ],
                      ),

                      gap(16),

                      FormField(
                        key: FormKey(#timeline),
                        label: const Text("Timeline"),
                        child: Row(
                          children: [
                            DatePicker(
                              value: _startValue,
                              mode: PromptMode.popover,
                              stateBuilder: (date) {
                                if (date.isAfter(DateTime.now())) {
                                  return DateState.disabled;
                                }
                                return DateState.enabled;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _startValue = value;
                                });
                              },
                            ),
                            gap(16),
                            const Text("-"),
                            gap(16),
                            DatePicker(
                              value: _endValue,
                              mode: PromptMode.popover,
                              stateBuilder: (date) {
                                if (date.isAfter(DateTime.now())) {
                                  return DateState.disabled;
                                }
                                return DateState.enabled;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _endValue = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      gap(16),

                      FormField(
                        key: FormKey(#team),
                        label: const Text("Team"),
                        child: PrimaryButton(
                          onPressed: () {},
                          leading: const Icon(LucideIcons.plus, size: 16),
                          child: const Text("New team member"),
                        ),
                      ),

                      gap(16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlineButton(
                            onPressed: () {},
                            leading: const Icon(LucideIcons.save, size: 16),
                            child: const Text("Save Draft"),
                          ),
                          SecondaryButton(
                            onPressed: () {
                              router.pop();
                            },
                            leading: const Icon(LucideIcons.save, size: 16),
                            child: const Text("Cancel"),
                          ),
                          PrimaryButton(
                            onPressed: () {},
                            leading: const Icon(LucideIcons.plus, size: 16),
                            child: const Text("Create"),
                          ),
                        ],
                      ).gap(8),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
