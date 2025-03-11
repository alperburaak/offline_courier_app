import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  User? get user => _user; // Mevcut kullanıcıyı döndür

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners(); // Kullanıcı değiştiğinde UI güncellensin
    });
  }

  // Kullanıcı giriş yapma
  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw Exception("Giriş yapılamadı: $e");
    }
  }

  // Kullanıcı kaydolma
  Future<void> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception("Kayıt olma hatası: $e");
    }
  }

  // Çıkış yapma
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
