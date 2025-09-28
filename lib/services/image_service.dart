// lib/services/image_service.dart
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:html' as html;
import 'dart:convert';
import 'dart:typed_data';

class ImageService {
  final ImagePicker _picker = ImagePicker();

  Future<String?> pickImage() async {
    if (kIsWeb) {
      return await pickImageForWeb(); // تغییر نام متد
    } else {
      return await _pickImageForMobile();
    }
  }

  // تغییر سطح دسترسی به public
  Future<String?> pickImageForWeb() async {
    try {
      // استفاده از html input element برای انتخاب تصویر
      final input = html.InputElement(type: 'file')..accept = 'image/*';
      input.click();

      await input.onChange.first;

      if (input.files?.isEmpty ?? true) {
        return null;
      }

      final file = input.files!.first;
      final reader = html.FileReader();

      reader.readAsDataUrl(file);
      await reader.onLoad.first;

      return reader.result as String?;
    } catch (e) {
      print('Error with HTML input: $e');

      // روش جایگزین با file_picker
      try {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          allowMultiple: false,
          withData: true,
        );

        if (result != null && result.files.isNotEmpty) {
          final bytes = result.files.first.bytes;
          if (bytes != null) {
            return 'data:image/png;base64,${base64Encode(bytes)}';
          }
        }
      } catch (e2) {
        print('Error with file_picker: $e2');
      }

      return null;
    }
  }

  Future<String?> _pickImageForMobile() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );
      return image?.path;
    } catch (e) {
      print('Error picking image on mobile: $e');
      return null;
    }
  }

  // متد کمکی برای تبدیل bytes به base64
  static String base64Encode(List<int> bytes) {
    return base64.encode(bytes);
  }
}
