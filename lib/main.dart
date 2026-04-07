import 'package:fl_kanban/providers/router_provider.dart';
import 'package:fl_kanban/providers/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

void main() {
  runApp(const ProviderScope(child: FlKanban()));
}

class FlKanban extends ConsumerWidget {
  const FlKanban({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final router = ref.watch(routerProvider);

    return ShadcnApp.router(
      key: ValueKey(themeMode),
      debugShowCheckedModeBanner: false,
      title: "Your Kanban Board",
      theme: ThemeData(colorScheme: ColorSchemes.lightNeutral),
      darkTheme: ThemeData(colorScheme: ColorSchemes.darkNeutral),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
