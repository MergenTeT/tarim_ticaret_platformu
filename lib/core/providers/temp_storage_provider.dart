import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../services/temp_storage_service.dart';
 
final tempStorageProvider = Provider<TempStorageService>((ref) {
  return TempStorageService();
}); 