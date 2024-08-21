import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:instagram_clonee/model/user.dart' as model;
import 'package:instagram_clonee/resouces/storage_methods.dart';

class AuthMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap = await _firestore.collection('users')
    .doc(currentUser.uid)
    .get();

    return model.User.fromSnap(snap);
  }

  ///sing up user
  Future<String> SingUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error occur";
    try {
      if (email.isNotEmpty || password.isNotEmpty || username.isNotEmpty ||
          password.isNotEmpty || file != null) {
        ///register the user
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password
        );
        print(credential.user!.uid);

        String photoUrl = await StorageMethods().uploadImageToStorage(
            'profilePics', file, false);

        model.User user = model.User(
            email: email,
            uid: credential.user!.uid,
            photoUrl: photoUrl,
            username: username,
            bio: bio,
            followers: [],
            following: []
        );

        /// add user to our database
        await _firestore.collection('users').doc(credential.user!.uid).set(user.toJson());

        res = 'success';
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'the email is badly formatted';
      } else if (err.code == 'weak-password') {
        res = 'your password should be at last 6 characters';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> signInUser({
    required String email,
    required String password,
  }) async {
    String res = 'Some error occurred';

    try {
      // Check for non-empty fields
      if (email.isNotEmpty || password.isNotEmpty) {
        // Sign in with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = 'Please enter all the fields';
      }
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase auth exceptions
      switch (e.code) {
        case 'user-not-found':
          res = 'User not found';
          break;
        case 'wrong-password':
          res = 'The password is incorrect';
          break;
        case 'invalid-email':
          res = 'The email address is not valid';
          break;
        case 'user-disabled':
          res = 'The user account has been disabled';
          break;
        case 'too-many-requests':
          res = 'Too many requests, try again later';
          break;
        default:
          res = 'Authentication error: ${e.message}';
      }
    } catch (e) {
      // Catch any other exceptions
      res = 'An unexpected error occurred: $e';
    }

    return res;
  }

  Future<void> signOut()async{
    await _auth.signOut();
  }
}