import 'package:Erdenet24/utils/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import 'package:get/get.dart';

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
        errorBuilder: (context, error, stackTrace) {
          return Container();
        },
      ),
    );
  }
}

Widget customImage(
  double width,
  String url, {
  bool isCircle = false,
  bool isFaded = false,
  String fadeText = "",
}) {
  return Stack(
    alignment: Alignment.center,
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(isCircle ? 50 : 12),
        clipBehavior: Clip.hardEdge,
        child: CachedNetworkImage(
          width: width,
          height: width,
          fit: BoxFit.cover,
          imageUrl: url,
          placeholder: (context, url) =>
              const CupertinoActivityIndicator(color: MyColors.gray),
          errorWidget: (context, url, error) {
            return Container(
              width: width,
              height: width,
              color: MyColors.fadedGrey,
              child: Center(
                child: Icon(
                  Icons.image,
                  color: MyColors.grey,
                  size: Get.width * .075,
                ),
              ),
            );
          },
        ),
      ),
      isFaded
          ? Center(
              child: Container(
                width: width,
                height: width,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  // shape: BoxShape.circle,
                  borderRadius: BorderRadius.circular(isCircle ? 50 : 12),
                ),
                child: Center(
                  child: Text(
                    fadeText,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          : Container()
    ],
  );
}


          //  data["isOpen"] == 0
          //                               ? Container(
          //                                   width: Get.width * .2,
          //                                   height: Get.width * .2,
          //                                   decoration: BoxDecoration(
          //                                     color:
          //                                         Colors.black.withOpacity(0.7),
          //                                     shape: BoxShape.circle,
          //                                   ),
          //                                   child: const Center(
          //                                     child: Text(
          //                                       "Хаалттай",
          //                                       style: TextStyle(
          //                                         color: Colors.white,
          //                                       ),
          //                                     ),
          //                                   ),
          //                                 )
          //                               : Container()