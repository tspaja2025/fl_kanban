import 'package:shadcn_flutter/shadcn_flutter.dart';

class Badge extends StatelessWidget {
  final String child;
  final Color? color;

  const Badge({super.key, required this.child, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Text(child, style: TextStyle(color: Colors.white)).xSmall.semiBold,
    );
  }
}
