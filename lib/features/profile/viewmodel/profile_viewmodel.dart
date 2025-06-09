import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/profile_model.dart';

final profileViewModelProvider = StateNotifierProvider<ProfileViewModel, AsyncValue<ProfileModel?>>((ref) {
  return ProfileViewModel();
});

class ProfileViewModel extends StateNotifier<AsyncValue<ProfileModel?>> {
  ProfileViewModel() : super(const AsyncValue.loading()) {
    _init();
  }

  final _auth = FirebaseAuth.instance;

  Future<void> _init() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        state = const AsyncValue.data(null);
        return;
      }

      final profile = ProfileModel(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName,
        photoURL: user.photoURL,
        phoneNumber: user.phoneNumber,
        emailVerified: user.emailVerified,
        createdAt: user.metadata.creationTime,
        lastSignInTime: user.metadata.lastSignInTime,
      );

      state = AsyncValue.data(profile);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateProfile({
    String? displayName,
    String? photoURL,
    String? phoneNumber,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await user.updateDisplayName(displayName);
      await user.updatePhotoURL(photoURL);

      await _init(); // Refresh profile data
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> verifyEmail() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await user.sendEmailVerification();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
} 