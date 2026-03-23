import "package:fl_kanban/screens/home_screen.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:shadcn_flutter/shadcn_flutter.dart";

void main() {
  runApp(const ProviderScope(child: FlKanban()));
}

class FlKanban extends StatelessWidget {
  const FlKanban({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadcnApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter Kanban",
      theme: ThemeData(colorScheme: ColorSchemes.lightNeutral),
      home: const HomeScreen(),
    );
  }
}
