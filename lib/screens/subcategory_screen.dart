// screens/subcategory_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../models/item.dart';
import '../models/subcategory.dart';
import '../services/data_service.dart';
import '../widgets/item_dialog.dart';
import 'item_screen.dart';

class SubCategoryScreen extends StatelessWidget {
  final Category category;
  final SubCategory subCategory;

  const SubCategoryScreen({
    super.key,
    required this.category,
    required this.subCategory,
  });

  @override
  Widget build(BuildContext context) {
    final dataService = Provider.of<DataService>(context);
    final items = dataService.getItemsBySubCategory(subCategory.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(subCategory.name),
      ),
      body: items.isEmpty
          ? const Center(
              child: Text('No items found. Add some items to get started.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return _buildItemCard(context, item);
              },
            ),
    );
  }

  Widget _buildItemCard(BuildContext context, Item item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: item.imagePath != null
            ? CircleAvatar(
                backgroundImage: AssetImage(item.imagePath!),
                radius: 24,
              )
            : const CircleAvatar(
                child: Icon(Icons.image),
              ),
        title: Text(
          item.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              'Updated: ${_formatDate(item.updatedAt)}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
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
              _showEditItemDialog(context, item);
            } else if (value == 'delete') {
              _showDeleteItemDialog(context, item);
            }
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ItemScreen(item: item),
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showEditItemDialog(BuildContext context, Item item) {
    showDialog(
      context: context,
      builder: (context) => ItemDialog(
        category: category,
        subCategory: subCategory,
        item: item,
      ),
    );
  }

  void _showDeleteItemDialog(BuildContext context, Item item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete ${item.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<DataService>(context, listen: false)
                  .deleteItem(item.id);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
