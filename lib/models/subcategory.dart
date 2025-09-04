// models/subcategory.dart
import 'package:uuid/uuid.dart';

class SubCategory {
  final String id;
  final String categoryId;
  final String name;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? imagePath;
  final List<SubSubCategory>? subSubCategories;

  SubCategory({
    String? id,
    required this.categoryId,
    required this.name,
    required this.description,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.imagePath,
    this.subSubCategories,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  SubCategory copyWith({
    String? name,
    String? description,
    DateTime? updatedAt,
    String? imagePath,
    List<SubSubCategory>? subSubCategories,
  }) {
    return SubCategory(
      id: id,
      categoryId: categoryId,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      imagePath: imagePath ?? this.imagePath,
      subSubCategories: subSubCategories ?? this.subSubCategories,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryId': categoryId,
      'name': name,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'imagePath': imagePath,
      'subSubCategories': subSubCategories?.map((e) => e.toMap()).toList(),
    };
  }

  factory SubCategory.fromMap(Map<String, dynamic> map) {
    return SubCategory(
      id: map['id'],
      categoryId: map['categoryId'],
      name: map['name'],
      description: map['description'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      imagePath: map['imagePath'],
      subSubCategories: map['subSubCategories'] != null
          ? (map['subSubCategories'] as List)
              .map((e) => SubSubCategory.fromMap(e))
              .toList()
          : null,
    );
  }
}

class SubSubCategory {
  final String id;
  final String subCategoryId;
  final String name;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? imagePath;

  SubSubCategory({
    String? id,
    required this.subCategoryId,
    required this.name,
    required this.description,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.imagePath,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subCategoryId': subCategoryId,
      'name': name,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'imagePath': imagePath,
    };
  }

  factory SubSubCategory.fromMap(Map<String, dynamic> map) {
    return SubSubCategory(
      id: map['id'],
      subCategoryId: map['subCategoryId'],
      name: map['name'],
      description: map['description'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      imagePath: map['imagePath'],
    );
  }
}
