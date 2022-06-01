import 'dart:typed_data';

import 'package:advance_notification/advance_notification.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/model/userModel.dart';
import 'package:instagram/providers/userProvider.dart';
import 'package:instagram/resources/firestoreMethods.dart';
import 'package:instagram/responsive/mobileScreenLayout.dart';
import 'package:instagram/responsive/responsive_layout_screen.dart';
import 'package:instagram/responsive/webScreenLayout.dart';
import 'package:instagram/screens/loginScreen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';
import 'package:instagram/widgets/textFieldInput.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  bool _isloading = false;
  final TextEditingController _descriptionController = TextEditingController();

  void postImage(String uid, String username, String profImage) async {
    try {
      setState(() {
        _isloading = true;
      });
      String res = await FirestoreMethods().uploadPost(
          _file!, _descriptionController.text, uid, username, profImage);

      setState(() {
        _isloading = false;
      });
      if (res == "Success") {
        const AdvanceSnackBar(
                message: "Posted!", isFixed: false, bgColor: blueColor)
            .show(context);
        clearImage();
      } else {
        AdvanceSnackBar(message: res, isFixed: false, bgColor: blueColor)
            .show(context);
      }
    } catch (e) {
      AdvanceSnackBar(
              message: e.toString(), bgColor: Colors.red, isFixed: false)
          .show(context);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _descriptionController.dispose();
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserModel _usermodel = Provider.of<UserProvider>(context).getUser;

    _selectImage(BuildContext context) {
      return showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: const Text(
                "Create a Post",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 22,
                ),
              ),
              children: [
                SimpleDialogOption(
                  padding: const EdgeInsets.all(20),
                  child: const Text("Take a Photo"),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Uint8List file = await pickImage(ImageSource.camera);
                    setState(() {
                      _file = file;
                    });
                  },
                ),
                SimpleDialogOption(
                  padding: const EdgeInsets.all(20),
                  child: const Text("Choose from Gallery"),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Uint8List file = await pickImage(ImageSource.gallery);
                    setState(() {
                      _file = file;
                    });
                  },
                ),
                SimpleDialogOption(
                  padding: const EdgeInsets.all(20),
                  child: const Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }

    return _file == null
        ? WillPopScope(
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
                  title: const Text("New Post")),
              body: Center(
                child: InkWell(
                  onTap: () => _selectImage(context),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.cloud_upload),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Upload Photo",
                        style: TextStyle(color: blueColor, fontSize: 24),
                      )
                    ],
                  ),
                ),
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
                backgroundColor: mobileBackgroundColor,
                leading: IconButton(
                  icon: const Icon(
                    Icons.west_rounded,
                    size: 30,
                  ),
                  onPressed: clearImage,
                ),
                title: const Text(
                  "New Post",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                actions: [
                  IconButton(
                    onPressed: () => postImage(_usermodel.uid,
                        _usermodel.username, _usermodel.profImage),
                    icon: const Icon(
                      Icons.done,
                      color: blueColor,
                      size: 30,
                    ),
                    // child: const Text(
                    //   "Post",
                    //   style: TextStyle(
                    //       color: blueColor, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              body: Column(
                children: [
                  _isloading
                      ? const LinearProgressIndicator(
                          minHeight: 2,
                        )
                      : Container(),
                  const Divider(
                    thickness: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            Provider.of<UserProvider>(context).getProfilePic,
                      ),
                      Container(
                        // color: blueColor,
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: TextField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            hintText: "Write a caption...",
                            border: InputBorder.none,
                          ),
                          maxLines: 8,
                        ),
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        child: Image(
                          image: MemoryImage(_file!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                ],
              ),
            ),
          );
  }
}
