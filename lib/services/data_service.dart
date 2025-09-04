// services/data_service.dart
import 'dart:convert';

import 'package:flutter/foundation.dart' hide Category;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/category.dart';
import '../models/item.dart';
import '../models/subcategory.dart';

class DataService with ChangeNotifier {
  List<Category> _categories = [];
  List<SubCategory> _subCategories = [];
  List<Item> _items = [];

  List<Category> get categories => _categories;
  List<SubCategory> get subCategories => _subCategories;
  List<Item> get items => _items;

  DataService() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load categories
    final categoriesJson = prefs.getString('categories');
    if (categoriesJson != null) {
      final List<dynamic> categoriesList = json.decode(categoriesJson);
      _categories = categoriesList.map((e) => Category.fromMap(e)).toList();
    } else {
      // Add default categories with new structure
      _categories = [
        Category(
          name: 'Luvpark for Client',
          description: 'Client-facing parking management system',
          imagePath: 'assets/images/client.png',
        ),
        Category(
          name: 'Luvpark SPMS',
          description: 'Smart Parking Management System',
          imagePath: 'assets/images/spms.png',
        ),
      ];
      await _saveCategories();
      await _addDefaultSubCategories();
    }

    // Load subcategories
    final subCategoriesJson = prefs.getString('subCategories');
    if (subCategoriesJson != null) {
      final List<dynamic> subCategoriesList = json.decode(subCategoriesJson);
      _subCategories =
          subCategoriesList.map((e) => SubCategory.fromMap(e)).toList();
    }

    // Load items
    final itemsJson = prefs.getString('items');
    if (itemsJson != null) {
      final List<dynamic> itemsList = json.decode(itemsJson);
      _items = itemsList.map((e) => Item.fromMap(e)).toList();
    }

    notifyListeners();
  }

  Future<void> _addDefaultSubCategories() async {
    final spmsCategory =
        _categories.firstWhere((c) => c.name == 'Luvpark SPMS');

    final defaultSubCategories = [
      SubCategory(
        categoryId: spmsCategory.id,
        name: 'Parking Attendant',
        description: 'Manage parking attendant operations and activities',
        imagePath: 'assets/images/attendant.png',
      ),
      SubCategory(
        categoryId: spmsCategory.id,
        name: 'Inspector',
        description: 'Manage inspector operations and monitoring',
        imagePath: 'assets/images/inspector.png',
      ),
      SubCategory(
        categoryId: spmsCategory.id,
        name: 'Auditor',
        description: 'Manage auditing and reporting operations',
        imagePath: 'assets/images/auditor.png',
      ),
    ];

    for (var subCategory in defaultSubCategories) {
      _subCategories.add(subCategory);
    }

    await _saveSubCategories();
  }

  Future<void> _saveCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final categoriesJson =
        json.encode(_categories.map((e) => e.toMap()).toList());
    await prefs.setString('categories', categoriesJson);
  }

  Future<void> _saveSubCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final subCategoriesJson =
        json.encode(_subCategories.map((e) => e.toMap()).toList());
    await prefs.setString('subCategories', subCategoriesJson);
  }

  Future<void> _saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    final itemsJson = json.encode(_items.map((e) => e.toMap()).toList());
    await prefs.setString('items', itemsJson);
  }

  // Category CRUD operations
  Future<void> addCategory(Category category) async {
    _categories.add(category);
    await _saveCategories();
    notifyListeners();
  }

  Future<void> updateCategory(Category category) async {
    final index = _categories.indexWhere((c) => c.id == category.id);
    if (index != -1) {
      _categories[index] = category;
      await _saveCategories();
      notifyListeners();
    }
  }

  Future<void> deleteCategory(String id) async {
    _categories.removeWhere((c) => c.id == id);
    // Also delete related subcategories and items
    _subCategories.removeWhere((sc) => sc.categoryId == id);
    _items.removeWhere((item) => item.categoryId == id);
    await _saveCategories();
    await _saveSubCategories();
    await _saveItems();
    notifyListeners();
  }

  // SubCategory CRUD operations
  Future<void> addSubCategory(SubCategory subCategory) async {
    _subCategories.add(subCategory);
    await _saveSubCategories();
    notifyListeners();
  }

  Future<void> updateSubCategory(SubCategory subCategory) async {
    final index = _subCategories.indexWhere((sc) => sc.id == subCategory.id);
    if (index != -1) {
      _subCategories[index] = subCategory;
      await _saveSubCategories();
      notifyListeners();
    }
  }

  Future<void> deleteSubCategory(String id) async {
    _subCategories.removeWhere((sc) => sc.id == id);
    // Also delete related items
    _items.removeWhere((item) => item.subCategoryId == id);
    await _saveSubCategories();
    await _saveItems();
    notifyListeners();
  }

  // Item CRUD operations
  Future<void> addItem(Item item) async {
    try {
      _items.add(item);
      await _saveItems();
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding item: $e');
      rethrow;
    }
  }

  Future<void> updateItem(Item item) async {
    final index = _items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      _items[index] = item;
      await _saveItems();
      notifyListeners();
    }
  }

  Future<void> deleteItem(String id) async {
    _items.removeWhere((i) => i.id == id);
    await _saveItems();
    notifyListeners();
  }

  // Helper methods
  List<SubCategory> getSubCategoriesByCategory(String categoryId) {
    return _subCategories.where((sc) => sc.categoryId == categoryId).toList();
  }

  List<Item> getItemsByCategory(String? categoryId) {
    return _items.where((item) => item.categoryId == categoryId).toList();
  }

  List<Item> getItemsBySubCategory(String? subCategoryId) {
    return _items.where((item) => item.subCategoryId == subCategoryId).toList();
  }

  Category getCategoryById(String categoryId) {
    return _categories.firstWhere(
      (c) => c.id == categoryId,
      orElse: () => Category(
        name: 'Unknown Category',
        description: 'This category could not be found',
      ),
    );
  }
}
