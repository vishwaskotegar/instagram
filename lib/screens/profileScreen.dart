import 'package:advance_notification/advance_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:instagram/model/userModel.dart';
import 'package:instagram/providers/userProvider.dart';
import 'package:instagram/resources/authMethods.dart';
import 'package:instagram/resources/firestoreMethods.dart';
import 'package:instagram/screens/loginScreen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/widgets/displayPost.dart';
import 'package:instagram/widgets/postCard.dart';
import 'package:instagram/widgets/profileButton.dart';
import 'package:provider/provider.dart';

import '../responsive/mobileScreenLayout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/webScreenLayout.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isloading = true;
  var userData = {};
  int postlenth = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  @override
  void initState() {
    // TODO: implement initState
    // setState(() {
    //   isloading = true;
    // });
    getData();
    super.initState();
  }

  getData() async {
    try {
      Stream? userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .snapshots();
      QuerySnapshot<Map<String, dynamic>> postSnap = await FirebaseFirestore
          .instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();

      userSnap.listen((event) {
        setState(() {
          userData = event.data()!;
          postlenth = postSnap.docs.length;
          followers = userData['followers'].length;
          following = userData['following'].length;
          isFollowing = event
              .data()!['followers']
              .contains(FirebaseAuth.instance.currentUser!.uid);
          isloading = false;
        });
      });
      // setState(() {
      //   userData = userSnap.data()!;
      //   postlenth = postSnap.docs.length;
      //   followers = userData['followers'].length;
      //   following = userData['following'].length;
      //   isFollowing = userSnap
      //       .data()!['followers']
      //       .contains(FirebaseAuth.instance.currentUser!.uid);
      //   isloading = false;
      // });
    } catch (e) {
      AdvanceSnackBar(
              message: e.toString(), isFixed: false, bgColor: Colors.red)
          .show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // UserModel userModel = Provider.of<UserProvider>(context).getUser;
    return isloading
        ? const Scaffold(
            body: SafeArea(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          )
        : WillPopScope(
            onWillPop: () async {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const ResponsiveLayout(
                      webScreenLayout: WebScreenLayout(),
                      mobileScreenLayout: MobileScreenLayout()),
                ),
              );
              return false;
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(userData["username"]),
                backgroundColor: mobileBackgroundColor,
              ),
              body: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  NetworkImage(userData['profImage']),
                              radius: 40,
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      buildStatColumn(postlenth, "Posts"),
                                      buildStatColumn(followers, "Followers"),
                                      buildStatColumn(following, "Following")
                                    ],
                                  ),
                                  Provider.of<UserProvider>(context)
                                              .getUser
                                              .uid ==
                                          widget.uid
                                      ? ProfileButton(
                                          function: () async {
                                            AuthMethods().signOut();
                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginScreen(),
                                              ),
                                            );
                                          },
                                          text: "Sign out",
                                          borderColor: primaryColor,
                                          color: mobileBackgroundColor,
                                        )
                                      : isFollowing
                                          ? ProfileButton(
                                              function: () async {
                                                FirestoreMethods().followUser(
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid,
                                                    widget.uid);
                                              },
                                              text: "Unfollow",
                                              borderColor: primaryColor,
                                              color: primaryColor,
                                            )
                                          : ProfileButton(
                                              function: () async {
                                                FirestoreMethods().followUser(
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid,
                                                    widget.uid);
                                              },
                                              text: "follow",
                                              borderColor: blueColor,
                                              color: blueColor,
                                            ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 8),
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userData['username'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                userData['bio'],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('posts')
                        .where('uid', isEqualTo: widget.uid)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container();
                      }
                      return GridView.builder(
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 1,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 1.5),
                        itemBuilder: (context, index) {
                          DocumentSnapshot postSnap =
                              (snapshot.data! as dynamic).docs[index];

                          return InkWell(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => DisplayPost(
                                        snap: (snapshot.data! as dynamic)
                                            .docs[index]
                                            .data(),
                                      )),
                            ),
                            child: Image(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                (postSnap.data()! as dynamic)["photoUrl"],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  )
                ],
              ),
            ),
          );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          num.toString(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text(label,
            style: TextStyle(
                fontWeight: FontWeight.w400, fontSize: 15, color: Colors.grey))
      ],
    );
  }
}
