import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/user.dart' as app;
import '../../../core/enums/user_role.dart';

final authViewModelProvider = StateNotifierProvider<AuthViewModel, AsyncValue<app.User>>((ref) {
  return AuthViewModel(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  );
});

class AuthViewModel extends StateNotifier<AsyncValue<app.User>> {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthViewModel({
    required this.auth,
    required this.firestore,
  }) : super(AsyncValue.data(app.User.empty()));

  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      state = const AsyncValue.loading();
      
      // Create auth user
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final now = Timestamp.now();

      // Create user document with empty role
      final user = app.User(
        id: userCredential.user!.uid,
        email: email,
        name: name,
        primaryRole: UserRole.buyer, // Default role, will be updated in role selection
        createdAt: now.toDate(),
        updatedAt: now.toDate(),
        isOnline: true,
        lastSeen: now.toDate(),
      );

      // Save to Firestore
      await firestore.collection('users').doc(user.id).set(user.toJson());
      
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> updateUserRole(UserRole selectedRole) async {
    try {
      state = const AsyncValue.loading();
      
      final currentUser = auth.currentUser;
      if (currentUser == null) throw Exception('No authenticated user found');

      final now = Timestamp.now();

      // Update Firestore document
      await firestore.collection('users').doc(currentUser.uid).update({
        'primaryRole': selectedRole.toString().split('.').last,
        'updatedAt': now,
      });

      // Update local state
      final userData = await firestore.collection('users').doc(currentUser.uid).get();
      if (userData.exists) {
        final updatedUser = app.User.fromJson(userData.data()!);
        state = AsyncValue.data(updatedUser);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> updateUserProfile({
    String? name,
    String? phoneNumber,
    String? city,
    String? deviceToken,
    bool? notificationsEnabled,
  }) async {
    try {
      state = const AsyncValue.loading();
      
      final currentUser = auth.currentUser;
      if (currentUser == null) throw Exception('No authenticated user found');

      final updates = <String, dynamic>{
        'updatedAt': Timestamp.now(),
      };

      if (name != null) updates['name'] = name;
      if (phoneNumber != null) updates['phoneNumber'] = phoneNumber;
      if (city != null) updates['city'] = city;
      if (deviceToken != null) updates['deviceToken'] = deviceToken;
      if (notificationsEnabled != null) updates['notificationsEnabled'] = notificationsEnabled;

      // Update Firestore document
      await firestore.collection('users').doc(currentUser.uid).update(updates);

      // Update local state
      final userData = await firestore.collection('users').doc(currentUser.uid).get();
      if (userData.exists) {
        final updatedUser = app.User.fromJson(userData.data()!);
        state = AsyncValue.data(updatedUser);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      state = const AsyncValue.loading();
      
      // Sign in user
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update online status and last seen
      await firestore.collection('users').doc(userCredential.user!.uid).update({
        'isOnline': true,
        'lastSeen': Timestamp.now(),
      });

      // Get user data from Firestore
      final userData = await firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (userData.exists) {
        final user = app.User.fromJson(userData.data()!);
        state = AsyncValue.data(user);
      } else {
        throw Exception('User data not found');
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      final currentUser = auth.currentUser;
      if (currentUser != null) {
        // Update online status and last seen before logging out
        await firestore.collection('users').doc(currentUser.uid).update({
          'isOnline': false,
          'lastSeen': Timestamp.now(),
        });
      }
      
      await auth.signOut();
      state = AsyncValue.data(app.User.empty());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
} 