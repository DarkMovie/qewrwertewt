// lib/utils/web_image_dialog.dart
import 'package:flutter/material.dart';
import 'package:azmonrahnamayi/services/image_service.dart';

class WebImageDialog {
  static Future<String?> show(BuildContext context) async {
    final imageService = ImageService();

    return showDialog<String?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('انتخاب تصویر پروفایل'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'در نسخه وب، لطفاً یکی از گزینه‌های زیر را انتخاب کنید:',
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('انتخاب از گالری'),
              onTap: () async {
                final imagePath = await imageService
                    .pickImageForWeb(); // استفاده از متد public
                if (context.mounted) {
                  Navigator.pop(context, imagePath);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('دوربین'),
              onTap: () async {
                // در وب، دوربین معمولاً در دسترس نیست، پس همان گالری را نشان می‌دهیم
                final imagePath = await imageService
                    .pickImageForWeb(); // استفاده از متد public
                if (context.mounted) {
                  Navigator.pop(context, imagePath);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('استفاده از تصویر پیش‌فرض'),
              onTap: () {
                Navigator.pop(context, 'assets/images/default_avatar.png');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('انصراف'),
          ),
        ],
      ),
    );
  }
}
