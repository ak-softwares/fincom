import 'dart:convert';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import '../../../features/accounts/models/image_model.dart';
import '../../../utils/constants/api_constants.dart';

class ImageKitService {

  static String imageKitUploadUrl = APIConstant.imageKitUploadUrl;
  static String imageKitDeleteUrl = APIConstant.imageKitDeleteUrl;
  static String batchImageKitDeleteUrl = APIConstant.batchImageKitDeleteUrl;
  static String privateKey = APIConstant.imageKitPrivateKey;

  // Function to pick an image
  Future<File?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  // Function to compress an image
  Future<File?> compressImage(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath = '${dir.path}/${basename(file.path)}_compressed.jpg';

    var compressedFile = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 30, // Adjust quality (0-100)
    );

    return compressedFile != null ? File(compressedFile.path) : null;
  }

  // Function to upload image
  Future<ImageModel> uploadImage(File imageFile) async {
    try {
      // Compress the image
      File? compressedImage = await compressImage(imageFile);
      if (compressedImage == null) throw "Image compression failed";

      var request = http.MultipartRequest('POST', Uri.parse(imageKitUploadUrl));

      // Attach API Key (Basic Auth)
      String basicAuth = 'Basic ${base64Encode(utf8.encode('$privateKey:'))}';
      request.headers['Authorization'] = basicAuth;

      // Attach file
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        compressedImage.path,
      ));

      // Add required `fileName` field
      request.fields['fileName'] = basename(compressedImage.path);

      // Execute request
      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseData);

      if (response.statusCode == 200) {
        return ImageModel.fromJson(jsonResponse); // Return ImageModel instead of just URL
      } else {
        throw "Upload failed: ${jsonResponse['message']}";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteImage(String fileId) async {
    try {
      var request = http.Request('DELETE', Uri.parse('$imageKitDeleteUrl/$fileId'));

      // Attach API Key (Basic Auth)
      String basicAuth = 'Basic ${base64Encode(utf8.encode('$privateKey:'))}';
      request.headers['Authorization'] = basicAuth;

      // Execute request
      var response = await request.send();

      if (response.statusCode == 204) {
      } else {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseData);
        throw "Delete failed: ${jsonResponse['message']}";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteImages(List<String> fileIds) async {
    try {
      var request = http.Request('POST', Uri.parse(batchImageKitDeleteUrl));

      // Attach API Key (Basic Auth)
      String basicAuth = 'Basic ${base64Encode(utf8.encode('$privateKey:'))}';
      request.headers['Authorization'] = basicAuth;
      request.headers['Content-Type'] = 'application/json';

      // Body with list of fileIds
      request.body = jsonEncode({'fileIds': fileIds});

      // Execute request
      var response = await request.send();

      if (response.statusCode == 200) {
        // Success
      } else {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseData);
        throw "Bulk delete failed: ${jsonResponse['message']}";
      }
    } catch (e) {
      rethrow;
    }
  }

}
