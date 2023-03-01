// import 'dart:convert';
// import 'dart:developer';
// import 'package:Erdenet24/controller/store_controller.dart';
// import 'package:Erdenet24/screens/store/orders/store_orders_main_screen.dart';
// import 'package:Erdenet24/utils/helpers.dart';
// import 'package:Erdenet24/utils/styles.dart';
// import 'package:Erdenet24/widgets/swipe_button.dart';
// import 'package:Erdenet24/widgets/text.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import 'package:numberpicker/numberpicker.dart';
// import 'package:slide_to_act/slide_to_act.dart';

// List<Widget> getList() {
//   List<Widget> numbers = [];
//   for (var i = 1; i < 60; i++) {
//     numbers.add(Center(
//       child: Text(
//         '$i минут',
//         style: const TextStyle(
//           fontSize: 16,
//           fontFamily: "Nunito",
//         ),
//       ),
//     ));
//   }
//   return numbers;
// }

// final _storeCtx = Get.put(StoreController());

// void showOrdersSetTime1(context, data) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     // useSafeArea: true,
//     builder: (context) {
//       return FractionallySizedBox(
//         heightFactor: 1,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const CustomText(
//                 text: "Захиалгын код",
//                 fontSize: 12,
//                 color: MyColors.gray,
//               ),
//               CustomText(
//                 text: data["orderId"].toString(),
//                 fontSize: 16,
//                 color: MyColors.black,
//               ),
//               const SizedBox(height: 12),
//               ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: data["products"].length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     contentPadding: EdgeInsets.zero,
//                     dense: true,
//                     leading: CustomText(text: (index + 1).toString()),
//                     title: CustomText(text: data["products"][index]["name"]),
//                     trailing: Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: MyColors.fadedGrey,
//                         shape: BoxShape.circle,
//                       ),
//                       child: CustomText(
//                         text: data["products"][index]["quantity"].toString(),
//                         fontSize: 12,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               const SizedBox(height: 12),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const CustomText(text: "Нийт үнэ"),
//                   CustomText(
//                     text: convertToCurrencyFormat(
//                       int.parse(data["totalAmount"].toString()),
//                       locatedAtTheEnd: true,
//                       toInt: true,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: Get.height * .1),
//               const CustomText(text: "Бэлдэж дуусах хугацаа:"),
//               const SizedBox(height: 12),
//               SizedBox(
//                 height: Get.height * .25,
//                 child: CupertinoPicker(
//                   magnification: 1.1,
//                   looping: true,
//                   itemExtent: 36,
//                   diameterRatio: 3,
//                   scrollController: FixedExtentScrollController(initialItem: 1),
//                   children: getList(),
//                   onSelectedItemChanged: (value) {
//                     _storeCtx.pickedMinutes.value = value;
//                   },
//                 ),
//               ),
//               SizedBox(height: Get.height * .15),
//               Builder(
//                 builder: (contexts) {
//                   final GlobalKey<SlideActionState> key = GlobalKey();
//                   return Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: SlideAction(
//                       outerColor: MyColors.black,
//                       innerColor: MyColors.primary,
//                       elevation: 0,
//                       key: key,
//                       submittedIcon: const Icon(
//                         FontAwesomeIcons.check,
//                         color: MyColors.white,
//                       ),
//                       onSubmit: () {
//                         Future.delayed(const Duration(milliseconds: 300), () {
//                           key.currentState!.reset();
//                           _storeCtx.orderList.add(data);
//                           Get.back();
//                           Get.to(() => const StoreOrdersMainScreen());
//                         });
//                       },
//                       alignment: Alignment.centerRight,
//                       sliderButtonIcon: const Icon(
//                         Icons.double_arrow_rounded,
//                         color: MyColors.white,
//                       ),
//                       child: const Text(
//                         "Бэлдэж эхлэх",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }
