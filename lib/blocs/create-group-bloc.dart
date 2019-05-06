import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myfootball/blocs/base-bloc.dart';
import 'package:rxdart/rxdart.dart';

class CreateGroupBloc implements BaseBloc {
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
  Observable<bool> get submitRegisterStream => Observable(_submitRegisterCtrl);

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
