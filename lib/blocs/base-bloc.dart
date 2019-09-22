import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

abstract class BaseBloc {
  final _loadingCtrl = PublishSubject<bool>();
  Function(bool) get setLoadingFunc => _loadingCtrl.add;
  Observable<bool> get loadingStream => Observable(_loadingCtrl);

  void dispose() {
    _loadingCtrl.close();
  }

  void initState() {}
}

// Generic BLoC provider
class BlocProvider<T extends BaseBloc> extends StatefulWidget {
  BlocProvider({Key key, @required this.child, @required this.bloc}) : super(key: key);

  final T bloc;
  final Widget child;

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  static T of<T extends BaseBloc>(BuildContext context) {
    final type = _typeOf<BlocProvider<T>>();
    BlocProvider<T> provider = context.ancestorWidgetOfExactType(type);
    return provider.bloc;
  }

  static Type _typeOf<T>() => T;
}

class _BlocProviderState<T> extends State<BlocProvider<BaseBloc>> {
  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

//  @override
//  void deactivate() {
//    widget.bloc.dispose();
//    super.deactivate();
//  }

  @override
  void initState() {
    super.initState();
    widget.bloc.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
