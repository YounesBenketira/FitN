import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_k/Logic/cloudDatabase.dart';

abstract class BaseAuth {
  Future<String> createUserWithEmailAndPassword(
      String email, String password, String first, String last);

  Future<String> signInWithEmailAndPassword(String email, String password);

  Future<String> currentUserID();

  Future<void> signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> createUserWithEmailAndPassword(
      String email, String password, String first, String last) async {
    AuthResult authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = authResult.user;

    await DatabaseService(uid: user.uid).initalizeUserData(first, last, 0);

    return user.uid;
  }

  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    AuthResult authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = authResult.user;
    return user.uid;
  }

  Future<String> currentUserID() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    if (user == null)
      return null;
    else
      return user.uid;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}
