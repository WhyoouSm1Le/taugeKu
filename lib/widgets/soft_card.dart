import 'package:flutter/material.dart';
import 'package:taugeku_mobile03/core/app_radius.dart';

class SoftCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? radius;
  final Color color;
  final Gradient? gradient;
  final bool showBorder;

  const SoftCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.margin,
    this.radius,
    this.color = Colors.white,
    this.gradient,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: gradient == null ? color : null,
        gradient: gradient,
        borderRadius: radius ?? AppRadius.leaf(24, 9),
        border: showBorder
            ? Border.all(color: const Color.fromRGBO(84, 55, 65, 0.07))
            : null,
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(67, 43, 52, 0.07),
            blurRadius: 32,
            offset: Offset(0, 13),
          )
        ]
      ),
      child: child,
    );
  }
}