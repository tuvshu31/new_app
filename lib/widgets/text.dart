import 'package:Erdenet24/utils/styles.dart';
import 'package:flutter/material.dart';

class CustomText extends StatefulWidget {
  final String text;
  final FontWeight? fontWeight;
  final Color? color;
  final double? fontSize;
  final TextAlign? textAlign;
  final double? height;
  final dynamic overflow;
  final bool isLowerCase;
  final bool isUpperCase;
  final bool isUnderLined;

  const CustomText(
      {Key? key,
      required this.text,
      this.fontSize,
      this.isUpperCase = false,
      this.isLowerCase = false,
      this.isUnderLined = false,
      this.height,
      this.overflow,
      this.textAlign,
      this.fontWeight,
      this.color})
      : super(key: key);

  @override
  State<CustomText> createState() => _CustomTextState();
}

class _CustomTextState extends State<CustomText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.isUpperCase
          ? widget.text.toUpperCase()
          : widget.isLowerCase
              ? widget.text.toLowerCase()
              : capitalize(widget.text),
      textAlign: widget.textAlign,
      overflow: widget.overflow,
      style: TextStyle(
          fontWeight: widget.fontWeight,
          height: widget.height,
          color: widget.color,
          fontSize: widget.fontSize,
          decoration: widget.isUnderLined
              ? TextDecoration.underline
              : TextDecoration.none),
    );
  }
}
