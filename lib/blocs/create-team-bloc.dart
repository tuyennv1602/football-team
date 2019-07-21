import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myfootball/blocs/base-bloc.dart';
import 'package:myfootball/data/app-preference.dart';
import 'package:myfootball/data/repositories/team-repository.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/models/responses/base-response.dart';
import 'package:myfootball/models/responses/create-team-response.dart';
import 'package:myfootball/res/colors.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CreateTeamBloc implements BaseBloc {
  final _teamReposiroty = TeamReposiroty();
  final _appPref = AppPreference();

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

  final _submitRegisterCtrl = PublishSubject<bool>();
  Function(bool) get submitRegisterFunc => _submitRegisterCtrl.add;
  Observable<CreateTeamResponse> get submitRegisterStream => Observable(_submitRegisterCtrl)
      .flatMap((_) => Observable.fromFuture(uploadImage(_chooseLogoCtrl.value))
              .doOnListen(() => addLoadingFunc(true))
              .doOnError(() => addLoadingFunc(false))
              .doOnData((link) {
            if (link == null) {
              addLoadingFunc(false);
              return Observable.just(
                  BaseResponse(success: false, errorMessage: "Error while upload group logo"));
            } else {
              return Observable.just(link);
            }
          }))
      .flatMap((imageLink) => Observable.fromFuture(_teamReposiroty.createGroup(Team(
              name: _nameCtrl.value,
              bio: _bioCtrl.value,
              dress: AppColor.getColorValue(_chooseDressCtrl.value.toString()),
              logo: imageLink)))
          .doOnError(() => addLoadingFunc(false))
          .doOnData((onData) => addLoadingFunc(false)))
      .flatMap((response) => Observable.fromFuture(_handleSuccess(response)))
      .flatMap((response) => Observable.just(response));

  Future<CreateTeamResponse> _handleSuccess(CreateTeamResponse response) async {
    if (response.success) {
      var user = await _appPref.getUser();
      user.addTeam(response.team);
      await _appPref.setUser(user);
    }
    return Future.value(response);
  }

  Future<String> uploadImage(File image) async {
    if (image == null) return null;
    var user = await AppPreference().getUser();
    StorageReference storageRef =
        FirebaseStorage.instance.ref().child("groups").child('leader-${user.id}');
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
    _loadingCtrl.close();
    _chooseLogoCtrl.close();
    _chooseDressCtrl.close();
    _nameCtrl.close();
    _bioCtrl.close();
    _submitRegisterCtrl.close();
  }

  @override
  void initState() {}
}
