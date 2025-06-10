import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  static Database? _database;

  factory LocalStorageService() {
    return _instance;
  }

  LocalStorageService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'tarim_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Ürün tablosu
    await db.execute('''
      CREATE TABLE products (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        price REAL NOT NULL,
        unit TEXT NOT NULL,
        quantity REAL NOT NULL,
        category TEXT NOT NULL,
        seller_id TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        images TEXT
      )
    ''');

    // Görsel tablosu
    await db.execute('''
      CREATE TABLE images (
        id TEXT PRIMARY KEY,
        product_id TEXT NOT NULL,
        path TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE
      )
    ''');
  }

  // Görsel kaydetme
  Future<String> saveImage(File imageFile) async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
      final String localPath = path.join(appDir.path, 'images', fileName);
      
      // images klasörünü oluştur
      final Directory imageDir = Directory(path.join(appDir.path, 'images'));
      if (!await imageDir.exists()) {
        await imageDir.create(recursive: true);
      }
      
      // Görseli kopyala
      final File localImage = await imageFile.copy(localPath);
      return localImage.path;
    } catch (e) {
      throw Exception('Görsel kaydedilemedi: $e');
    }
  }

  // Birden fazla görseli kaydet
  Future<List<String>> saveMultipleImages(List<File> imageFiles) async {
    try {
      List<String> localPaths = [];
      for (File imageFile in imageFiles) {
        String localPath = await saveImage(imageFile);
        localPaths.add(localPath);
      }
      return localPaths;
    } catch (e) {
      throw Exception('Görseller kaydedilemedi: $e');
    }
  }

  // Görsel silme
  Future<void> deleteImage(String imagePath) async {
    try {
      final File file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      throw Exception('Görsel silinemedi: $e');
    }
  }

  // Tüm görselleri getir
  Future<List<String>> getAllImages() async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final Directory imageDir = Directory(path.join(appDir.path, 'images'));
      
      if (!await imageDir.exists()) {
        return [];
      }
      
      final List<FileSystemEntity> entities = await imageDir.list().toList();
      return entities
          .whereType<File>()
          .map((file) => file.path)
          .toList();
    } catch (e) {
      throw Exception('Görseller getirilemedi: $e');
    }
  }

  // Ürün görselleri getirme
  Future<List<String>> getProductImages(String productId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'images',
      where: 'product_id = ?',
      whereArgs: [productId],
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) => maps[i]['path'] as String);
  }

  // Ürünle ilgili tüm görselleri silme
  Future<void> deleteProductImages(String productId) async {
    final images = await getProductImages(productId);
    for (var imagePath in images) {
      await deleteImage(imagePath);
    }
  }
} 