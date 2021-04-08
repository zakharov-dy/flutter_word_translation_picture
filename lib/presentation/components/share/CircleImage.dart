import 'package:flutter/material.dart';
import 'package:word_translation_picture/presentation/components/share/CachedNonExceptionImage.dart';

class CircleImage extends StatelessWidget {
  const CircleImage({Key? key, this.img, required this.size}) : super(key: key);
  final String? img;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size / 2),
          child: CachedNonExceptionImage(img: img),
        ),
      );
}
