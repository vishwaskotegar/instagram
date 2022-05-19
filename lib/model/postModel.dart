import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String username;
  final String description;
  final String postId;
  final datePublished;
  final String profImage;
  final String photoUrl;
  final String uid;
  final likes;

  PostModel(
      {required this.likes,
      required this.uid,
      required this.username,
      required this.description,
      // this.password,
      required this.postId,
      required this.datePublished,
      required this.profImage,
      required this.photoUrl});

  Map<String, dynamic> toJson() => {
        "username": username,
        "description": description,
        // "password" : password,
        "postId": postId,
        "datPublished": datePublished,
        "profImage": profImage,
        "photoUrl": photoUrl,
        "likes": likes,
        "uid": uid
      };

  static PostModel fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return PostModel(
        username: snap["username"],
        description: snap["email"],
        postId: snap['bio'],
        datePublished: snap["followers"],
        profImage: snap["following"],
        photoUrl: snap["photoUrl"],
        likes: snap["likes"],
        uid: snap['uid']);
  }
}
