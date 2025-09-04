// models/item.dart
import 'package:uuid/uuid.dart';

class Item {
  final String id;
  final String name;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? imagePath;
  final String? categoryId;
  final String? subCategoryId;
  final String? subSubCategoryId;

  Item({
    String? id,
    required this.name,
    required this.description,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.imagePath,
    this.categoryId,
    this.subCategoryId,
    this.subSubCategoryId,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Item copyWith({
    String? name,
    String? description,
    DateTime? updatedAt,
    String? imagePath,
  }) {
    return Item(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      imagePath: imagePath ?? this.imagePath,
      categoryId: categoryId,
      subCategoryId: subCategoryId,
      subSubCategoryId: subSubCategoryId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'imagePath': imagePath,
      'categoryId': categoryId,
      'subCategoryId': subCategoryId,
      'subSubCategoryId': subSubCategoryId,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      imagePath: map['imagePath'],
      categoryId: map['categoryId'],
      subCategoryId: map['subCategoryId'],
      subSubCategoryId: map['subSubCategoryId'],
    );
  }
}
