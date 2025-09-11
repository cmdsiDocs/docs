// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:idb_shim/idb_browser.dart';

import 'file_storage.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static const String _dbName = 'cmdsidocs_pages_db';
  static const String _pagesStore = 'pages';

  Database? _db;

  DatabaseHelper._privateConstructor();

  /// Initialize DB (call once at app start, e.g. in main() before runApp)
  Future<void> init() async {
    if (_db != null) return;
    _db = await idbFactoryBrowser.open(_dbName, version: 1,
        onUpgradeNeeded: (VersionChangeEvent e) {
      final db = e.database;
      if (!db.objectStoreNames.contains(_pagesStore)) {
        // keyPath is 'id' because your sqlite table uses id integer primary key
        db.createObjectStore(_pagesStore, keyPath: 'id');
      }
    });

    // If pages store is empty, load from assets/pages.json (first-run)
    final tx = _db!.transaction(_pagesStore, idbModeReadOnly);
    final store = tx.objectStore(_pagesStore);
    final existing = await store.getAll();
    await tx.completed;
    if (existing.isEmpty) {
      // load asset json
      final jsonStr = await rootBundle.loadString('assets/database/pages.json');
      final List parsed = jsonDecode(jsonStr) as List;
      if (parsed.isNotEmpty) {
        final tx2 = _db!.transaction(_pagesStore, idbModeReadWrite);
        final store2 = tx2.objectStore(_pagesStore);
        for (final dynamic row in parsed) {
          // ensure id exists; if not, you may want to assign one
          final mapRow = Map<String, dynamic>.from(row as Map);
          if (!mapRow.containsKey('id')) {
            // assign a temporary id if needed (shouldn't happen if export kept ids)
            mapRow['id'] = DateTime.now().microsecondsSinceEpoch;
          }
          await store2.put(mapRow);
        }
        await tx2.completed;
      }
    }
  }

  /// Fetch all pages (flat)
  Future<List<Map<String, dynamic>>> fetchAllPages() async {
    final db =
        _db ?? (throw StateError('Database not initialized. Call init()'));
    final tx = db.transaction(_pagesStore, idbModeReadOnly);
    final store = tx.objectStore(_pagesStore);
    final raw = await store.getAll();
    await tx.completed;
    // raw entries are dynamic maps; ensure correct typing
    return raw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  /// Fetch pages by pageId (main pages where is_main_page=1 and page_id=pageId)
  /// and attach children recursively under 'children' key.
  Future<List<Map<String, dynamic>>> fetchAllPagesByPageId(int pageId) async {
    final all = await fetchAllPages();

    // helper to build nested children by scanning all pages
    List<Map<String, dynamic>> _buildChildren(int parentId) {
      final children = all
          .where((p) {
            final pid = p['parent_page_id'];
            if (pid == null) return false;
            // values may be int or string; convert safely
            return (pid is int ? pid : int.tryParse(pid.toString())) ==
                parentId;
          })
          .map((p) => Map<String, dynamic>.from(p))
          .toList();

      for (final child in children) {
        child['children'] = _buildChildren((child['id'] as num).toInt());
      }
      return children;
    }

    // find main pages
    final mainPages = all
        .where((p) {
          final isMain = p['is_main_page'];
          final pid = p['page_id'];
          final isMainInt =
              (isMain is int ? isMain : int.tryParse(isMain.toString()));
          final pageIdInt = (pid is int ? pid : int.tryParse(pid.toString()));
          return isMainInt == 1 && pageIdInt == pageId;
        })
        .map((p) => Map<String, dynamic>.from(p))
        .toList();

    // attach recursive children
    for (final mp in mainPages) {
      mp['children'] = _buildChildren((mp['id'] as num).toInt());
    }

    return mainPages;
  }

  /// Insert page metadata (row must include 'id' or we will fail - ensure you set id)
  Future<Map<String, dynamic>> insertPage(Map<String, dynamic> row) async {
    final db =
        _db ?? (throw StateError('Database not initialized. Call init()'));
    try {
      final tx = db.transaction(_pagesStore, idbModeReadWrite);
      final store = tx.objectStore(_pagesStore);
      // if row doesn't contain id, create one:
      final mapRow = Map<String, dynamic>.from(row);
      if (!mapRow.containsKey('id')) {
        // simple id generator (use something safer in production)
        mapRow['id'] = DateTime.now().millisecondsSinceEpoch;
      }
      await store.put(mapRow);
      await tx.completed;
      return {"success": 'Y', "msg": 'Inserted Successful'};
    } catch (err) {
      return {"success": 'N', "msg": 'Failed to insert error: $err'};
    }
  }

  /// Update page metadata and optionally save content (content saved separately)
  Future<Map<String, dynamic>> updatePage(int id, Map<String, dynamic> row,
      {String? content}) async {
    final db =
        _db ?? (throw StateError('Database not initialized. Call init()'));
    try {
      final tx = db.transaction(_pagesStore, idbModeReadWrite);
      final store = tx.objectStore(_pagesStore);
      final existing = await store.getObject(id);
      if (existing == null) {
        await tx.completed;
        return {"success": 'N', "msg": 'Row not found'};
      }
      final merged = Map<String, dynamic>.from(existing as Map)
        ..addAll(row)
        ..['id'] = id;
      await store.put(merged);
      await tx.completed;

      if (content != null) {
        await FileStorage.saveFile(id, content);
      }

      return {"success": 'Y', "msg": 'Updated Successful'};
    } catch (err) {
      return {"success": 'N', "msg": 'Failed to update error: $err'};
    }
  }

  /// Delete page metadata + file content
  Future<Map<String, dynamic>> deletePage(int id) async {
    final db =
        _db ?? (throw StateError('Database not initialized. Call init()'));
    try {
      final tx = db.transaction(_pagesStore, idbModeReadWrite);
      final store = tx.objectStore(_pagesStore);
      await store.delete(id);
      await tx.completed;

      await FileStorage.deleteFile(id);
      return {"success": 'Y', "msg": 'Deleted Successful'};
    } catch (err) {
      return {"success": 'N', "msg": 'Failed to delete error: $err'};
    }
  }

  /// Save page content to browser storage (files store)
  Future<Map<String, dynamic>> insertUpdateNewTextFile(
      int id, String content) async {
    try {
      await FileStorage.saveFile(id, content);
      return {"success": 'Y', "msg": 'Inserted Successful'};
    } catch (err) {
      return {"success": 'N', "msg": 'Failed to insert error: $err'};
    }
  }

  /// Get page content (read from files store)
  Future<List<dynamic>> getPageContent(int id) async {
    final str = await FileStorage.readFile(id);

    if (str != null && str.isNotEmpty) {
      try {
        return jsonDecode(str);
      } catch (_) {
        return jsonDecode(str);
      }
    }
    return [];
  }
}
