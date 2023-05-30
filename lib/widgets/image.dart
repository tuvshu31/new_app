import 'package:Erdenet24/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class CustomImage extends StatelessWidget {
  final double width;
  final double height;
  final String url;

  const CustomImage({
    super.key,
    required this.width,
    required this.height,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
      ),
      clipBehavior: Clip.hardEdge,
      child: Image.network(
        url,
        errorBuilder: (context, error, stackTrace) {
          return const SizedBox(
            child: Image(
              image: AssetImage("assets/images/png/no_image.png"),
            ),
          );
        },
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return Container(
            decoration: BoxDecoration(
              color: MyColors.fadedGrey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const CupertinoActivityIndicator(),
          );
        },
      ),
    );
  }
}
