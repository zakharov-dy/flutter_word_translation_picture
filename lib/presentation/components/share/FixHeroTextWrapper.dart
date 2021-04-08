import 'package:flutter/material.dart';

// https://github.com/flutter/flutter/issues/30647#issuecomment-509712719
class FixHeroTextWrapper extends StatelessWidget {
  const FixHeroTextWrapper(this.child);

  final Widget child;

  @override
  Widget build(BuildContext context) => Material(
      type: MaterialType.transparency,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: AlignmentDirectional.centerStart,
        child: child,
      ));
}
