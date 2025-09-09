import 'package:hive/hive.dart';

part 'model.g.dart';

@HiveType(typeId: 1)
class Account extends HiveObject {
  @HiveField(0)
  String username;

  @HiveField(1)
  String password;

  @HiveField(2)
  String role;

  @HiveField(3)
  bool undeletable;

  Account(
      {required this.username,
      required this.password,
      required this.role,
      this.undeletable = false});
}

@HiveType(typeId: 2)
class FileItem extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String path;

  @HiveField(2)
  String title;

  @HiveField(3)
  String description;

  FileItem(
      {required this.name,
      required this.path,
      this.title = "",
      this.description = ""});
}

@HiveType(typeId: 3)
class Folder extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<FileItem> files;

  @HiveField(2)
  List<Folder> subfolders;

  Folder({required this.name, List<FileItem>? files, List<Folder>? subfolders})
      : files = files ?? [],
        subfolders = subfolders ?? [];
}
