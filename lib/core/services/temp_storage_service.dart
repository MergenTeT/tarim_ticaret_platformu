import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

class TempStorageService {
  /// Görseli base64'e çevirir
  Future<String> encodeImageToBase64(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      debugPrint('Error encoding image: $e');
      rethrow;
    }
  }

  /// Base64 stringini görsele çevirir
  Future<Uint8List> decodeBase64ToImage(String base64String) async {
    try {
      return Uint8List.fromList(base64Decode(base64String));
    } catch (e) {
      debugPrint('Error decoding image: $e');
      rethrow;
    }
  }

  /// Birden fazla görseli base64'e çevirir
  Future<List<String>> encodeMultipleImages(List<File> imageFiles) async {
    try {
      final List<String> base64Images = [];
      for (final file in imageFiles) {
        final base64String = await encodeImageToBase64(file);
        base64Images.add(base64String);
      }
      return base64Images;
    } catch (e) {
      debugPrint('Error encoding multiple images: $e');
      rethrow;
    }
  }
} 