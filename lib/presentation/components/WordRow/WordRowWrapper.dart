import 'package:flutter/material.dart';

class WordRowWrapper extends StatelessWidget {
  WordRowWrapper({
    required this.child,
  }) : super();
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
      margin: EdgeInsets.only(bottom: 4),
      child: PhysicalModel(
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.deepPurple,
        child: child,
      ));
}
