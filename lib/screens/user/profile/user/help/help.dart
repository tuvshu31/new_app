import 'dart:developer';
import 'dart:math' as math;
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

const loremIpsum =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

class HelpView extends StatefulWidget {
  const HelpView({super.key});

  @override
  State<HelpView> createState() => _HelpViewState();
}

class _HelpViewState extends State<HelpView> {
  List faqList = [
    {"question": "Төлбөрөө хэрхэн төлөх вэ?", "answer": loremIpsum},
    {
      "question": "Миний захиалга хаана явж байгааг яаж мэдэх вэ?",
      "answer": loremIpsum
    },
    {"question": "Захиалгаа буцаах боломжтой юу?", "answer": loremIpsum},
    {"question": "И-баримт өгдөг үү?", "answer": loremIpsum}
  ];

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      title: "Тусламж",
      customActions: Container(),
      body: ExpandableTheme(
        data: const ExpandableThemeData(
          useInkWell: true,
        ),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [for (var i in faqList) _item(i)],
        ),
      ),
    );
  }

  Widget _item(dynamic element) {
    return ExpandableNotifier(
        child: ScrollOnExpand(
      scrollOnExpand: true,
      scrollOnCollapse: false,
      child: ExpandablePanel(
        theme: const ExpandableThemeData(
          headerAlignment: ExpandablePanelHeaderAlignment.center,
          tapBodyToCollapse: true,
          hasIcon: false,
        ),
        header: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: Get.width * .075),
          dense: true,
          minLeadingWidth: Get.width * .07,
          leading: Icon(
            IconlyLight.info_square,
            color: MyColors.black,
            size: 20,
          ),
          title: CustomText(
            text: element["question"],
            fontSize: 14,
          ),
        ),
        collapsed: Container(),
        expanded: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            for (var _ in Iterable.generate(5))
              Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    loremIpsum,
                    softWrap: true,
                    overflow: TextOverflow.fade,
                  )),
          ],
        ),
        builder: (_, collapsed, expanded) {
          return Expandable(
            collapsed: collapsed,
            expanded: expanded,
            theme: const ExpandableThemeData(crossFadePoint: 0),
          );
        },
      ),
    ));
  }
}
