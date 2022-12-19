import 'package:Erdenet24/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconly/iconly.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CustomSearchField extends StatefulWidget {
  final String? hintText;
  final bool? obscureText;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final IconData leadingIcon;
  final bool autoFocus;
  final Color iconColor;
  final double height;
  final double borderRadius;

  const CustomSearchField(
      {Key? key,
      this.hintText,
      this.height = 40,
      this.onChanged,
      this.borderRadius = 50,
      this.controller,
      this.obscureText,
      this.iconColor = MyColors.black,
      this.leadingIcon = IconlyLight.search,
      this.autoFocus = false})
      : super(key: key);

  @override
  _CustomSearchFieldState createState() => _CustomSearchFieldState();
}

class _CustomSearchFieldState extends State<CustomSearchField> {
  String _searchText = '';
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = widget.controller ?? TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        color: MyColors.fadedGrey,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.only(left: 12),
            child: Center(
              child: Icon(
                widget.leadingIcon,
                color: widget.iconColor,
                size: 20,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              autofocus: widget.autoFocus,
              controller: _controller,
              obscureText: widget.obscureText ?? false,
              decoration: InputDecoration(
                counterText: '',
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                hintText: widget.hintText,
                hintStyle: const TextStyle(
                  fontSize: MyFontSizes.normal,
                  color: MyColors.grey,
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: MyDimentions.borderWidth,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: MyDimentions.borderWidth,
                  ),
                ),
                disabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: MyDimentions.borderWidth,
                  ),
                ),
              ),
              style: const TextStyle(
                fontSize: MyFontSizes.large,
                color: MyColors.black,
              ),
              cursorColor: MyColors.primary,
              cursorWidth: 1,
              onChanged: (value) {
                _searchText = value;
                if (widget.onChanged != null) widget.onChanged!(value);
                setState(() {});
              },
            ),
          ),
          if (_searchText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                child: const Icon(
                  Icons.close,
                  color: MyColors.primary,
                  size: 20,
                ),
                onTap: () {
                  _searchText = '';
                  _controller.text = '';
                  if (widget.onChanged != null) widget.onChanged!('');
                  setState(() {});
                },
              ),
            ),
        ],
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  final String hintText;
  final bool? obscureText;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final IconData leadingIcon;
  final dynamic suffixButton;
  final bool autoFocus;
  final Color iconColor;
  final double height;
  final double borderRadius;
  final dynamic keyboardType;
  final int maxLength;
  final dynamic focusNode;
  final dynamic textInputAction;
  final dynamic onSubmitted;

  const CustomTextField(
      {Key? key,
      this.hintText = "",
      this.onSubmitted,
      this.maxLength = 100,
      this.focusNode,
      this.suffixButton,
      this.keyboardType = TextInputType.text,
      this.textInputAction,
      this.height = 40,
      this.onChanged,
      this.borderRadius = 50,
      this.controller,
      this.obscureText,
      this.iconColor = MyColors.black,
      this.leadingIcon = IconlyLight.search,
      this.autoFocus = false});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        // color: MyColors.fadedGrey,
        border: Border.all(
          width: 0.7,
          color: MyColors.grey,
        ),
      ),
      child: TextField(
        onSubmitted: widget.onSubmitted,
        textInputAction: widget.textInputAction,
        focusNode: widget.focusNode,
        inputFormatters: [LengthLimitingTextInputFormatter(widget.maxLength)],
        keyboardType: widget.keyboardType,
        autofocus: widget.autoFocus,
        controller: widget.controller,
        obscureText: widget.obscureText ?? false,
        decoration: InputDecoration(
          hintText: widget.hintText,
          suffixIcon: widget.suffixButton ?? null,
          counterText: '',
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          hintStyle: const TextStyle(
            fontSize: MyFontSizes.normal,
            color: MyColors.grey,
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.transparent,
              width: MyDimentions.borderWidth,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.transparent,
              width: MyDimentions.borderWidth,
            ),
          ),
          disabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.transparent,
              width: MyDimentions.borderWidth,
            ),
          ),
        ),
        style: const TextStyle(
          fontSize: MyFontSizes.large,
          color: MyColors.black,
        ),
        cursorColor: MyColors.primary,
        cursorWidth: 1,
        onChanged: (value) {
          _searchText = value;
          if (widget.onChanged != null) widget.onChanged!(value);
          setState(() {});
        },
      ),
    );
  }
}

class CustomPinCodeTextField extends StatefulWidget {
  final dynamic onChanged;
  final dynamic onCompleted;
  const CustomPinCodeTextField({this.onCompleted, this.onChanged, super.key});

  @override
  State<CustomPinCodeTextField> createState() => _CustomPinCodeTextFieldState();
}

class _CustomPinCodeTextFieldState extends State<CustomPinCodeTextField> {
  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      autoFocus: true,
      appContext: context,
      cursorColor: MyColors.primary,
      cursorWidth: 1,
      length: 6,
      obscureText: false,
      animationType: AnimationType.fade,
      keyboardType: TextInputType.number,
      textStyle: const TextStyle(fontSize: 16),
      pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(12),
          fieldHeight: 48,
          fieldWidth: 40,
          activeFillColor: Colors.white,
          inactiveFillColor: MyColors.white,
          selectedFillColor: MyColors.white,
          borderWidth: 1,
          activeColor: MyColors.grey,
          inactiveColor: MyColors.grey,
          selectedColor: MyColors.primary),
      animationDuration: const Duration(milliseconds: 300),
      enableActiveFill: true,
      // errorAnimationController: errorController,
      // controller: textEditingController,
      onCompleted: widget.onCompleted,
      onChanged: widget.onChanged,
      beforeTextPaste: (text) {
        print("Allowing to paste $text");
        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
        //but you can show anything you want here, like your pop up saying wrong paste format or etc
        return true;
      },
    );
  }
}
