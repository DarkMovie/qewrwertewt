// lib/services/image_service.dart
import 'package:image_picker/image_picker.dart';

class ImageService {
  final ImagePicker _picker = ImagePicker();

  /// انتخاب تصویر از گالری
  Future<String?> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70, // کاهش حجم تصویر
      );
      return image?.path; // مسیر فایل در موبایل
    } catch (e) {
      print('Error picking image on mobile: $e');
      return null;
    }
  }

  /// انتخاب تصویر با دوربین (اختیاری)
  Future<String?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
      );
      return image?.path;
    } catch (e) {
      print('Error picking image from camera: $e');
      return null;
    }
  }
}
