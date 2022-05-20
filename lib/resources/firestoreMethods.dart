import 'dart:typed_data';

import 'package:advance_notification/advance_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/model/postModel.dart';
import 'package:instagram/resources/storageMethods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload post

  Future<String> uploadPost(
    Uint8List file,
    String description,
    String uid,
    String username,
    String profImage,
  ) async {
    String res = "Some error occured";
    try {
      String photoUrl = await StorageMethods()
          .uploadImageToStorage(childName: "posts", file: file, isPost: true);

      String postId = Uuid().v1();
      PostModel post = PostModel(
          likes: [],
          uid: uid,
          username: username,
          description: description,
          postId: postId,
          datePublished: DateTime.now(),
          profImage: profImage,
          photoUrl: photoUrl);

      _firestore.collection("posts").doc(postId).set(post.toJson());
      res = "Success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> postComment(String postId, String username, String uid,
      String comment, String profImage) async {
    try {
      if (comment.isNotEmpty) {
        String commentId = Uuid().v1();
        _firestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .set({
          "profImage": profImage,
          "datePublished": DateTime.now(),
          "comment": comment,
          "username": username,
          "uid": uid,
          "commentId": commentId
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection("posts").doc(postId).delete();
    } catch (e) {
      // AdvanceSnackBar(message: e.toString()).show(context);
    }
  }
}
