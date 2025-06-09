import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/base/base_view_model.dart';
import '../model/user_model.dart';

class AuthViewModel extends BaseViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserModel? _user;
  String? _errorMessage;

  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;

  @override
  void init() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _user = UserModel.fromFirebase(user);
      } else {
        _user = null;
      }
      notifyListeners();
    });
  }

  String _getLocalizedErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Bu email adresi ile kayıtlı kullanıcı bulunamadı';
      case 'wrong-password':
        return 'Hatalı şifre';
      case 'invalid-email':
        return 'Geçersiz email adresi';
      case 'user-disabled':
        return 'Bu kullanıcı hesabı devre dışı bırakılmış';
      case 'email-already-in-use':
        return 'Bu email adresi zaten kullanımda';
      case 'operation-not-allowed':
        return 'Email/şifre girişi devre dışı bırakılmış';
      case 'weak-password':
        return 'Şifre çok zayıf';
      case 'too-many-requests':
        return 'Çok fazla başarısız giriş denemesi. Lütfen daha sonra tekrar deneyin';
      case 'network-request-failed':
        return 'İnternet bağlantınızı kontrol edin';
      default:
        return e.message ?? 'Bir hata oluştu';
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      setLoading(true);
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _errorMessage = null;
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getLocalizedErrorMessage(e);
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> signUp(String email, String password) async {
    try {
      setLoading(true);
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _errorMessage = null;
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getLocalizedErrorMessage(e);
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<void> signOut() async {
    try {
      setLoading(true);
      await _auth.signOut();
      _errorMessage = null;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getLocalizedErrorMessage(e);
    } finally {
      setLoading(false);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
} 