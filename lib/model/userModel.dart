import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String username;
  final String email;
  // final String password;
  final String bio;
  final List followers;
  final List following;
  final String photoUrl;

  UserModel(
      {required this.username,
      required this.email,
      // this.password,
      required this.bio,
      required this.followers,
      required this.following,
      required this.photoUrl});

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        // "password" : password,
        "bio": bio,
        "followers": followers,
        "following": following,
        "photoUrl": photoUrl,
      };

  static UserModel fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return UserModel(
        username: snap["username"],
        email: snap["email"],
        bio: snap['bio'],
        followers: snap["followers"],
        following: snap["following"],
        photoUrl: snap["photoUrl"]);
  }
}
