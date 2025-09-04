// screens/home_screen.dart (updated)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../models/subcategory.dart';
import '../services/data_service.dart';
import '../widgets/item_dialog.dart';
import '../widgets/subcategory_dialog.dart';
import 'category_screen.dart';
import 'subcategory_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  Category? _selectedCategory;
  SubCategory? _selectedSubCategory;

  @override
  Widget build(BuildContext context) {
    final dataService = Provider.of<DataService>(context);
    final categories = dataService.categories;

    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle()),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: _buildDrawer(context, categories),
      body: _buildBody(context),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  String _getAppBarTitle() {
    if (_selectedSubCategory != null) {
      return _selectedSubCategory!.name;
    } else if (_selectedCategory != null) {
      return _selectedCategory!.name;
    }
    return 'Parking Management';
  }

  Widget _buildDrawer(BuildContext context, List<Category> categories) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.local_parking, size: 48, color: Colors.white),
                SizedBox(height: 8),
                Text(
                  'Parking Management',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return ExpansionTile(
                  leading: const Icon(Icons.category),
                  title: Text(category.name),
                  onExpansionChanged: (expanded) {
                    if (expanded) {
                      setState(() {
                        _selectedCategory = category;
                        _selectedSubCategory = null;
                        _selectedIndex = 0;
                      });
                    }
                  },
                  children: [
                    ..._buildSubCategoryTiles(context, category),
                    ListTile(
                      leading: const Icon(Icons.add),
                      title: const Text('Add Subcategory'),
                      onTap: () {
                        Navigator.pop(context);
                        _showAddSubCategoryDialog(context, category);
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSubCategoryTiles(BuildContext context, Category category) {
    final dataService = Provider.of<DataService>(context);
    final subCategories = dataService.getSubCategoriesByCategory(category.id);

    return subCategories.map((subCategory) {
      return Padding(
        padding: const EdgeInsets.only(left: 24.0),
        child: ListTile(
          leading: const Icon(Icons.subdirectory_arrow_right),
          title: Text(subCategory.name),
          onTap: () {
            setState(() {
              _selectedCategory = category;
              _selectedSubCategory = subCategory;
              _selectedIndex = 1;
            });
            Navigator.pop(context);
          },
          trailing: PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Text('Edit'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete'),
              ),
            ],
            onSelected: (value) {
              if (value == 'edit') {
                _showEditSubCategoryDialog(context, subCategory);
              } else if (value == 'delete') {
                _showDeleteSubCategoryDialog(context, subCategory);
              }
            },
          ),
        ),
      );
    }).toList();
  }

  Widget _buildBody(BuildContext context) {
    if (_selectedIndex == 0 && _selectedCategory != null) {
      return CategoryScreen(category: _selectedCategory!);
    } else if (_selectedIndex == 1 &&
        _selectedSubCategory != null &&
        _selectedCategory != null) {
      return SubCategoryScreen(
        category: _selectedCategory!,
        subCategory: _selectedSubCategory!,
      );
    }
    return _buildDashboard();
  }

  Widget _buildDashboard() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.dashboard, size: 64, color: Colors.blue),
          SizedBox(height: 16),
          Text(
            'Welcome to Parking Management',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Select a category from the drawer to get started',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget? _buildFloatingActionButton(BuildContext context) {
    if (_selectedCategory != null && _selectedIndex == 0) {
      return FloatingActionButton(
        onPressed: () => _showAddItemDialog(context, _selectedCategory!, null),
        child: const Icon(Icons.add),
      );
    } else if (_selectedSubCategory != null && _selectedIndex == 1) {
      return FloatingActionButton(
        onPressed: () => _showAddItemDialog(
            context, _selectedCategory!, _selectedSubCategory!),
        child: const Icon(Icons.add),
      );
    }
    return null;
  }

  void _showAddSubCategoryDialog(BuildContext context, Category category) {
    showDialog(
      context: context,
      builder: (context) => SubCategoryDialog(category: category),
    );
  }

  void _showEditSubCategoryDialog(
      BuildContext context, SubCategory subCategory) {
    final dataService = Provider.of<DataService>(context, listen: false);
    final category = dataService.categories.firstWhere(
      (c) => c.id == subCategory.categoryId,
      orElse: () => Category(name: 'Unknown', description: 'Unknown'),
    );

    showDialog(
      context: context,
      builder: (context) => SubCategoryDialog(
        category: category,
        subCategory: subCategory,
      ),
    );
  }

  void _showDeleteSubCategoryDialog(
      BuildContext context, SubCategory subCategory) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Subcategory'),
        content: Text('Are you sure you want to delete ${subCategory.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<DataService>(context, listen: false)
                  .deleteSubCategory(subCategory.id);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddItemDialog(
      BuildContext context, Category? category, SubCategory? subCategory) {
    if (category == null) return;

    showDialog(
      context: context,
      builder: (context) => ItemDialog(
        category: category,
        subCategory: subCategory,
      ),
    );
  }
}
