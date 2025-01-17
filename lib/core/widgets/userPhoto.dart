import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clean/generated/assets.dart';

Widget UserPhoto({String? imageUrl, File? image}) {
  if (image == null) {
    if (imageUrl == null || imageUrl == "") {
      return Image.asset(
        Assets.imagesProfileimage,
        fit: BoxFit.cover,
      );
    }else {
      return CachedNetworkImage(
        imageUrl: "$imageUrl",
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, downloadProgress) {
          return CircularProgressIndicator();
        },
        errorWidget: (context, url, error) =>
            Image.asset(
              Assets.imagesProfileimage,
              fit: BoxFit.cover,
            ),
      );
    }
  } else {
    return Image.file(image, fit: BoxFit.cover,);
  }
}