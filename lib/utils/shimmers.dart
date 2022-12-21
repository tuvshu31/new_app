import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyShimmers {
  Widget homeScreen() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomShimmer(
            width: Get.width * .2,
            height: Get.width * .2,
            isCircle: true,
          ),
          const SizedBox(height: 4),
          CustomShimmer(
            width: Get.width * .2,
            height: 12,
            isRoundedCircle: true,
          ),
          const SizedBox(height: 4),
          CustomShimmer(
            width: Get.width * .2,
            height: 12,
            isRoundedCircle: true,
          )
        ],
      ),
    );
  }

  Widget listView() {
    return Container(
      margin: EdgeInsets.all(Get.width * .03),
      height: Get.height * .13,
      child: Row(
        children: [
          CustomShimmer(
            width: Get.width * .25,
            height: Get.width * .25,
            isRoundedCircle: true,
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
                isRoundedCircle: true,
              ),
              CustomShimmer(
                width: Get.width * .3,
                height: 14,
                isRoundedCircle: true,
              ),
              CustomShimmer(
                width: Get.width * .45,
                height: 14,
                isRoundedCircle: true,
              ),
              CustomShimmer(
                width: Get.width * .5,
                height: 14,
                isRoundedCircle: true,
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
                    isRoundedCircle: true,
                  ),
                  CustomShimmer(
                    width: Get.width * .4,
                    height: 12,
                    isRoundedCircle: true,
                  ),
                  CustomShimmer(
                    width: Get.width * .8,
                    height: 12,
                    isRoundedCircle: true,
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
  Widget profile(){
    return ListView.separated(
      separatorBuilder: (context, index) {
        return Container(height: 8,);
      },
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 6,
                        itemBuilder: (context, index) {
                      
                          return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: Get.width * .075),
        dense: true,
        minLeadingWidth: Get.width * .07,
        leading: const CustomShimmer(width: 40, height: 40, isCircle: true,),
        title: CustomShimmer(width: Get.width * .65, height: 14, isRoundedCircle: true,),
      );});
    
    

  }
}
