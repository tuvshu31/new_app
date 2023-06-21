import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomImage extends StatelessWidget {
  final double width;
  final double height;
  final String url;
  final double radius;

  const CustomImage({
    super.key,
    required this.width,
    required this.height,
    required this.url,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
      ),
      clipBehavior: Clip.hardEdge,
      child: CachedNetworkImage(
        imageUrl: url,
        errorWidget: (context, url, error) {
          return SizedBox(
            width: width,
            height: height,
            child: const Image(
              image: AssetImage("assets/images/png/no_image.png"),
            ),
          );
        },
        progressIndicatorBuilder: (context, url, progress) {
          return CustomShimmer(
            width: width,
            height: height,
          );
        },
      ),
    );
  }
}
