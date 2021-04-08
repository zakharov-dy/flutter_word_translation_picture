import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:word_translation_picture/presentation/components/consts.dart';
import 'package:word_translation_picture/presentation/components/share/DefaultImage.dart';
import 'package:word_translation_picture/presentation/components/share/centerCircularProgressIndicator.dart';

class CachedNonExceptionImage extends StatelessWidget {
  const CachedNonExceptionImage(
      {Key? key, required this.img, this.fit = BoxFit.cover})
      : super(key: key);

  final String? img;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) => CachedNetworkImage(
        placeholder: (context, url) => centerCircularProgressIndicator,
        imageUrl: img == null ? defaultWordRowImage : img!,
        errorWidget: (context, error, stackTrace) => defaultImage,
        fit: fit,
      );
}
