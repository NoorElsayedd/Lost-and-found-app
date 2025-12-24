import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CloudinaryUploadService {
  static const String cloudName = 'dhcrn1s2g';
  static const String uploadPreset = 'unsigned_flutter';
  // ⚠️ You MUST create this preset in Cloudinary dashboard

  static Future<String?> uploadImage(File imageFile) async {
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );

    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(
        await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
        ),
      );

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData =
      json.decode(await response.stream.bytesToString());
      return responseData['secure_url']; // image URL
    } else {
      return null;
    }
  }
}
