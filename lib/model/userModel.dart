class UserModel {
  final String username;
  final String email;
  final String password;
  final String bio;
  final List followers;
  final List following;
  final String photoUrl;

  UserModel(
      {required this.username,
      required this.email,
      required this.password,
      required this.bio,
      required this.followers,
      required this.following,
      required this.photoUrl});

  Map<String, dynamic> toJson() => {
    "username" : username,
    "email" : email,
    "password" : password,
    "bio" : bio,
    "followers" : followers,
    "following" :following,
    "photoUrl" : photoUrl,
  };
}
