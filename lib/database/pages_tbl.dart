// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../variables.dart';

class DatabaseHelper {
  static const _databaseVersion = 1;

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, '$pagesTbl.db');

    return await openDatabase(path, version: _databaseVersion,
        onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE $pagesTbl (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          description TEXT,
          is_main_page INTEGER NOT NULL DEFAULT 0,
          parent_page_id INTEGER,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
      ''');
    });
  }

  /// Insert a page and save content to a .text file
  Future<int> insertPage(Map<String, dynamic> row, String content) async {
    final db = await database;
    final id = await db.insert(pagesTbl, row);

    await _saveContentFile(id, content);
    return id;
  }

  /// Update a page content
  Future<int> updatePage(
      int id, Map<String, dynamic> row, String content) async {
    final db = await database;
    await _saveContentFile(id, content);
    return await db.update(pagesTbl, row, where: "id = ?", whereArgs: [id]);
  }

  /// Delete page + file
  Future<int> deletePage(int id) async {
    final db = await database;
    await _deleteContentFile(id);
    return await db.delete(pagesTbl, where: "id = ?", whereArgs: [id]);
  }

  /// Fetch all pages (metadata only, no text content)
  Future<List<Map<String, dynamic>>> fetchAllPages() async {
    final db = await database;
    return await db.query(pagesTbl);
  }

  /// Get content of a page by ID
  Future<String?> getPageContent(int id) async {
    final file = await _getFile(id);
    if (await file.exists()) {
      return await file.readAsString();
    }
    return null;
  }

  /// 🔽 Private helpers for file management 🔽

  Future<File> _getFile(int id) async {
    final dir = await getApplicationDocumentsDirectory();
    // mimic assets/files structure
    final folder = Directory("${dir.path}/assets/files");
    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }
    return File("${folder.path}/$id.text");
  }

  Future<void> _saveContentFile(int id, String content) async {
    final file = await _getFile(id);
    await file.writeAsString(content);
  }

  Future<void> _deleteContentFile(int id) async {
    final file = await _getFile(id);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
