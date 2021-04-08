import 'package:flutter/material.dart';
import 'package:word_translation_picture/presentation/components/consts.dart';

class DefaultImage extends StatelessWidget {
  const DefaultImage();

  @override
  Widget build(BuildContext context) => Image.network(
        defaultWordRowImage,
        fit: BoxFit.cover,
      );
}

const defaultImage = DefaultImage();
