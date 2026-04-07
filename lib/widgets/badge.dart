import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class Badge extends ConsumerWidget {
  final String text;
  final Color backgroundColor;
  final Color foregroundColor;
  final EdgeInsets padding;
  final double borderRadius;
  final double fontSize;

  const Badge({
    super.key,
    required this.text,
    this.backgroundColor = const Color(0xFFE5E7EB),
    this.foregroundColor = const Color(0xFF111827),
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.borderRadius = 6,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: padding,
      child: Text(
        text,
        style: TextStyle(
          color: foregroundColor,
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// class BadgeVariants {
// //   static Badge success(String text) => Badge(
// //     text: text,
// //     backgroundColor: Color(0xFFDCFCE7),
// //     foregroundColor: Color(0xFF166534),
// //   );

// //   static Badge warning(String text) => Badge(
// //     text: text,
// //     backgroundColor: Color(0xFFFEF9C3),
// //     foregroundColor: Color(0xFF854D0E),
// //   );

// //   static Badge danger(String text) => Badge(
// //     text: text,
// //     backgroundColor: Color(0xFFFEE2E2),
// //     foregroundColor: Color(0xFF991B1B),
// //   );

// //   static Badge info(String text) => Badge(
// //     text: text,
// //     backgroundColor: Color(0xFFE0F2FE),
// //     foregroundColor: Color(0xFF075985),
// //   );
// // }
