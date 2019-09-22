import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseServices {
  Future<String> uploadImage(File image, String folder, String name) async {
    if (image == null || folder == null || name == null) {
      return Future.value(null);
    }
    StorageReference storageRef =
        FirebaseStorage.instance.ref().child(folder).child(name);
    StorageUploadTask uploadTask = storageRef.putFile(image);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    if (uploadTask.isSuccessful) {
      var originUrl = await storageTaskSnapshot.ref.getDownloadURL();
      return originUrl.toString().split('&token')[0];
    } else {
      return Future.value(null);
    }
  }
}
