import 'package:fl_kanban/providers/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool value = false;

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);

    int themeValue = themeMode == ThemeMode.light
        ? 1
        : themeMode == ThemeMode.dark
        ? 2
        : 3;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Settings").large.bold,
            const Text("Manage your account and workspace preferences.").muted,
            const Gap(16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 360,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Profile Settings").semiBold,
                      const Gap(8),
                      const Text(
                        "Update your photo and personal details. This will be visible to your team.",
                      ).small.muted,
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Avatar(
                          size: 48,
                          backgroundColor: Colors.gray,
                          initials: Avatar.getInitials("TS"),
                          provider: const NetworkImage(
                            "https://avatars.githubusercontent.com/u/213942709?s=400&v=4",
                          ),
                        ),
                        const Gap(16),
                        PrimaryButton(
                          onPressed: () {},
                          child: const Text("Change photo"),
                        ),
                        const Gap(16),
                        OutlineButton(
                          onPressed: () {},
                          child: const Text("Remove"),
                        ),
                      ],
                    ),
                    const Gap(16),
                    SizedBox(
                      width: 500,
                      child: const FormField(
                        key: FormKey(#name),
                        label: Text("Full Name"),
                        child: TextField(),
                      ),
                    ),
                    const Gap(16),
                    SizedBox(
                      width: 500,
                      child: const FormField(
                        key: FormKey(#email),
                        label: Text("Email Address"),
                        child: TextField(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Gap(16),
            const Divider(),
            const Gap(16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 360,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Notifications").semiBold,
                      const Gap(8),
                      const Text(
                        "Choose how and when you want to be alerted about activity.",
                      ).small.muted,
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 500,
                      child: Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Task Assignments").semiBold,
                                const Text(
                                  "Notify me when a new task is assigned to me.",
                                ).small.muted,
                              ],
                            ),
                            Switch(
                              value: value,
                              onChanged: (value) {
                                setState(() {
                                  // Flip the switch.
                                  this.value = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(16),
                    SizedBox(
                      width: 500,
                      child: Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Due Date Reminders").semiBold,
                                const Text(
                                  "Receive alerts 24 hours before a task is due.",
                                ).small.muted,
                              ],
                            ),
                            Switch(
                              value: value,
                              onChanged: (value) {
                                setState(() {
                                  // Flip the switch.
                                  this.value = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(16),
                    SizedBox(
                      width: 500,
                      child: Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Workspace Updates").semiBold,
                                const Text(
                                  "Weekly digest of board activity and team mentions.",
                                ).small.muted,
                              ],
                            ),
                            Switch(
                              value: value,
                              onChanged: (value) {
                                setState(() {
                                  // Flip the switch.
                                  this.value = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Gap(16),
            const Divider(),
            const Gap(16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 360,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Workspace Preferences").semiBold,
                      const Gap(8),
                      const Text(
                        "Customize your personal visual experience across the dashboard.",
                      ).small.muted,
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RadioGroup(
                      value: themeValue,
                      onChanged: (newValue) {
                        ThemeMode newMode;

                        if (newValue == 1) {
                          newMode = ThemeMode.light;
                        } else if (newValue == 2) {
                          newMode = ThemeMode.dark;
                        } else {
                          newMode = ThemeMode.system;
                        }

                        ref.read(themeProvider.notifier).setTheme(newMode);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RadioCard(
                            value: 1,
                            child: _buildLightPreview(context, ref),
                          ),
                          const Gap(16),
                          RadioCard(
                            value: 2,
                            child: _buildDarkPreview(context, ref),
                          ),
                          const Gap(16),
                          RadioCard(
                            value: 3,
                            child: _buildSystemPreview(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Gap(16),
            const Divider(),
            const Gap(16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PrimaryButton(
                  onPressed: () {
                    showToast(
                      context: context,
                      location: ToastLocation.bottomRight,
                      builder: (context, overlay) {
                        return SurfaceCard(
                          child: Basic(
                            title: const Text("Preferences saved"),
                            trailing: PrimaryButton(
                              size: ButtonSize.small,
                              onPressed: () {
                                overlay.close();
                              },
                              child: const Text("Undo"),
                            ),
                            trailingAlignment: Alignment.center,
                          ),
                        );
                      },
                    );
                  },
                  child: const Text("Save Preferences"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLightPreview(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return Container(
      width: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.border),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: themeMode == ThemeMode.dark
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.primaryForeground,
              border: Border.all(color: Theme.of(context).colorScheme.border),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 20,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.gray.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const Gap(4),
                Container(
                  width: 30,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.gray.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const Gap(8),
                Container(
                  width: double.infinity,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.gray.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const Gap(4),
                Container(
                  width: 75,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.gray.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          const Gap(16),
          const Text("Light"),
        ],
      ),
    );
  }

  Widget _buildDarkPreview(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return Container(
      width: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.border),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: themeMode == ThemeMode.dark
                  ? Theme.of(context).colorScheme.primaryForeground
                  : Theme.of(context).colorScheme.primary,
              border: Border.all(color: Theme.of(context).colorScheme.border),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 20,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.gray.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const Gap(4),
                Container(
                  width: 30,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.gray.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const Gap(8),
                Container(
                  width: double.infinity,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.gray.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const Gap(4),
                Container(
                  width: 75,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.gray.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          const Gap(16),
          const Text("Dark"),
        ],
      ),
    );
  }

  Widget _buildSystemPreview(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.border),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.border),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryForeground,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Gap(16),
          const Text("System"),
        ],
      ),
    );
  }
}
