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

      // Create user document with empty role
      final user = app.User(
        id: userCredential.user!.uid,
        email: email,
        name: name,
        primaryRole: UserRole.buyer, // Default role, will be updated in role selection
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

      // Update Firestore document
      await firestore.collection('users').doc(currentUser.uid).update({
        'primaryRole': selectedRole.toString().split('.').last,
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
    await auth.signOut();
    state = AsyncValue.data(app.User.empty());
  }
} 