import 'package:Erdenet24/screens/user/home/product_screen.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconly/iconly.dart';
import 'package:percent_indicator/percent_indicator.dart';

class UserOrderActiveScreen extends StatefulWidget {
  final dynamic data;
  const UserOrderActiveScreen({
    this.data,
    super.key,
  });

  @override
  State<UserOrderActiveScreen> createState() => _UserOrderActiveScreenState();
}

class _UserOrderActiveScreenState extends State<UserOrderActiveScreen> {
  List statusList = ["Баталгаажсан", "Бэлтгэж байна", 'Хүргэж байна'];
  PageController pageController = PageController();
  int step = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: CustomHeader(
        withTabBar: true,
        customLeading: Container(),
        centerTitle: true,
        customTitle: const CustomText(
          text: "Захиалга",
          color: MyColors.black,
          fontSize: 16,
        ),
        customActions: Container(),
        body: Column(
          children: [
            _stepper(),
            Expanded(
                child: PageView(
              onPageChanged: (value) {
                setState(() {
                  step = value;
                });
                pageController.animateToPage(
                  value,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.bounceInOut,
                );
              },
              controller: pageController,
              children: [
                step0(),
                step0(),
                step1(),
                step2(),
              ],
            ))
          ],
        ),
      ),
    );
  }

  Widget _stepper() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearPercentIndicator(
            backgroundColor: MyColors.black,
            alignment: MainAxisAlignment.center,
            barRadius: const Radius.circular(12),
            lineHeight: 8.0,
            percent: step == 0
                ? 0
                : step == 1
                    ? 0.25
                    : step == 2
                        ? 0.5
                        : 1,
            progressColor: MyColors.primary,
            curve: Curves.bounceIn,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _buildRowList(),
          )
        ],
      ),
    );
  }

  List<Widget> _buildRowList() {
    List<Widget> lines = [];
    statusList.asMap().forEach((index, value) {
      bool active = index + 1 == step;
      lines.add(Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            text: value,
            color: active ? MyColors.black : MyColors.gray,
          ),
          const SizedBox(height: 4),
          active
              ? CustomText(
                  text: "2022-12-28 09:30",
                  color: MyColors.gray,
                  fontSize: 10,
                )
              : Container(),
        ],
      ));
    });
    return lines;
  }

  Widget step0() {
    return Column(
      children: [
        _orderInfoView(),
        const Image(image: AssetImage("assets/images/png/app/banner1.jpg"))
      ],
    );
  }

  Widget step1() {
    return Column(
      children: [
        _orderInfoView(),
        const Image(image: AssetImage("assets/images/png/app/banner1.jpg"))
      ],
    );
  }

  Widget step2() {
    return Column(
      children: [
        _orderInfoView(),
        Expanded(
          child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(37.42796133580664, -122.085749655962),
              zoom: 14.4746,
            ),
            onMapCreated: (GoogleMapController controller) {},
          ),
        ),
      ],
    );
  }

  Widget _orderInfoView() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Container(
            height: 7,
            color: MyColors.fadedGrey,
          ),
          CustomInkWell(
            onTap: () => userActiveOrderDetailView(context, widget.data),
            borderRadius: BorderRadius.zero,
            child: SizedBox(
              height: Get.height * .09,
              child: Center(
                child: ListTile(
                  leading: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                          text: "Захиалгын дугаар: ${widget.data["orderId"]}"),
                      const SizedBox(height: 4),
                      CustomText(
                        text: widget.data["orderTime"],
                        color: MyColors.gray,
                        fontSize: 10,
                      )
                    ],
                  ),
                  trailing: Icon(IconlyLight.arrow_right_2),
                ),
              ),
            ),
          ),
          Container(
            height: 7,
            color: MyColors.fadedGrey,
          ),
        ],
      ),
    );
  }
}

void userActiveOrderDetailView(context, data) {
  showModalBottomSheet(
    backgroundColor: MyColors.white,
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.9,
        child: SafeArea(
          minimum: const EdgeInsets.symmetric(vertical: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CustomText(
                  text: "Захиалгын код:",
                  fontSize: 14,
                  color: MyColors.gray,
                ),
                CustomText(
                  text: data["orderId"].toString(),
                  fontSize: 16,
                  color: MyColors.black,
                ),
                const SizedBox(height: 12),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) {
                    return Container(
                      height: 7,
                      color: MyColors.fadedGrey,
                    );
                  },
                  shrinkWrap: true,
                  itemCount: data["products"].length,
                  itemBuilder: (context, index) {
                    var product = data["products"][index];
                    return Container(
                        height: Get.height * .09,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        color: MyColors.white,
                        child: Center(
                          child: ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            minLeadingWidth: Get.width * .15,
                            leading: Container(
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12)),
                                child: CachedImage(
                                    image:
                                        "${URL.AWS}/products/${product["id"]}/small/1.png")),
                            title: CustomText(
                              text: product["name"],
                              fontSize: 14,
                            ),
                            subtitle: CustomText(
                                text: convertToCurrencyFormat(
                              int.parse(product["price"]),
                              toInt: true,
                              locatedAtTheEnd: true,
                            )),
                            trailing: CustomText(
                                text: "${product["quantity"]} ширхэг"),
                          ),
                        ));
                  },
                ),
                Container(
                  height: 7,
                  color: MyColors.fadedGrey,
                ),
                SizedBox(
                  height: Get.height * .09,
                  child: Center(
                    child: ListTile(
                      leading: const CustomText(text: "Нийт үнэ:"),
                      trailing: CustomText(
                        text: convertToCurrencyFormat(
                          data["totalAmount"],
                          toInt: true,
                          locatedAtTheEnd: true,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
