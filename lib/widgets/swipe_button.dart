import 'package:Erdenet24/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:slide_to_act/slide_to_act.dart';

Widget swipeButton(String title, dynamic onSubmit) {
  return Builder(
    builder: (context) {
      final GlobalKey<SlideActionState> key = GlobalKey();
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SlideAction(
          outerColor: MyColors.black,
          innerColor: MyColors.primary,
          elevation: 0,
          key: key,
          submittedIcon: const Icon(
            FontAwesomeIcons.check,
            color: MyColors.white,
          ),
          onSubmit: () {
            Future.delayed(const Duration(milliseconds: 300), () {
              key.currentState!.reset();
              onSubmit;
            });
          },
          alignment: Alignment.centerRight,
          sliderButtonIcon: const Icon(
            Icons.double_arrow_rounded,
            color: MyColors.white,
          ),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      );
    },
  );
}
