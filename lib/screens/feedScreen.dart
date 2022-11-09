import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/globalVariables.dart';
import 'package:instagram/widgets/postCard.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor:
          width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
      appBar: width > webScreenSize
          ? null
          : AppBar(
              backgroundColor: mobileBackgroundColor,
              title: SvgPicture.asset(
                "assets/images/MemeBucket.svg",
                color: primaryColor,
                height: 32,
              ),
              actions: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.send))
              ],
            ),
      body: StreamBuilder(
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(
                      vertical: width > webScreenSize ? 15 : 0,
                      horizontal: width > webScreenSize ? width / 3 : 0),
                  child: PostCard(
                    snap: snapshot.data!.docs[index].data(),
                  ),
                );
              });
        },
        stream: FirebaseFirestore.instance
            .collection("posts")
            .orderBy('datePublished', descending: true)
            .snapshots(),
      ),
    );
  }
}
