// services/image_service.dart
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ImageService {
  static final ImagePicker _picker = ImagePicker();

  static Future<String?> pickAndSaveImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (pickedFile == null) return null;

      // Handle web vs mobile differently
      if (kIsWeb) {
        return pickedFile.path; // For web, we'll handle differently
      } else {
        // For mobile, save to app directory
        return await _saveImageToAppDirectory(File(pickedFile.path));
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    }
  }

  static Future<String> _saveImageToAppDirectory(File imageFile) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = File(path.join(appDir.path, fileName));

      // Compress image before saving
      final compressedImage = await FlutterImageCompress.compressWithFile(
        imageFile.absolute.path,
        minWidth: 600,
        minHeight: 600,
        quality: 85,
      );

      if (compressedImage != null) {
        await savedImage.writeAsBytes(compressedImage);
        return savedImage.path;
      }

      // Fallback: copy original file
      await imageFile.copy(savedImage.path);
      return savedImage.path;
    } catch (e) {
      debugPrint('Error saving image: $e');
      rethrow;
    }
  }

  static bool isAssetImage(String? imagePath) {
    if (imagePath == null) return false;
    return imagePath.startsWith('assets/');
  }

  static bool isNetworkImage(String? imagePath) {
    if (imagePath == null) return false;
    return imagePath.startsWith('http://') || imagePath.startsWith('https://');
  }

  static bool isLocalFile(String? imagePath) {
    if (imagePath == null) return false;
    return !isAssetImage(imagePath) &&
        !isNetworkImage(imagePath) &&
        !isBlobUrl(imagePath);
  }

  static bool isBlobUrl(String? imagePath) {
    if (imagePath == null) return false;
    return imagePath.startsWith('blob:');
  }

  static String getPlaceholderImage() {
    return 'assets/placeholder/image_placeholder.png';
  }
}
