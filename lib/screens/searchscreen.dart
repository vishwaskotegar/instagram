import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../resources/firestoreMethods.dart';
import 'profileScreen.dart';
import '../utils/colors.dart';
import '../widgets/displayPost.dart';

import '../responsive/mobileScreenLayout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/webScreenLayout.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isShowUsers = false;
  TextEditingController searchController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: TextFormField(
            controller: searchController,
            decoration: InputDecoration(
                focusedBorder: InputBorder.none,
                labelText: "Search a user",
                enabledBorder: InputBorder.none),
            onFieldSubmitted: (String _) {
              setState(() {
                isShowUsers = true;
              });
            },
          ),
        ),
        body: isShowUsers
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection("users")
                    .where(
                      'username',
                      isGreaterThanOrEqualTo: searchController.text,
                    )
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView.builder(
                    itemBuilder: (context, index) {
                      print((snapshot.data as dynamic));
                      return InkWell(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                    uid: (snapshot.data as dynamic).docs[index]
                                        ['uid']))),
                        child: (snapshot.data as dynamic).docs[index]['uid'] ==
                                FirebaseAuth.instance.currentUser!.uid
                            ? Container()
                            : ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      (snapshot.data as dynamic).docs[index]
                                          ['profImage']),
                                ),
                                title: Text((snapshot.data as dynamic)
                                    .docs[index]['username']),
                              ),
                      );
                    },
                    itemCount: (snapshot.data as dynamic).docs.length < 8
                        ? (snapshot.data as dynamic).docs.length
                        : 8,
                  );
                },
              )
            : FutureBuilder(
                future: FirebaseFirestore.instance.collection("posts").get(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return MasonryGridView.count(
                    itemCount: snapshot.data!.docs.length,
                    crossAxisCount: 2,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => DisplayPost(
                                      snap: snapshot.data!.docs[index].data(),
                                    ))),
                        child: Image.network(
                            snapshot.data!.docs[index]["photoUrl"]),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
