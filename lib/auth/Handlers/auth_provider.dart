import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobseeking/auth/pages/login.dart';
import 'package:jobseeking/auth/models/user.dart';

class AuthsProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  bool get isSignedIn => currentUser != null;

  // Login user
  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'An error occurred';
    }
  }

  // Signup user
  Future<void> signup(
      String email, String password, String username, String imageUrl) async {
    try {
      // 1. Register with Firebase Authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      Users user = Users(
          userId: userCredential.user!.uid,
          username: username,
          email: email,
          imageUrl: imageUrl);

      await storeUser(user);

      notifyListeners();
    } on FirebaseAuthException catch (e) {
      print('Error during registration: $e');
      if (e.code == 'email-already-in-use') {
        // Handle case when the email is already in use
      }
    }
  }

  Future<void> storeUser(Users user) async {
    await _firestore.collection('users').doc(user.userId).set({
      'userId': user.userId,
      'username': user.username,
      'email': user.username,
      'profilePicture': user.imageUrl
    });
  }

  // Sign out user
  Future<void> signout(context) async {
    await _auth.signOut();
    notifyListeners();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
  }
}
