import 'package:flutter/material.dart';
import 'package:instagram/screens/profileScreen.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationCard extends StatelessWidget {
  final snap;
  const NotificationCard({Key? key, this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(snap['profImage']),
        ),
        title: Wrap(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProfileScreen(uid: snap['uid']),
              )),
              child: Text(snap["username"],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis),
            ),
            const Text(' Created a new Post. ',
                style: TextStyle(fontWeight: FontWeight.normal),
                overflow: TextOverflow.ellipsis),
            Text(
              " ${timeago.format(snap['datePublished'].toDate())}",
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        ));
  }
}
