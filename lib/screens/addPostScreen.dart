import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/model/userModel.dart';
import 'package:instagram/providers/userProvider.dart';
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
  TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel _usermodel = Provider.of<UserProvider>(context).getUser;

    _selectImage(BuildContext context) {
      return showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: Text(
                "Create a Post",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 22,
                ),
              ),
              children: [
                SimpleDialogOption(
                  padding: const EdgeInsets.all(20),
                  child: Text("Take a Photo"),
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
                  child: Text("Choose from Gallery"),
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
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }

    return _file == null
        ? Center(
            child: IconButton(
              icon: const Icon(Icons.upload),
              onPressed: () => _selectImage(context),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: Icon(
                  Icons.west_rounded,
                  size: 30,
                ),
                onPressed: () {},
              ),
              title: const Text(
                "New Post",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(_usermodel.photoUrl),
                    ),
                    Container(
                      // color: blueColor,
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
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
          );
  }
}
