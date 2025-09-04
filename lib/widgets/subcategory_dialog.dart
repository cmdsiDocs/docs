// widgets/subcategory_dialog.dart (updated)
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../models/subcategory.dart';
import '../services/data_service.dart';

class SubCategoryDialog extends StatefulWidget {
  final Category category;
  final SubCategory? subCategory;

  const SubCategoryDialog({
    super.key,
    required this.category,
    this.subCategory,
  });

  @override
  State<SubCategoryDialog> createState() => _SubCategoryDialogState();
}

class _SubCategoryDialogState extends State<SubCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    if (widget.subCategory != null) {
      _nameController.text = widget.subCategory!.name;
      _descriptionController.text = widget.subCategory!.description;
      _imagePath = widget.subCategory!.imagePath;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          widget.subCategory == null ? 'Add Subcategory' : 'Edit Subcategory'),
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
          onPressed: _saveSubCategory,
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

  void _saveSubCategory() {
    if (_formKey.currentState!.validate()) {
      final dataService = Provider.of<DataService>(context, listen: false);

      if (widget.subCategory == null) {
        final newSubCategory = SubCategory(
          categoryId: widget.category.id,
          name: _nameController.text,
          description: _descriptionController.text,
          imagePath: _imagePath,
        );
        dataService.addSubCategory(newSubCategory);
      } else {
        final updatedSubCategory = widget.subCategory!.copyWith(
          name: _nameController.text,
          description: _descriptionController.text,
          imagePath: _imagePath,
        );
        dataService.updateSubCategory(updatedSubCategory);
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
