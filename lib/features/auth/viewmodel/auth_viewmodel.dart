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
  }) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        state = AsyncValue.data(app.User.empty());
        return;
      }

      final doc = await firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) {
        state = AsyncValue.data(app.User.empty());
        return;
      }

      state = AsyncValue.data(app.User.fromJson(doc.data()!));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

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
      final doc = await firestore.collection('users').doc(userCredential.user!.uid).get();
      if (!doc.exists) {
        throw Exception('User data not found');
      }

      final user = app.User.fromJson(doc.data()!);
      
      // Update last seen
      await firestore.collection('users').doc(user.id).update({
        'isOnline': true,
        'lastSeen': Timestamp.now(),
      });

      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> updateRole(UserRole role) async {
    try {
      final currentState = state;
      if (currentState is! AsyncData<app.User>) return;
      
      final user = currentState.value;
      if (user.id.isEmpty) return;

      await firestore.collection('users').doc(user.id).update({
        'primaryRole': role.name,
        'updatedAt': Timestamp.now(),
      });

      state = AsyncValue.data(user.copyWith(primaryRole: role));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      final currentState = state;
      if (currentState is! AsyncData<app.User>) return;
      
      final user = currentState.value;
      if (user.id.isNotEmpty) {
        await firestore.collection('users').doc(user.id).update({
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