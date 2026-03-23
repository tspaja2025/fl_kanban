import "package:fl_kanban/screens/default_screen.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:shadcn_flutter/shadcn_flutter.dart";

void main() {
  runApp(const ProviderScope(child: FlKanban()));
}

class FlKanban extends ConsumerStatefulWidget {
  const FlKanban({super.key});

  @override
  ConsumerState<FlKanban> createState() => _FlKanbanState();
}

class _FlKanbanState extends ConsumerState<FlKanban> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ShadcnApp(
      debugShowCheckedModeBanner: false,
      title: "Your Kanban Board",
      theme: ThemeData(colorScheme: ColorSchemes.lightNeutral),
      darkTheme: ThemeData(colorScheme: ColorSchemes.darkNeutral),
      themeMode: _themeMode,
      home: DefaultScreen(onThemeToggle: _toggleTheme, themeMode: _themeMode),
    );
  }
}
