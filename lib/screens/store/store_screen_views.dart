import 'dart:io';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

Widget imagePickerOptionsWidget(VoidCallback onPress1, VoidCallback onPress2) {
  return SizedBox(
    height: Get.height * .2,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomInkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: onPress1,
              child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: MyColors.fadedGrey,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(20),
                    child: Icon(
                      IconlyLight.camera,
                    ),
                  )),
            ),
            const SizedBox(height: 12),
            const CustomText(
              text: "Камер",
              color: MyColors.black,
            )
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomInkWell(
              borderRadius: BorderRadius.circular(300),
              onTap: onPress2,
              child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: MyColors.fadedGrey,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(20),
                    child: Icon(IconlyLight.image),
                  )),
            ),
            const SizedBox(height: 12),
            const CustomText(text: "Зургийн цомог")
          ],
        ),
      ],
    ),
  );
}

Widget hasImageWidget(String url, VoidCallback delete) => Stack(
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Image.file(
            File(url),
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Positioned(
          right: 5,
          top: 5,
          child: GestureDetector(
            onTap: delete,
            child: Icon(
              Icons.cancel_rounded,
              size: 30,
              color: MyColors.primary.withOpacity(0.4),
            ),
          ),
        ),
      ],
    );
Widget hasNoImageWidget(VoidCallback onTap) => GestureDetector(
      onTap: onTap,
      child: Container(
        width: Get.width * .3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: MyColors.background, width: 1),
        ),
        child: const Center(
          child: Icon(
            Icons.add_a_photo_outlined,
            size: 42,
            color: MyColors.black,
          ),
        ),
      ),
    );

Widget hasImageFromNetworkWidget(String url, VoidCallback delete) => Stack(
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Image.network(
            url,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Positioned(
          right: 5,
          top: 5,
          child: GestureDetector(
            onTap: delete,
            child: Icon(
              Icons.cancel_rounded,
              size: 30,
              color: MyColors.primary.withOpacity(0.4),
            ),
          ),
        ),
      ],
    );



  // void showCalendarFilter() {
  //   showModalBottomSheet(
  //     backgroundColor: MyColors.white,
  //     context: context,
  //     isScrollControlled: true,
  //     useSafeArea: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(12),
  //         topRight: Radius.circular(12),
  //       ),
  //     ),
  //     builder: (context) {
  //       return StatefulBuilder(builder: ((context, setState) {
  //         return Container(
  //           height: Get.height * .7,
  //           padding: const EdgeInsets.all(24),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       const Text("Эхлэх огноо"),
  //                       const SizedBox(height: 8),
  //                       CustomInkWell(
  //                         onTap: () {
  //                           startDateActive = !startDateActive;
  //                           setState(() {});
  //                         },
  //                         borderRadius: BorderRadius.circular(8),
  //                         child: Container(
  //                           padding: const EdgeInsets.symmetric(
  //                               horizontal: 24, vertical: 12),
  //                           decoration: BoxDecoration(
  //                             border: Border.all(
  //                               width: 1,
  //                               color: startDateActive
  //                                   ? MyColors.primary
  //                                   : MyColors.background,
  //                             ),
  //                             borderRadius: BorderRadius.circular(8),
  //                           ),
  //                           child: Text('2023-10-30'),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       const Text("Дуусах огноо"),
  //                       const SizedBox(height: 8),
  //                       CustomInkWell(
  //                         onTap: () {
  //                           startDateActive = !startDateActive;
  //                           setState(() {});
  //                         },
  //                         borderRadius: BorderRadius.circular(8),
  //                         child: Container(
  //                           padding: const EdgeInsets.symmetric(
  //                               horizontal: 24, vertical: 12),
  //                           decoration: BoxDecoration(
  //                             border: Border.all(
  //                               width: 1,
  //                               color: !startDateActive
  //                                   ? MyColors.primary
  //                                   : MyColors.background,
  //                             ),
  //                             borderRadius: BorderRadius.circular(8),
  //                           ),
  //                           child: Text('2023-10-30'),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //               const Spacer(),
  //               SizedBox(
  //                 height: Get.height * .4,
  //                 child: SfDateRangePicker(
  //                   selectionColor: MyColors.primary,
  //                   todayHighlightColor: Colors.black,
  //                   headerStyle: const DateRangePickerHeaderStyle(
  //                       textAlign: TextAlign.center,
  //                       textStyle: TextStyle(
  //                           fontFamily: 'Nunito', color: Colors.black)),
  //                   monthCellStyle: const DateRangePickerMonthCellStyle(
  //                     textStyle: TextStyle(
  //                       fontFamily: 'Nunito',
  //                       color: Colors.black,
  //                       fontSize: 14,
  //                     ),
  //                     todayTextStyle:
  //                         TextStyle(fontFamily: 'Nunito', color: Colors.black),
  //                   ),
  //                   showNavigationArrow: true,
  //                   allowViewNavigation: true,
  //                   headerHeight: Get.height * .1,
  //                   view: DateRangePickerView.month,
  //                   monthViewSettings: const DateRangePickerMonthViewSettings(
  //                       firstDayOfWeek: 1),
  //                 ),
  //               ),
  //               const Spacer(),
  //               Row(
  //                 children: [
  //                   Expanded(
  //                     child: CustomButton(
  //                       bgColor: Colors.white,
  //                       hasBorder: true,
  //                       borderColor: MyColors.background,
  //                       textColor: Colors.black,
  //                       text: "Болих",
  //                       onPressed: Get.back,
  //                       elevation: 0,
  //                     ),
  //                   ),
  //                   const SizedBox(width: 12),
  //                   Expanded(
  //                     child: CustomButton(
  //                       text: "Хайх",
  //                       onPressed: () {},
  //                       elevation: 0,
  //                     ),
  //                   ),
  //                 ],
  //               )
  //             ],
  //           ),
  //         );
  //       }));
  //     },
  //   );
  // }