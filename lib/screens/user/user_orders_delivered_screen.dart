import 'package:Erdenet24/screens/user/user_products_screen_new.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/loading.dart';
import 'package:get/get.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/controller/user_controller.dart';

class UserOrdersListScreen extends StatefulWidget {
  const UserOrdersListScreen({super.key});

  @override
  State<UserOrdersListScreen> createState() => _UserOrdersListScreenState();
}

class _UserOrdersListScreenState extends State<UserOrdersListScreen> {
  final _userCtx = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _userCtx.filteredOrderList.isEmpty
          ? const CustomLoadingIndicator(text: "Захиалга байхгүй байна")
          : ListView.separated(
              separatorBuilder: (context, index) {
                return Container(height: 12);
              },
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: _userCtx.filteredOrderList.length,
              itemBuilder: (context, index) {
                var data = _userCtx.filteredOrderList[index];
                return _listItem(data);
              }),
    );
  }

  Widget _listItem(data) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: CustomInkWell(
        onTap: () {
          userOrdersDetailView(context, data);
        },
        child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _item("Захиалгын код:", data["orderId"].toString()),
                _item("Хаяг:", data["address"]),
                _item("Утас:", data["phone"]),
                _item(
                  "Нийт үнэ:",
                  convertToCurrencyFormat(double.parse(data["totalAmount"]),
                      locatedAtTheEnd: true, toInt: true),
                )
              ],
            )),
      ),
    );
  }

  Widget _item(String title, String value) {
    return Row(
      children: [
        SizedBox(
          width: Get.width * .3,
          child: CustomText(
            text: title,
            fontSize: 12,
          ),
        ),
        Expanded(
          child: CustomText(
            text: value,
            overflow: TextOverflow.ellipsis,
            fontSize: 12,
            textAlign: TextAlign.end,
          ),
        )
      ],
    );
  }
}

void userOrdersDetailView(context, data) {
  showModalBottomSheet(
    backgroundColor: MyColors.white,
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.9,
        child: SafeArea(
          minimum: const EdgeInsets.symmetric(vertical: 24),
          child: Stack(
            children: [
              Column(
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
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
