import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
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
          .uploadImageToStorage(childName: "Posts", file: file, isPost: true);

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
}
