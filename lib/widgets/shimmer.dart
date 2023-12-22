import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/utils/styles.dart';

class CustomShimmer extends StatelessWidget {
  final double width;
  final double height;
  final bool isCircle;
  final double borderRadius;
  const CustomShimmer({
    Key? key,
    required this.width,
    required this.height,
    this.borderRadius = 12,
    this.isCircle = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: MyColors.fadedGrey,
      highlightColor: MyColors.grey.withOpacity(0.3),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: Colors.white,
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        ),
      ),
    );
  }
}

Widget userHomeScreenMainViewShimmer() {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 18,
      vertical: 0,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            width: Get.width * .2,
            decoration: BoxDecoration(
              color: MyColors.fadedGrey,
              shape: BoxShape.circle,
            ),
            child: CustomShimmer(
              width: Get.width * .2,
              height: Get.width * .2,
              borderRadius: 50,
            )),
        const SizedBox(height: 8),
        CustomShimmer(
          width: Get.width * .2,
          height: 16,
          borderRadius: 12,
        )
      ],
    ),
  );
}
