import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/widgets/notificationCard.dart';

import '../responsive/mobileScreenLayout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/webScreenLayout.dart';
import '../utils/globalVariables.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
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
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: width > webScreenSize ? width / 4 : 0),
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: const Text(
                "Activity",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          body: StreamBuilder(
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return NotificationCard(
                      snap: snapshot.data!.docs[index].data(),
                    );
                  });
            },
            stream: FirebaseFirestore.instance
                .collection("posts")
                .orderBy('datePublished', descending: true)
                .snapshots(),
          ),
        ),
      ),
    );
  }
}
