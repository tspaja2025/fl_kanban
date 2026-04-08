import 'package:fl_kanban/shared/app_header.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class AppScaffold extends ConsumerWidget {
  final Widget child;
  final bool showBackButton;
  final bool showHeader;

  const AppScaffold({
    super.key,
    required this.child,
    this.showBackButton = false,
    this.showHeader = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      headers: showHeader
          ? [AppHeader(showBackButton: showBackButton), const Divider()]
          : [],
      child: child,
    );
  }
}
