import 'dart:io';

import 'package:myfootball/data/providers/firebase-provider.dart';

class FirebaseRepository {
  FirebaseProvider _firebaseProvider = FirebaseProvider();

  Future<String> uploadImage(File image, String folder, String name) async {
    return _firebaseProvider.uploadImage(image, folder, name);
  }
}
