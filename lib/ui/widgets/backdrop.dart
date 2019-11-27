import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'dart:math' as math;

final double _kFrontClosedHeight =
    UIHelper.size40; // front layer height when closed
final double _kBackAppBarHeight =
    UIHelper.size50; // back layer (options) appbar height

class _TappableWhileStatusIs extends StatefulWidget {
  const _TappableWhileStatusIs(
    this.status, {
    Key key,
    this.controller,
    this.child,
  }) : super(key: key);

  final AnimationController controller;
  final AnimationStatus status;
  final Widget child;

  @override
  _TappableWhileStatusIsState createState() => _TappableWhileStatusIsState();
}

class _TappableWhileStatusIsState extends State<_TappableWhileStatusIs> {
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
    Widget child = AbsorbPointer(
      absorbing: !_active,
      child: widget.child,
    );

    if (!_active) {
      child = FocusScope(
        debugLabel: '$_TappableWhileStatusIs',
        child: child,
      );
    }
    return child;
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
      this.frontTrailing,
      this.frontTitle,
      this.frontHeading,
      this.frontLayer,
      this.backTitle,
      this.backLayer,
      this.color})
      : super(key: key);

  final Widget frontTrailing;
  final Widget frontTitle;
  final Widget frontLayer;
  final Widget backTitle;
  final Widget backLayer;
  final Widget frontHeading;
  final Color color;

  @override
  BackdropState createState() => BackdropState();
}

class BackdropState extends State<Backdrop>
    with SingleTickerProviderStateMixin {
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');
  AnimationController _controller;
  Animation<double> _frontOpacity;
  Animation<double> _frontHeadingOpacity;

  static final Animatable<double> _frontOpacityTween =
      Tween<double>(begin: 0.2, end: 1.0).chain(
          CurveTween(curve: const Interval(0.0, 0.2, curve: Curves.easeInOut)));

  static final Animatable<double> _frontHeadingOpacityTween = Tween<double>(
          begin: 0.8, end: 0)
      .chain(CurveTween(curve: const Interval(0, 0.2, curve: Curves.easeOut)));

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      value: 1.0,
      vsync: this,
    );
    _frontOpacity = _controller.drive(_frontOpacityTween);
    _frontHeadingOpacity = _controller.drive(_frontHeadingOpacityTween);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _backdropHeight {
    final RenderBox renderBox = _backdropKey.currentContext.findRenderObject();
    return math.max(
        0.0, renderBox.size.height - _kBackAppBarHeight - _kFrontClosedHeight);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _controller.value -=
        details.primaryDelta / (_backdropHeight ?? details.primaryDelta);
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed) return;

    final double flingVelocity =
        details.velocity.pixelsPerSecond.dy / _backdropHeight;
    if (flingVelocity < 0.0)
      _controller.fling(velocity: math.max(2.0, -flingVelocity));
    else if (flingVelocity > 0.0)
      _controller.fling(velocity: math.min(-2.0, -flingVelocity));
    else
      _controller.fling(velocity: _controller.value < 0.5 ? -2.0 : 2.0);
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
            leading: IconButton(
              onPressed: toggleFrontLayer,
              icon: AnimatedIcon(
                color: widget.color,
                icon: AnimatedIcons.close_menu,
                progress: _controller,
              ),
            ),
            trailing: widget.frontTrailing ??
                SizedBox(
                  width: _kBackAppBarHeight,
                  height: _kBackAppBarHeight,
                ),
            title: _CrossFadeTransition(
              progress: _controller,
              alignment: AlignmentDirectional.centerStart,
              child0: Semantics(namesRoute: true, child: widget.frontTitle),
              child1: Semantics(namesRoute: true, child: widget.backTitle),
            ),
          ),
          Expanded(
            child: _TappableWhileStatusIs(
              AnimationStatus.dismissed,
              controller: _controller,
              child: Visibility(
                child: widget.backLayer,
                visible: _controller.status != AnimationStatus.completed,
                maintainState: true,
              ),
            ),
          ),
        ],
      ),
      // Front layer
      PositionedTransition(
        rect: frontRelativeRect,
        child: ClipRRect(
          child: _TappableWhileStatusIs(
            AnimationStatus.completed,
            controller: _controller,
            child: FadeTransition(
              opacity: _frontOpacity,
              child: widget.frontLayer,
            ),
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(UIHelper.radius),
            topRight: Radius.circular(UIHelper.radius),
          ),
          clipBehavior: Clip.antiAlias,
        ),
      ),
      if (widget.frontHeading != null)
        PositionedTransition(
          rect: frontRelativeRect,
          child: Visibility(
            visible: _controller.status != AnimationStatus.completed,
            child: ExcludeSemantics(
              child: Container(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: toggleFrontLayer,
                  onVerticalDragUpdate: _handleDragUpdate,
                  onVerticalDragEnd: _handleDragEnd,
                  child: FadeTransition(
                    child: widget.frontHeading,
                    opacity: _frontHeadingOpacity,
                  ),
                ),
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
