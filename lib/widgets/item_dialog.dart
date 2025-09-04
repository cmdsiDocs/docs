// widgets/item_dialog.dart (updated)
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../models/item.dart';
import '../models/subcategory.dart';
import '../services/data_service.dart';

class ItemDialog extends StatefulWidget {
  final Category category;
  final SubCategory? subCategory;
  final Item? item;

  const ItemDialog({
    super.key,
    required this.category,
    this.subCategory,
    this.item,
  });

  @override
  State<ItemDialog> createState() => _ItemDialogState();
}

class _ItemDialogState extends State<ItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _nameController.text = widget.item!.name;
      _descriptionController.text = widget.item!.description;
      _imagePath = widget.item!.imagePath;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.item == null ? 'Add Item' : 'Edit Item'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Category: ${widget.category.name}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              if (widget.subCategory != null)
                Text(
                  'Subcategory: ${widget.subCategory!.name}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildImageSection(),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveItem,
          child: const Text('Save'),
        ),
      ],
    );
  }

  Widget _buildImageSection() {
    return Column(
      children: [
        if (_imagePath != null)
          Image.asset(
            _imagePath!,
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          )
        else
          Container(
            height: 100,
            width: 100,
            color: Colors.grey[200],
            child: const Icon(Icons.image, color: Colors.grey),
          ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: _pickImage,
          child: const Text('Pick Image'),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      final dataService = Provider.of<DataService>(context, listen: false);

      if (widget.item == null) {
        final newItem = Item(
          name: _nameController.text,
          description: _descriptionController.text,
          imagePath: _imagePath,
          categoryId: widget.category.id,
          subCategoryId: widget.subCategory?.id,
        );
        dataService.addItem(newItem);
      } else {
        final updatedItem = widget.item!.copyWith(
          name: _nameController.text,
          description: _descriptionController.text,
          imagePath: _imagePath,
        );
        dataService.updateItem(updatedItem);
      }

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
