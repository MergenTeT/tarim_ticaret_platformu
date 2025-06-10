import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Tek bir resim yükleme
  Future<String> uploadImage(File imageFile, String folder) async {
    try {
      // Dosya adını benzersiz yapmak için timestamp ekleyelim
      final fileName = '${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
      
      // Reference oluşturma
      final Reference ref = _storage.ref().child(folder).child(fileName);
      
      // Dosyayı yükleme
      final uploadTask = ref.putFile(imageFile);
      
      // Yükleme tamamlanana kadar bekle
      final snapshot = await uploadTask.whenComplete(() => null);
      
      // Download URL'ini al
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      throw Exception('Görsel yükleme başarısız: $e');
    }
  }

  // Çoklu resim yükleme
  Future<List<String>> uploadMultipleImages(List<File> imageFiles, String folder) async {
    try {
      List<String> downloadUrls = [];
      
      for (File imageFile in imageFiles) {
        String url = await uploadImage(imageFile, folder);
        downloadUrls.add(url);
      }
      
      return downloadUrls;
    } catch (e) {
      throw Exception('Görseller yüklenirken hata oluştu: $e');
    }
  }

  // Görsel silme
  Future<void> deleteImage(String imageUrl) async {
    try {
      final Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Görsel silme başarısız: $e');
    }
  }
} 