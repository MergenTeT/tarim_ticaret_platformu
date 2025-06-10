import 'package:cloudinary_public/cloudinary_public.dart';
import 'dart:io';

class ImageService {
  final cloudinary = CloudinaryPublic('your_cloud_name', 'your_upload_preset');

  Future<String> uploadImage(File image) async {
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(image.path, folder: 'farmer_market'),
      );
      return response.secureUrl;
    } catch (e) {
      throw Exception('Görsel yükleme başarısız: $e');
    }
  }

  Future<List<String>> uploadMultipleImages(List<File> images) async {
    try {
      List<String> urls = [];
      for (var image in images) {
        String url = await uploadImage(image);
        urls.add(url);
      }
      return urls;
    } catch (e) {
      throw Exception('Görseller yüklenirken hata oluştu: $e');
    }
  }
} 