// screens/item_screen.dart
import 'package:flutter/material.dart';

import '../models/item.dart';

class ItemScreen extends StatelessWidget {
  final Item item;

  const ItemScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.imagePath != null)
              Center(
                child: Image.asset(
                  item.imagePath!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey[200],
                child: const Icon(Icons.image, size: 64, color: Colors.grey),
              ),
            const SizedBox(height: 24),
            Text(
              item.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              item.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Created: ${_formatDate(item.createdAt)}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.update, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Updated: ${_formatDate(item.updatedAt)}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
