import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  const CircleButton(
      {Key? key,
      required this.onPressed,
      this.fillColor = Colors.deepPurple,
      this.size = 48,
      required this.icon})
      : super(key: key);

  final VoidCallback? onPressed;
  final Color? fillColor;
  final double size;
  final Icon icon;

  @override
  Widget build(BuildContext context) => RawMaterialButton(
        onPressed: onPressed,
        elevation: 2.0,
        fillColor: fillColor,
        child: icon,
        constraints: BoxConstraints(
          maxHeight: size,
          minHeight: size,
          maxWidth: size,
          minWidth: size,
        ),
        shape: CircleBorder(),
      );
}
