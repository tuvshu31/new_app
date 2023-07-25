import 'package:Erdenet24/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:slide_to_act/slide_to_act.dart';

class CustomSlideButton extends StatelessWidget {
  final String text;
  final dynamic onSubmit;
  const CustomSlideButton({
    required this.text,
    required this.onSubmit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SlideAction(
      outerColor: MyColors.black,
      innerColor: MyColors.primary,
      elevation: 0,
      submittedIcon: const Icon(
        FontAwesomeIcons.check,
        color: MyColors.white,
      ),
      onSubmit: onSubmit,
      alignment: Alignment.centerRight,
      sliderButtonIcon: const Icon(
        Icons.double_arrow_rounded,
        color: MyColors.white,
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    );
  }
}
