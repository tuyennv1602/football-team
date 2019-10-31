import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:myfootball/utils/ui_helper.dart';

final double _kFrontClosedHeight =
    UIHelper.size(50); // front layer height when closed
final double _kBackAppBarHeight =
    UIHelper.size(50); // back layer (options) appbar height

class _TapableWhileStatus extends StatefulWidget {
  const _TapableWhileStatus(
    this.status, {
    Key key,
    this.controller,
    this.child,
  }) : super(key: key);

  final AnimationController controller;
  final AnimationStatus status;
  final Widget child;

  @override
  _TapableWhileStatusState createState() => _TapableWhileStatusState();
}

class _TapableWhileStatusState extends State<_TapableWhileStatus> {
  bool _active;

  @override
  void initState() {
    super.initState();
    widget.controller.addStatusListener(_handleStatusChange);
    _active = widget.controller.status == widget.status;
  }

  @override
  void dispose() {
    widget.controller.removeStatusListener(_handleStatusChange);
    super.dispose();
  }

  void _handleStatusChange(AnimationStatus status) {
    final bool value = widget.controller.status == widget.status;
    if (_active != value) {
      setState(() {
        _active = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: !_active,
      child: widget.child,
    );
  }
}

class _CrossFadeTransition extends AnimatedWidget {
  const _CrossFadeTransition({
    Key key,
    this.alignment = Alignment.center,
    Animation<double> progress,
    this.child0,
    this.child1,
  }) : super(key: key, listenable: progress);

  final AlignmentGeometry alignment;
  final Widget child0;
  final Widget child1;

  @override
  Widget build(BuildContext context) {
    final Animation<double> progress = listenable;

    final double opacity1 = CurvedAnimation(
      parent: ReverseAnimation(progress),
      curve: const Interval(0.5, 1.0),
    ).value;

    final double opacity2 = CurvedAnimation(
      parent: progress,
      curve: const Interval(0.5, 1.0),
    ).value;

    return Stack(
      alignment: alignment,
      children: <Widget>[
        Opacity(
          opacity: opacity1,
          child: Semantics(
            scopesRoute: true,
            explicitChildNodes: true,
            child: child1,
          ),
        ),
        Opacity(
          opacity: opacity2,
          child: Semantics(
            scopesRoute: true,
            explicitChildNodes: true,
            child: child0,
          ),
        ),
      ],
    );
  }
}

class _BackAppBar extends StatelessWidget {
  const _BackAppBar({
    Key key,
    @required this.leading,
    @required this.title,
    this.trailing,
  })  : assert(leading != null),
        assert(title != null),
        super(key: key);

  final Widget leading;
  final Widget title;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[
      Container(
        alignment: Alignment.center,
        width: _kBackAppBarHeight,
        child: leading,
      ),
      Expanded(
        child: title,
      ),
    ];
    if (trailing != null) {
      children.add(
        Container(
          alignment: Alignment.center,
          width: _kBackAppBarHeight,
          child: trailing,
        ),
      );
    }
    return SizedBox(height: _kBackAppBarHeight, child: Row(children: children));
  }
}

class Backdrop extends StatefulWidget {
  Backdrop(
      {Key key,
      this.frontLeading,
      this.frontTitle,
      this.frontTrailing,
      this.frontLayer,
      this.backTitle,
      this.backLayer,
      this.color})
      : super(key: key);

  final Widget frontLeading;
  final Widget frontTitle;
  final Widget frontLayer;
  final Widget backTitle;
  final Widget backLayer;
  final Widget frontTrailing;
  final Color color;

  @override
  BackdropState createState() => BackdropState();
}

class BackdropState extends State<Backdrop>
    with SingleTickerProviderStateMixin {
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');
  AnimationController _controller;
  Animation<double> _frontOpacity;

  static final Animatable<double> _frontOpacityTween =
      Tween<double>(begin: 0.2, end: 1.0).chain(
          CurveTween(curve: const Interval(0.0, 0.4, curve: Curves.easeInOut)));

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      value: 1.0,
      vsync: this,
    );
    _frontOpacity = _controller.drive(_frontOpacityTween);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleFrontLayer() {
    final AnimationStatus status = _controller.status;
    final bool isOpen = status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
    _controller.fling(velocity: isOpen ? -2.0 : 2.0);
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    final Animation<RelativeRect> frontRelativeRect =
        _controller.drive(RelativeRectTween(
      begin: RelativeRect.fromLTRB(
          0.0, constraints.biggest.height - _kFrontClosedHeight, 0.0, 0.0),
      end: RelativeRect.fromLTRB(0.0, _kBackAppBarHeight, 0.0, 0.0),
    ));

    final List<Widget> layers = <Widget>[
      // Back layer
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _BackAppBar(
            leading: widget.frontLeading ??
                SizedBox(
                  width: _kBackAppBarHeight,
                  height: _kBackAppBarHeight,
                ),
            trailing: IconButton(
              onPressed: toggleFrontLayer,
              icon: AnimatedIcon(
                color: widget.color,
                icon: AnimatedIcons.close_menu,
                progress: _controller,
              ),
            ),
            title: _CrossFadeTransition(
              progress: _controller,
              alignment: AlignmentDirectional.centerStart,
              child0: Semantics(namesRoute: true, child: widget.frontTitle),
              child1: Semantics(namesRoute: true, child: widget.backTitle),
            ),
          ),
          Expanded(
            child: widget.backLayer,
          ),
        ],
      ),
      // Front layer
      PositionedTransition(
        rect: frontRelativeRect,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget child) {
            return ClipRRect(
              child: child,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(UIHelper.size20),
                topRight: Radius.circular(UIHelper.size20),
              ),
              clipBehavior: Clip.antiAlias,
            );
          },
          child: _TapableWhileStatus(
            AnimationStatus.completed,
            controller: _controller,
            child: FadeTransition(
              opacity: _frontOpacity,
              child: widget.frontLayer,
            ),
          ),
        ),
      ),
    ];
    return Stack(
      key: _backdropKey,
      children: layers,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: _buildStack);
  }
}
