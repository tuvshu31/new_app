import 'package:Erdenet24/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class CustomSearchBar extends StatefulWidget {
  final String? hintText;
  final bool? obscureText;
  final void Function()? onSubmitted;
  final void Function()? onChanged;
  final TextEditingController? controller;
  final bool autoFocus;

  const CustomSearchBar(
      {Key? key,
      this.hintText,
      this.onSubmitted,
      this.onChanged,
      this.controller,
      this.obscureText,
      this.autoFocus = false})
      : super(key: key);

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: MyColors.fadedGrey,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 12),
            child: const Center(
              child: Icon(
                IconlyLight.search,
                color: MyColors.primary,
                size: 20,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              textInputAction: TextInputAction.search,
              autofocus: widget.autoFocus,
              controller: widget.controller,
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
              onSubmitted: (value) {
                if (widget.onSubmitted != null) widget.onSubmitted!();
              },
              onChanged: (value) {
                if (widget.onChanged != null) widget.onChanged!();
              },
            ),
          ),
          // if (_searchText.isNotEmpty)
          //   // Padding(
          //   padding: const EdgeInsets.only(right: 8),
          //   child: GestureDetector(
          //     child: const Icon(
          //       Icons.close,
          //       color: MyColors.primary,
          //       size: 20,
          //     ),
          //     onTap: () {
          //       _searchText = '';
          //       if (widget.onChanged != null) widget.onChanged!();
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
