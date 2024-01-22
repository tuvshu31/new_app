import 'package:Erdenet24/api/dio_requests/driver.dart';
import 'package:get/get.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/utils/shimmers.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:expandable/expandable.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/header.dart';

class DriverHelpScreen extends StatefulWidget {
  const DriverHelpScreen({super.key});

  @override
  State<DriverHelpScreen> createState() => _DriverHelpScreenState();
}

class _DriverHelpScreenState extends State<DriverHelpScreen> {
  List help = [];
  bool loading = false;
  @override
  void initState() {
    super.initState();
    getDriverHelpContent();
  }

  void getDriverHelpContent() async {
    loading = true;
    dynamic getDriverHelpContent = await DriverApi().getDriverHelpContent();
    loading = false;
    if (getDriverHelpContent != null) {
      dynamic response = Map<String, dynamic>.from(getDriverHelpContent);
      if (response["success"]) {
        help = response["data"];
      } else {
        customSnackbar(ActionType.error, "Алдаа гарлаа", 2);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      title: "Тусламж",
      customActions: Container(),
      body: loading
          ? listShimmerWidget()
          : ExpandableTheme(
              data: const ExpandableThemeData(
                useInkWell: true,
              ),
              child: ListView.separated(
                itemCount: help.length,
                itemBuilder: (context, index) {
                  var item = help[index];
                  return _item(item);
                },
                separatorBuilder: (context, index) {
                  return Container();
                },
              )),
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
