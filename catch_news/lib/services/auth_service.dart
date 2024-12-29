import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseAuth get auth => _auth;
  FirebaseFirestore get firestore => _firestore;


  Future<User?> signInAnonymously() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      return userCredential.user;
    } catch (e) {
      if (kDebugMode) {
        print("Error during anonymous login: $e");
      }
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } catch (e) {
      if (kDebugMode) {
        print("Error during email/password login: $e");
      }
      return null;
    }
  }

  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      rethrow;
    }
  }


  Future<void> changeEmail(String newEmail) async {
    try {
      await _auth.currentUser?.verifyBeforeUpdateEmail(newEmail);
    } catch (e) {
      rethrow;
    }
  }


  Future<void> changePassword(String newPassword) async {
    try {
      await _auth.currentUser?.updatePassword(newPassword);
    } catch (e) {
      rethrow;
    }
  }


  Future<void> saveUserCategories(List<String> categories) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
      
        DocumentReference userDoc = _firestore.collection('users').doc(user.uid);

       
        await userDoc.set(
          {
            'favoriteCategories': categories,
          },
          SetOptions(merge: true),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Kategori kaydetme hatası: $e");
      }
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
