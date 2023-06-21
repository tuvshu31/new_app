import 'package:iconly/iconly.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/utils/styles.dart';

class CustomCart extends StatelessWidget {
  final int count;
  const CustomCart({
    super.key,
    this.count = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            IconlyLight.buy,
            size: 20,
          ),
        ),
        count != 0
            ? Positioned(
                right: 4,
                top: 4,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: MyColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    count.toString(),
                    style: const TextStyle(
                      fontSize: 8,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
