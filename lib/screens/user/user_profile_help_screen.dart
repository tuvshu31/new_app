import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:iconly/iconly.dart';
import 'package:expandable/expandable.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/header.dart';

class UserProfileHelpScreen extends StatefulWidget {
  const UserProfileHelpScreen({super.key});

  @override
  State<UserProfileHelpScreen> createState() => _UserProfileHelpScreenState();
}

class _UserProfileHelpScreenState extends State<UserProfileHelpScreen> {
  List faqList = [
    {
      "question": "Төлбөрөө хэрхэн төлөх вэ?",
      "answer":
          "Хэрэглэгч та захиалгын төлбөрөө бэлэн мөнгөөр төлөх боломжгүй харин бүх төрлийн интернэт банк болон Qpay ашиглан төлбөрөө төлөх боломжтой."
    },
    {
      "question": "Миний захиалга хаана явж байгааг яаж мэдэх вэ?",
      "answer":
          "Хэрэглэгч та өөрийн захиалгын байршлыг мэдэхийг хүсвэл лавлах утас болох 99352223 болон профайл цэснээс захиалга дотроос харах боломжтой."
    },
    {
      "question": "Захиалгаа буцаах боломжтой юу?",
      "answer":
          "Таны захиалгыг байгууллага хүлээж авсанаас хойш өөрчлөх, цуцлах боломжгүй. Тиймээс захиалгаа баталгаажуулахаас өмнө сайтар нягтална уу."
    },
    {
      "question": "И-баримт өгдөг үү?",
      "answer": "Таны худалдан авсан хоолны баримт нь танд хүргэлттэй хамт очно"
    }
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
          leading: const Icon(
            IconlyLight.info_circle,
            color: MyColors.black,
            size: 20,
          ),
          title: CustomText(
            text: element["question"],
            fontSize: 14.25,
          ),
        ),
        collapsed: Container(),
        expanded: Container(
            margin: const EdgeInsets.only(
              right: 24,
              left: 24,
              bottom: 12,
            ),
            child: CustomText(
              text: element["answer"],
              textAlign: TextAlign.justify,
            )),
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
