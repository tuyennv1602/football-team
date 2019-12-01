import 'package:flutter/material.dart';
import 'package:myfootball/utils/ui_helper.dart';

bool _isShowing = false;
BuildContext _context, _dismissingContext;
bool _barrierDismissible = true;

class ProgressDialog {
  _Body _dialog;

  ProgressDialog(BuildContext context, {bool isDismissible}) {
    _context = context;
    _barrierDismissible = isDismissible ?? true;
  }

  bool isShowing() {
    return _isShowing;
  }

  void dismiss() {
    if (_isShowing) {
      try {
        _isShowing = false;
        if (Navigator.of(_dismissingContext).canPop()) {
          Navigator.of(_dismissingContext).pop();
        }
      } catch (_) {}
    }
  }

  Future<bool> hide() {
    if (_isShowing) {
      try {
        _isShowing = false;
        Navigator.of(_dismissingContext).pop(true);
        return Future.value(true);
      } catch (_) {
        return Future.value(false);
      }
    } else {
      return Future.value(false);
    }
  }

  void show() {
    if (!_isShowing) {
      _dialog = new _Body();
      _isShowing = true;

      showDialog<dynamic>(
        context: _context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          _dismissingContext = context;
          return WillPopScope(
              onWillPop: () {
                return Future.value(_barrierDismissible);
              },
              child: _dialog);
        },
      );
    } else {}
  }
}

class _Body extends StatefulWidget {
  final _BodyState _dialog = _BodyState();

  @override
  State<StatefulWidget> createState() {
    return _dialog;
  }
}

class _BodyState extends State<_Body> {
  @override
  void dispose() {
    _isShowing = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        Container(
          width: UIHelper.size(60),
          height: UIHelper.size(60),
          padding: EdgeInsets.all(UIHelper.size5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(UIHelper.size30),
          ),
          child: Image.asset('assets/images/ic_circle_loading.gif'),
        )
      ],
    );
  }
}
