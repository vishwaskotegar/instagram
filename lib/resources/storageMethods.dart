import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<String> uploadImageToStorage(
      {required String childName,
      required Uint8List file,
      required bool isPost}) async {
    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);

    UploadTask _uploadtask = ref.putData(file);

    TaskSnapshot _taskSnapshot = await _uploadtask;
    String downloadUrl = await _taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
