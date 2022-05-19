import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/model/userModel.dart';
import 'package:instagram/resources/storageMethods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<UserModel> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snapshot = await _firestore.collection('users').doc(currentUser.uid).get();
    return UserModel.fromSnap(snapshot);
  }

  Future<String> signUp(
      {required String username,
      required String password,
      required String email,
      required String bio,
      required Uint8List file}) async {
    String res = "unable to sign up";
    try {
      if (username.isNotEmpty ||
          password.isNotEmpty ||
          email.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        //register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String photoUrl = await StorageMethods().uploadImageToStorage(
            childName: "profilePics", file: file, isPost: false);
        print(photoUrl);

        UserModel _userModel = UserModel(
            username: username,
            email: email,
            // password: password,
            bio: bio,
            followers: [],
            following: [],
            photoUrl: photoUrl,
            uid : cred.user!.uid,
            );

        //adduser to database
        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(_userModel.toJson());
        res = "Success";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = "email badly formated";
      } else if (err.code == 'weak-password') {
        res = 'weak password';
      }
    } catch (e) {
      // TODO
      res = e.toString();
    }
    return res;
  }

  Future<String> login(
      {required String email, required String password}) async {
    String res = "Unable to login";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == "user-not-found") {
        res = "Invalid Email";
      }
      if (err.code == "wrong-password") {
        res = "Wrong Password";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
