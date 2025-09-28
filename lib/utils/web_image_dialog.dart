// lib/utils/web_image_dialog.dart
import 'package:flutter/material.dart';
import 'package:azmonrahnamayi/services/image_service.dart';

class WebImageDialog {
  static Future<String?> show(BuildContext context) async {
    final imageService = ImageService();

    return showDialog<String?>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // عنوان دیالوگ
              Row(
                children: [
                  Icon(
                    Icons.photo_camera,
                    color: Theme.of(context).primaryColor,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'انتخاب تصویر پروفایل',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // گزینه‌های انتخاب تصویر
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // گالری
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.photo_library,
                          color: Colors.blue,
                        ),
                      ),
                      title: const Text(
                        'انتخاب از گالری',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: const Text('انتخاب تصویر از گالری دستگاه'),
                      onTap: () async {
                        Navigator.pop(context);
                        final imagePath = await imageService.pickImage();
                        if (context.mounted) {
                          Navigator.pop(context, imagePath);
                        }
                      },
                    ),

                    // جداکننده
                    const Divider(height: 1),

                    // دوربین
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.green,
                        ),
                      ),
                      title: const Text(
                        'دوربین',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: const Text('گرفتن عکس جدید با دوربین'),
                      onTap: () async {
                        Navigator.pop(context);
                        final imagePath = await imageService
                            .pickImageFromCamera();
                        if (context.mounted) {
                          Navigator.pop(context, imagePath);
                        }
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // گزینه حذف تصویر
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.delete, color: Colors.red),
                  ),
                  title: const Text(
                    'حذف تصویر فعلی',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context, 'delete');
                  },
                ),
              ),

              const SizedBox(height: 16),

              // دکمه انصراف
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: Colors.grey[400]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('انصراف', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
