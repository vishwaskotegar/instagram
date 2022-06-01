import 'package:advance_notification/advance_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/model/userModel.dart';
import 'package:instagram/providers/userProvider.dart';
import 'package:instagram/resources/firestoreMethods.dart';
import 'package:instagram/screens/commentScreen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/widgets/likeAnimation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentSize = 0;
  Stream? snap;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCommentsSize();
  }

  void getCommentsSize()  {
    try {
      snap = FirebaseFirestore.instance
          .collection("posts")
          .doc(widget.snap['postId'])
          .collection('comments')
          .snapshots();
      snap!.listen((event) {
        setState(() {
          commentSize = event.docs.length;
        });
      },
       onError: (err) {
        setState(() {
          commentSize = 0;
        });
      }
      );
    } catch (e) {
      // print(e.toString());
      const AdvanceSnackBar(message: "unable to get Comment size",bgColor: Colors.red).show(context);
    }
    // setState(() {
    //   commentSize = snap!.docs.length;
    // });
  }

  @override
  Widget build(BuildContext context) {
    final UserModel _user = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          //HEADER SECTION
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10)
                .copyWith(right: 0),
            // color: blueColor,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.snap["profImage"]),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.snap["username"],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),

                _user.uid == widget.snap["uid"]?
                IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                            shrinkWrap: true,
                            children: ["Delete"]
                                .map(
                                  (e) => InkWell(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 16),
                                      child: Text(e),
                                    ),
                                    onTap: () async {
                                      await FirestoreMethods()
                                          .deletePost(widget.snap['postId']);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.more_vert)): const SizedBox(),
              ],
            ),
          ),
          //IMAGE SECTION
          GestureDetector(
            onDoubleTap: () async {
              FirestoreMethods().likePost(
                  widget.snap["postId"], _user.uid, widget.snap["likes"]);
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap["photoUrl"],
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    child: const Icon(Icons.favorite,
                        color: Colors.white, size: 120),
                    isAnimating: isLikeAnimating,
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                  ),
                )
              ],
            ),
          ),

          //LIKE, COMMENT AND SHARE SECTION
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(_user.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () async {
                    await FirestoreMethods().likePost(
                      widget.snap["postId"],
                      _user.uid,
                      widget.snap["likes"],
                    );
                  },
                  icon: widget.snap['likes'].contains(_user.uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_border,
                          // color: Colors.red,
                        ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CommentScreen(snap: widget.snap),
                  ),
                ),
                icon: const Icon(
                  Icons.comment,
                  // color: Colors.red,
                ),
              ),
              new RotationTransition(
                turns: new AlwaysStoppedAnimation(-30 / 360),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.send_rounded,
                      // color: Colors.red,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      onPressed: () {}, icon: Icon(Icons.bookmark_border)),
                ),
              )
            ],
          ),
          //DESCRIPTION AND NUMBER OF COMMENTS
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.snap["likes"].length} likes",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: primaryColor,
                      ),
                      children: [
                        TextSpan(
                          text: widget.snap["username"],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: ' ${widget.snap["description"]}',
                          style: TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CommentScreen(snap: widget.snap),
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      "View all $commentSize comments",
                      style: TextStyle(
                        fontSize: 16,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMd().format(
                      widget.snap["datePublished"].toDate(),
                    ),
                    style: TextStyle(
                      fontSize: 10,
                      color: secondaryColor,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
