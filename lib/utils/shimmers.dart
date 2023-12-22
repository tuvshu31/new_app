import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyShimmers {
  Widget listView() {
    return Container(
      margin: EdgeInsets.all(Get.width * .03),
      height: Get.height * .13,
      child: Row(
        children: [
          CustomShimmer(
            width: Get.width * .25,
            height: Get.width * .25,
          ),
          SizedBox(width: Get.width * .045),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomShimmer(
                width: double.infinity,
                height: 14,
              ),
              CustomShimmer(
                width: Get.width * .3,
                height: 14,
              ),
              CustomShimmer(
                width: Get.width * .45,
                height: 14,
              ),
              CustomShimmer(
                width: Get.width * .5,
                height: 14,
              )
            ],
          )),
          SizedBox(width: Get.width * .045),
        ],
      ),
    );
  }

  Widget listView2() {
    return Container(
        height: Get.height * .14,
        color: MyColors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: Get.width * .4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomShimmer(
                    width: Get.width * .8,
                    height: 12,
                  ),
                  CustomShimmer(
                    width: Get.width * .4,
                    height: 12,
                  ),
                  CustomShimmer(
                    width: Get.width * .8,
                    height: 12,
                  ),
                ],
              ),
            ),
            SizedBox(width: Get.width * .03),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomShimmer(
                  width: Get.height * .14,
                  height: Get.height * .14,
                ),
              ),
            ),
            SizedBox(
              width: Get.width * .2,
              child: Center(
                child: CustomShimmer(
                  width: Get.width * .1,
                  height: Get.width * .1,
                  isCircle: true,
                ),
              ),
            )
          ],
        ));
  }

  Widget imagePickerShimmer(int length) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        return const CustomShimmer(
          width: double.infinity,
          height: double.infinity,
        );
      },
    );
  }

  Widget userPage() {
    return ListView.separated(
        separatorBuilder: (context, index) {
          return Container(
            height: 8,
          );
        },
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: 6,
        itemBuilder: (context, index) {
          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: Get.width * .075),
            dense: true,
            minLeadingWidth: Get.width * .07,
            leading: const CustomShimmer(
              width: 40,
              height: 40,
              borderRadius: 50,
            ),
            title: CustomShimmer(
              width: Get.width * .65,
              height: 14,
            ),
          );
        });
  }
}

Widget listShimmerWidget() {
  return ListView.separated(
    separatorBuilder: (context, index) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        width: double.infinity,
        height: Get.height * .008,
        decoration: BoxDecoration(color: MyColors.fadedGrey),
      );
    },
    physics: const BouncingScrollPhysics(),
    itemCount: 8,
    itemBuilder: (context, index) {
      return itemShimmer();
    },
  );
}

Widget itemShimmer() {
  return SizedBox(
    height: Get.width * .2 + 16,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(width: Get.width * .04),
          Stack(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: Get.width * 0.2,
                  maxHeight: Get.width * 0.2,
                ),
                child: CustomShimmer(
                  width: Get.width * .2,
                  height: Get.width * .2,
                  borderRadius: 50,
                ),
              ),
            ],
          ),
          SizedBox(width: Get.width * .04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomShimmer(width: Get.width * .65, height: 16),
                CustomShimmer(width: Get.width * .65, height: 16),
                CustomShimmer(width: Get.width * .65, height: 16),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget productsLoadingWidget() {
  return GridView.builder(
    physics: const NeverScrollableScrollPhysics(),
    itemCount: 12,
    shrinkWrap: true,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      childAspectRatio: 0.7,
    ),
    itemBuilder: (context, index) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomShimmer(
            width: Get.width * .3,
            height: Get.width * .3,
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: Get.width * .3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomShimmer(width: Get.width * .25, height: 16),
                const SizedBox(height: 4),
                CustomShimmer(width: Get.width * .25, height: 16),
              ],
            ),
          ),
        ],
      );
    },
  );
}
