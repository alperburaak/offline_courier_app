import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> registerUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print("Kayıt hatası: $e");
      return null;
    }
  }

  // Kullanıcı Girişi
  Future<User?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Giriş hatası: $e");
      return null;
    }
  }

  // Kullanıcı Çıkışı
  Future<void> logoutUser() async {
    await _auth.signOut();
  }

  // Mevcut Kullanıcıyı Getirme
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
