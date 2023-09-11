import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../page/contains.dart';

class MessageAvatar extends StatelessWidget {
  const MessageAvatar({
    Key? key,
    required this.size,
    required this.urlAvatar,
  }) : super(key: key);

  final double size;
  final String urlAvatar;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: CachedNetworkImage(
        filterQuality: FilterQuality.high,
        imageUrl: '',
        fit: BoxFit.cover,
        width: size,
        height: size,
        imageBuilder: (context, imageProvider) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
        placeholder: (context, url) => Image.asset(
          'assets/imgs/avatar.png',
          package: Consts.packageName,
          fit: BoxFit.cover,
          width: size,
          height: size,
        ),
        errorWidget: (context, url, _) => Image.asset(
          'assets/imgs/avatar.png',
          package: Consts.packageName,
          fit: BoxFit.cover,
          width: size,
          height: size,
        ),
      ),
    );
  }
}
