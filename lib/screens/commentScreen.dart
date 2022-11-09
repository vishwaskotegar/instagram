import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:instagram/resources/firestoreMethods.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/widgets/commentCard.dart';
import 'package:provider/provider.dart';

import '../model/userModel.dart';
import '../providers/userProvider.dart';
import '../responsive/mobileScreenLayout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/webScreenLayout.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  const CommentScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel _user = Provider.of<UserProvider>(context).getUser;
    return WillPopScope(
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
        // backgroundColor: mobileBackgroundColor,
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: const Text("Comments"),
          centerTitle: false,
        ),
        body: StreamBuilder(
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                itemCount: (snapshot.data! as dynamic).docs.length,
                itemBuilder: (context, index) =>
                    CommentCard(snap: snapshot.data!.docs[index].data()),
              );
            }
          },
          stream: FirebaseFirestore.instance
              .collection("posts")
              .doc(widget.snap['postId'])
              .collection('comments')
              .orderBy('datePublished', descending: true)
              .snapshots(),
        ),
        bottomNavigationBar: Container(
          height: kToolbarHeight,
          // color: Colors.pink,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(_user.profImage),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 8),
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: "Comment as ${_user.username}",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await FirestoreMethods().postComment(
                      widget.snap["postId"],
                      _user.username,
                      _user.uid,
                      _commentController.text,
                      _user.profImage);

                  setState(() {
                    _commentController.text = "";
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Text(
                    "Post",
                    style: TextStyle(color: blueColor),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
