import 'package:Erdenet24/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
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
            padding: const EdgeInsets.only(left: 12),
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
  final String errorText;
  final dynamic onEditingComplete;
  final bool formatThousands;

  const CustomTextField(
      {Key? key,
      this.hintText = "",
      this.onSubmitted,
      this.onEditingComplete,
      this.maxLength = 100,
      this.focusNode,
      this.suffixButton,
      this.keyboardType = TextInputType.text,
      this.textInputAction,
      this.height = 42,
      this.onChanged,
      this.borderRadius = 50,
      this.controller,
      this.obscureText,
      this.iconColor = MyColors.black,
      this.leadingIcon = IconlyLight.search,
      this.errorText = "",
      this.formatThousands = false,
      this.autoFocus = false});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          width: 1,
          color:
              widget.errorText.isEmpty ? MyColors.background : MyColors.primary,
        ),
      ),
      child: TextField(
        onSubmitted: widget.onSubmitted,
        textInputAction: widget.textInputAction,
        focusNode: widget.focusNode,
        inputFormatters: [
          widget.formatThousands
              ? ThousandsFormatter()
              : LengthLimitingTextInputFormatter(widget.maxLength),
        ],
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
        scrollPadding: EdgeInsets.only(bottom: 30),
        style: const TextStyle(
          fontSize: MyFontSizes.large,
          color: MyColors.black,
        ),
        cursorColor: MyColors.primary,
        cursorWidth: 1,
        onChanged: (value) {
          if (widget.onChanged != null) widget.onChanged!(value);
          setState(() {});
        },
      ),
    );
  }
}

class ThousandsFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat('#,###');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final formattedValue = _formatter
        .format(double.tryParse(newValue.text.replaceAll(',', '')) ?? 0);

    final selectionOffset = newValue.selection.baseOffset +
        (formattedValue.length - newValue.text.length);

    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: selectionOffset),
    );
  }
}
