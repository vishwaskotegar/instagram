import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/widgets/postCard.dart';

import '../utils/globalVariables.dart';

class DisplayPost extends StatelessWidget {
  final snap;
  const DisplayPost({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      color: webBackgroundColor,
      child: Container(
        // width: double.infinity,
        margin: EdgeInsets.symmetric(
            horizontal: width > webScreenSize ? width / 4 : 0),
        child: Scaffold(
          backgroundColor: webBackgroundColor,
          appBar: AppBar(
            backgroundColor: mobileBackgroundColor,
            title: const Text("Explore"),
          ),
          body: PostCard(snap: snap),
        ),
      ),
    );
  }
}
