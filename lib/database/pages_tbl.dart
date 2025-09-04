// ignore_for_file: depend_on_referenced_packages

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../variables.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    // open pages.db from project assets (for mobile/desktop)
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, '$pagesTbl.db');

    _database = await openDatabase(path, version: 1);
    return _database!;
  }

  /// Insert
  Future<int> insertPage(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert(pagesTbl, row);
  }

  /// Update
  Future<int> updatePage(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.update(
      pagesTbl,
      row,
      where: 'id = ?',
      whereArgs: [row['id']],
    );
  }

  /// Delete
  Future<int> deletePage(int id) async {
    final db = await instance.database;
    return await db.delete(pagesTbl, where: 'id = ?', whereArgs: [id]);
  }

  /// Fetch all
  Future<List<Map<String, dynamic>>> fetchAllPages() async {
    final db = await instance.database;
    return await db.query(pagesTbl);
  }

  /// Fetch sub pages
  Future<List<Map<String, dynamic>>> fetchSubPages(int parentId) async {
    final db = await instance.database;
    return await db.query(
      pagesTbl,
      where: 'parent_page_id = ?',
      whereArgs: [parentId],
    );
  }
}
