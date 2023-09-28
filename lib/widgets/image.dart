import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:Erdenet24/widgets/shimmer.dart';

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
      child: Image.network(
        url,
        fit: BoxFit.fill,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
              child: CustomShimmer(
            width: width,
            height: height,
          )

              // CircularProgressIndicator(
              //   value: loadingProgress.expectedTotalBytes != null
              //       ? loadingProgress.cumulativeBytesLoaded /
              //           loadingProgress.expectedTotalBytes!
              //       : null,
              // ),
              );
        },
      ),
    );
  }
}
