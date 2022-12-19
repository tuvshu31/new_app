import 'package:flutter/material.dart';

class CustomInkWell extends StatefulWidget {
  final Widget? child;
  final Function()? onTap;
  final Color? splashColor;
  final double topLeftRadius;
  final Color? highlightColor;
  final double topRightRadius;
  final bool borderRadiusOnly;
  final double bottomLeftRadius;
  final double bottomRightRadius;
  final BorderRadius borderRadius;

  const CustomInkWell({
    Key? key,
    this.child,
    this.onTap,
    this.splashColor,
    this.highlightColor,
    this.topLeftRadius = 0,
    this.topRightRadius = 0,
    this.bottomLeftRadius = 0,
    this.bottomRightRadius = 0,
    this.borderRadiusOnly = false,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  }) : super(key: key);

  @override
  _CustomInkWellState createState() => _CustomInkWellState();
}

class _CustomInkWellState extends State<CustomInkWell> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child ?? Container(),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              child: Container(),
              onTap: widget.onTap,
              highlightColor: widget.highlightColor,
              splashColor: widget.splashColor?.withOpacity(0.4),
              borderRadius: !widget.borderRadiusOnly
                  ? widget.borderRadius
                  : BorderRadius.only(
                      topLeft: Radius.circular(widget.topLeftRadius),
                      topRight: Radius.circular(widget.topRightRadius),
                      bottomLeft: Radius.circular(widget.bottomLeftRadius),
                      bottomRight: Radius.circular(widget.bottomRightRadius),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
