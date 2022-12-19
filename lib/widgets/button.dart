import 'package:Erdenet24/utils/styles.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String? text;
  final Color bgColor;
  final bool isActive;
  final double height;
  final Widget? prefix;
  final Widget? suffix;
  final Color textColor;
  final bool isFullWidth;
  final double? elevation;
  final double textFontSize;
  final double cornerRadius;
  final Color borderColor;
  final Function()? onPressed;
  final dynamic isLoading;
  final Color inActiveBtnColor;
  final Color disabledTextColor;
  final FontWeight textFontWeight;
  final bool hasBorder;

  const CustomButton(
      {Key? key,
      this.text,
      this.prefix,
      this.suffix,
      this.borderColor = MyColors.primary,
      this.onPressed,
      this.elevation = 0,
      this.height = 36,
      this.isLoading = false,
      this.hasBorder = false,
      this.isActive = true,
      this.textFontSize = MyFontSizes.normal,
      this.cornerRadius = 25,
      this.isFullWidth = true,
      this.textColor = Colors.white,
      this.bgColor = MyColors.primary,
      this.disabledTextColor = Colors.white,
      this.textFontWeight = FontWeight.normal,
      this.inActiveBtnColor = MyColors.grey})
      : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: MaterialButton(
        elevation: widget.elevation,
        color: widget.bgColor,
        disabledColor: widget.inActiveBtnColor,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        onPressed: widget.isActive ? widget.onPressed : null,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: widget.hasBorder ? 0.6 : 0,
            color: widget.hasBorder ? widget.borderColor : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(widget.cornerRadius),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.prefix != null) widget.prefix!,
            _generateBody(),
            if (widget.suffix != null) widget.suffix!,
          ],
        ),
      ),
    );
  }

  Widget _generateBody() {
    return widget.isFullWidth
        ? Expanded(child: Center(child: _generateText()))
        : _generateText();
  }

  Widget _generateText() {
    return widget.isLoading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              color: MyColors.primary,
              strokeWidth: 1,
            ),
          )
        : Text(
            widget.text ?? "",
            style: TextStyle(
              fontSize: widget.textFontSize,
              fontWeight: widget.textFontWeight,
              color:
                  widget.isActive ? widget.textColor : widget.disabledTextColor,
            ),
          );
  }
}
