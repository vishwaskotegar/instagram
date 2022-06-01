import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/widgets/postCard.dart';

class DisplayPost extends StatelessWidget {
  final snap;
  const DisplayPost({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text("Explore"),
      ),
      body: PostCard(snap: snap),
    );
  }
}
