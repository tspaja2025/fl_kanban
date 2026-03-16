import 'package:fl_kanban/screens/default_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

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

// class DefaultScreen extends ConsumerStatefulWidget {
//   const DefaultScreen({super.key});

//   @override
//   ConsumerState<DefaultScreen> createState() => _DefaultScreenState();
// }

// class _DefaultScreenState extends ConsumerState<DefaultScreen> {
//   // List of columns, each containing a list of items
//   List<List<SortableData<String>>> columns = [
//     // Column 1
//     [
//       const SortableData('James'),
//       const SortableData('John'),
//       const SortableData('Robert'),
//       const SortableData('Michael'),
//       const SortableData('William'),
//     ],
//     // Column 2
//     [
//       const SortableData('David'),
//       const SortableData('Richard'),
//       const SortableData('Joseph'),
//       const SortableData('Thomas'),
//       const SortableData('Charles'),
//     ],
//     // Column 3 - Add as many as you want!
//     [
//       const SortableData('Alice'),
//       const SortableData('Bob'),
//       const SortableData('Charlie'),
//       const SortableData('Diana'),
//     ],
//     // Column 4
//     [
//       const SortableData('Eve'),
//       const SortableData('Frank'),
//       const SortableData('Grace'),
//       const SortableData('Henry'),
//     ],
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       child: SafeArea(
//         minimum: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             SizedBox(
//               height: 500,
//               child: SortableLayer(
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     for (
//                       int colIndex = 0;
//                       colIndex < columns.length;
//                       colIndex++
//                     )
//                       Expanded(
//                         child: Padding(
//                           padding: EdgeInsets.only(left: colIndex > 0 ? 12 : 0),
//                           child: _buildColumn(columns[colIndex], colIndex),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildColumn(List<SortableData<String>> items, int columnIndex) {
//     return Card(
//       child: SortableDropFallback<String>(
//         onAccept: (value) {
//           setState(() {
//             _moveItem(value, items, items.length, columnIndex);
//           });
//         },
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Optional column header
//             Container(
//               padding: const EdgeInsets.all(8),
//               color: Colors.gray[200],
//               child: Center(
//                 child: Text(
//                   'Column ${columnIndex + 1}',
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//             // Items
//             for (int i = 0; i < items.length; i++)
//               Sortable<String>(
//                 data: items[i],
//                 onAcceptTop: (value) {
//                   setState(() {
//                     _moveItem(value, items, i, columnIndex);
//                   });
//                 },
//                 onAcceptBottom: (value) {
//                   setState(() {
//                     _moveItem(value, items, i + 1, columnIndex);
//                   });
//                 },
//                 child: OutlinedContainer(
//                   padding: const EdgeInsets.all(12),
//                   child: Center(child: Text(items[i].data)),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _moveItem(
//     SortableData<String> item,
//     List<SortableData<String>> targetColumn,
//     int targetIndex,
//     int targetColumnIndex,
//   ) {
//     // Find and remove from source column
//     for (var column in columns) {
//       if (column.contains(item)) {
//         column.remove(item);
//         break;
//       }
//     }

//     // Insert into target column at specified index
//     targetColumn.insert(targetIndex, item);
//   }
// }
