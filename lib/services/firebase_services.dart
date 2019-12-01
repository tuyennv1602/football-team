import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices {
  static final FirebaseServices _instance = FirebaseServices.internal();

  factory FirebaseServices() => _instance;

  FirebaseServices.internal();

  static FirebaseServices get instance {
    if (_instance == null) {
      return FirebaseServices();
    }
    return _instance;
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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

  Future<String> signInWithPhoneNumber(
      String verificationId, String otp) async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: otp,
    );
    final FirebaseUser user =
        (await _firebaseAuth.signInWithCredential(credential)).user;
    if (user != null) {
      final IdTokenResult tokenResult = await user.getIdToken();
      if (tokenResult != null) {
        return tokenResult.token;
      }
    }
    return null;
  }

  Future<AuthResult> signInAnonymous() async {
    return _firebaseAuth.signInAnonymously();
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<FirebaseUser> getCurrentUser() async {
    return _firebaseAuth.currentUser();
  }
}
