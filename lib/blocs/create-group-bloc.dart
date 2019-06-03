import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myfootball/blocs/base-bloc.dart';
import 'package:myfootball/data/app-preference.dart';
import 'package:myfootball/models/responses/base-response.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CreateGroupBloc implements BaseBloc {
  final _loadingCtrl = PublishSubject<bool>();
  Function(bool) get addLoadingFunc => _loadingCtrl.add;
  Observable<bool> get loadingStream => Observable(_loadingCtrl);

  final _chooseLogoCtrl = BehaviorSubject<File>();
  Function(File) get chooseLogoFunc => _chooseLogoCtrl.add;
  Observable<File> get chooseLogoStream => Observable(_chooseLogoCtrl);

  final _chooseDressCtrl = BehaviorSubject<Color>(seedValue: Colors.red);
  Function(Color) get chooseDressFunc => _chooseDressCtrl.add;
  Observable<Color> get chooseDressStream => Observable(_chooseDressCtrl);

  final _nameCtrl = BehaviorSubject<String>();
  Function(String) get changeNameFunc => _nameCtrl.add;
  Observable<String> get changeNameStream => Observable(_nameCtrl);

  final _bioCtrl = BehaviorSubject<String>();
  Function(String) get changeBioFunc => _bioCtrl.add;
  Observable<String> get changeBioStream => Observable(_bioCtrl);

  final _submitRegisterCtrl = BehaviorSubject<bool>();
  Function(bool) get submitRegisterFunc => _submitRegisterCtrl.add;
  Observable<BaseResponse> get submitRegisterStream =>
      Observable(_submitRegisterCtrl)
          .flatMap((_) =>
              Observable.fromFuture(uploadImage(_chooseLogoCtrl.value))
                  .doOnListen(() => addLoadingFunc(true))
                  .doOnData((link) {
                if (link == null) {
                  addLoadingFunc(false);
                  return Observable.just(BaseResponse(
                      success: false,
                      errorMessage: "Error while upload group logo"));
                } else {
                  return Observable.just(link);
                }
              }))
          .flatMap((imageLink) => Observable.just(BaseResponse(success: true)));

  Future<String> uploadImage(File image) async {
    var user = await AppPreference().getUser();
    DateTime _now = DateTime.now();
    StorageReference storageRef = FirebaseStorage.instance
        .ref()
        .child("groups")
        .child('${user.id}-${_now.toString()}');
    StorageUploadTask uploadTask = storageRef.putFile(image);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    if (uploadTask.isSuccessful) {
      return await storageTaskSnapshot.ref.getDownloadURL();
    } else {
      return null;
    }
  }

  @override
  void dispose() {
    _chooseLogoCtrl.close();
    _chooseDressCtrl.close();
    _nameCtrl.close();
    _bioCtrl.close();
    _submitRegisterCtrl.close();
  }

  @override
  void initState() {}
}
