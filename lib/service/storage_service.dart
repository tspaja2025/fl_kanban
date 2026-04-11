import 'dart:convert';
import 'dart:io';
import 'package:fl_kanban/models/models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class StorageService {
  static const String _kanbanJsonFile = "kanban_data.json";

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File("$path/$_kanbanJsonFile");
  }

  // Save data to JSON
  Future<void> saveKanbanData(List<KanbanData> kanbanData) async {
    try {
      final file = await _localFile;
      final jsonList = kanbanData.map((project) => project.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      await file.writeAsString(jsonString);
    } catch (e) {
      debugPrint("Error saving kanban data: $e");
      rethrow;
    }
  }

  // Load data from JSON
  Future<List<KanbanData>> loadKanbanData() async {
    try {
      final file = await _localFile;

      if (!await file.exists()) {
        return [];
      }

      final jsonString = await file.readAsString();
      final jsonList = jsonDecode(jsonString) as List;

      return jsonList.map((json) => KanbanData.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Error loading kanban data: $e");
      return [];
    }
  }

  // Delete saved data
  Future<void> clearSavedData() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      debugPrint("Error clearing saved data: $e");
    }
  }
}
