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
    return 'Luvpark Management';
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
                  'Luvpark System',
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
            child: ListView(
              children: [
                _buildMainCategoryTiles(context, categories),
                const Divider(),
                _buildQuickAccessTiles(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainCategoryTiles(
      BuildContext context, List<Category> categories) {
    return Column(
      children: categories.map((category) {
        return ExpansionTile(
          leading: category.imagePath != null
              ? Image.asset(category.imagePath!, width: 24, height: 24)
              : const Icon(Icons.category),
          title: Text(category.name),
          subtitle:
              Text(category.description, style: const TextStyle(fontSize: 12)),
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
            if (category.name == 'Luvpark SPMS')
              ..._buildSPMSSubCategories(context, category)
            else
              _buildClientCategoryContent(context, category),
          ],
        );
      }).toList(),
    );
  }

  List<Widget> _buildSPMSSubCategories(
      BuildContext context, Category category) {
    final dataService = Provider.of<DataService>(context);
    final subCategories = dataService.getSubCategoriesByCategory(category.id);

    return [
      ...subCategories.map((subCategory) {
        return Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: ListTile(
            leading: subCategory.imagePath != null
                ? Image.asset(subCategory.imagePath!, width: 20, height: 20)
                : const Icon(Icons.subdirectory_arrow_right, size: 20),
            title: Text(subCategory.name),
            subtitle: Text(subCategory.description,
                style: const TextStyle(fontSize: 12)),
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
      }),
      Padding(
        padding: const EdgeInsets.only(left: 24.0),
        child: ListTile(
          leading: const Icon(Icons.add, size: 20),
          title: const Text('Add Role'),
          onTap: () {
            Navigator.pop(context);
            _showAddSubCategoryDialog(context, category);
          },
        ),
      ),
    ];
  }

  Widget _buildClientCategoryContent(BuildContext context, Category category) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0),
      child: ListTile(
        leading: const Icon(Icons.phone_iphone, size: 20),
        title: const Text('Mobile App Features'),
        subtitle: const Text('Client-facing application',
            style: TextStyle(fontSize: 12)),
        onTap: () {
          setState(() {
            _selectedCategory = category;
            _selectedSubCategory = null;
            _selectedIndex = 0;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildQuickAccessTiles(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Quick Access',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.dashboard),
          title: const Text('Dashboard'),
          onTap: () {
            setState(() {
              _selectedCategory = null;
              _selectedSubCategory = null;
              _selectedIndex = 0;
            });
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Settings'),
          onTap: () {
            // Navigate to settings
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.help),
          title: const Text('Help & Support'),
          onTap: () {
            // Navigate to help
            Navigator.pop(context);
          },
        ),
      ],
    );
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
          Icon(Icons.local_parking, size: 64, color: Colors.blue),
          SizedBox(height: 16),
          Text(
            'Luvpark Management System',
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
        title: const Text('Delete Role'),
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
