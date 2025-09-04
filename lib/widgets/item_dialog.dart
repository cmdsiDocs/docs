// widgets/item_dialog.dart (updated image handling)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../models/item.dart';
import '../models/subcategory.dart';
import '../services/data_service.dart';
import '../services/image_service.dart';
import '../widgets/custom_image_widget.dart';

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
  bool _isImageLoading = false;

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
          onPressed: _isImageLoading ? null : _saveItem,
          child: _isImageLoading
              ? const CircularProgressIndicator()
              : const Text('Save'),
        ),
      ],
    );
  }

  Widget _buildImageSection() {
    return Column(
      children: [
        CustomImageWidget(
          imagePath: _imagePath,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: _isImageLoading ? null : _pickImage,
          child: _isImageLoading
              ? const CircularProgressIndicator()
              : const Text('Pick Image'),
        ),
        if (_imagePath != null) ...[
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              setState(() {
                _imagePath = null;
              });
            },
            child: const Text('Remove Image'),
          ),
        ]
      ],
    );
  }

  Future<void> _pickImage() async {
    setState(() {
      _isImageLoading = true;
    });

    try {
      final imagePath = await ImageService.pickAndSaveImage();
      if (imagePath != null) {
        setState(() {
          _imagePath = imagePath;
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to pick image')),
      );
    } finally {
      setState(() {
        _isImageLoading = false;
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
