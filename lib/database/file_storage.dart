import 'package:idb_shim/idb_browser.dart';

class FileStorage {
  static Future<Database> _openDb() async {
    final factory = getIdbFactory()!;
    return await factory.open("file_storage", version: 1,
        onUpgradeNeeded: (VersionChangeEvent e) {
      Database db = e.database;
      db.createObjectStore("files");
    });
  }

  static Future<void> saveFile(int id, String content) async {
    final db = await _openDb();
    final txn = db.transaction("files", idbModeReadWrite);
    final store = txn.objectStore("files");
    await store.put(content, "$id.text");
    await txn.completed;
  }

  static Future<String?> readFile(int id) async {
    final db = await _openDb();
    final txn = db.transaction("files", idbModeReadOnly);
    final store = txn.objectStore("files");
    final value = await store.getObject("$id.text");
    await txn.completed;
    return value as String?;
  }

  static Future<void> deleteFile(int id) async {
    final db = await _openDb();
    final txn = db.transaction("files", idbModeReadWrite);
    final store = txn.objectStore("files");
    await store.delete("$id.text");
    await txn.completed;
  }
}
