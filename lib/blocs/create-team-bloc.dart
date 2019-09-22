import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myfootball/blocs/base-bloc.dart';
import 'package:myfootball/data/app-preference.dart';
import 'package:myfootball/data/repositories/firebase-repository.dart';
import 'package:myfootball/data/repositories/team-repository.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/models/responses/base-response.dart';
import 'package:myfootball/models/responses/team-response.dart';
import 'package:myfootball/res/colors.dart';
import 'package:rxdart/rxdart.dart';

class CreateTeamBloc extends BaseBloc {
  final _teamRepositoty = TeamReposiroty();
  final _appPref = AppPreference();

  final _chooseLogoCtrl = BehaviorSubject<File>();
  Function(File) get chooseLogoFunc => _chooseLogoCtrl.add;
  Observable<File> get chooseLogoStream => Observable(_chooseLogoCtrl);

  final _chooseDressCtrl = BehaviorSubject<Color>(seedValue: Colors.pink);
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
  Observable<TeamResponse> get submitRegisterStream => Observable(_submitRegisterCtrl)
      .flatMap((_) => Observable.fromFuture(_uploadImage(_chooseLogoCtrl.value))
              .doOnListen(() => setLoadingFunc(true))
              .doOnError(() => setLoadingFunc(false))
              .doOnData((link) {
            if (link == null) {
              setLoadingFunc(false);
              return Observable.just(
                  BaseResponse(success: false, errorMessage: "Error while upload group logo"));
            } else {
              return Observable.just(link);
            }
          }))
      .flatMap((imageLink) => Observable.fromFuture(_createTeam(imageLink))
          .doOnError(() => setLoadingFunc(false))
          .doOnDone(() => setLoadingFunc(false)))
      .flatMap((resp) => Observable.fromFuture(_handleSuccess(resp)))
      .flatMap((resp) => Observable.just(resp));

  Future<TeamResponse> _createTeam(String imageLink) async {
    var user = await _appPref.getUser();
    print(imageLink);
    return _teamRepositoty.createTeam(Team(
        userId: user.id,
        name: _nameCtrl.value,
        bio: _bioCtrl.value,
        dress: getColorValue(_chooseDressCtrl.value.toString()),
        logo: imageLink));
  }

  Future<TeamResponse> _handleSuccess(TeamResponse response) async {
    if (response.isSuccess) {
      var user = await _appPref.getUser();
      user.addTeam(response.team);
      await _appPref.setUser(user);
    }
    return Future.value(response);
  }

  Future<String> _uploadImage(File image) async {
    if (image == null) return null;
    var user = await _appPref.getUser();
    var name = '${user.id}-${_nameCtrl.value}';
    return FirebaseRepository().uploadImage(image, 'team', name);
  }

  @override
  void dispose() {
    super.dispose();
    _chooseLogoCtrl.close();
    _chooseDressCtrl.close();
    _nameCtrl.close();
    _bioCtrl.close();
    _submitRegisterCtrl.close();
  }
}
