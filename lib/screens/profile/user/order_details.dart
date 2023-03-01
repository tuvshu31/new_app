import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/screens/user/home/product_screen.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetailsOld extends StatefulWidget {
  const OrderDetailsOld({Key? key}) : super(key: key);

  @override
  State<OrderDetailsOld> createState() => _OrderDetailsOldState();
}

class _OrderDetailsOldState extends State<OrderDetailsOld> {
  final _incoming = Get.arguments;
  dynamic _data = [];
  final Widget _divider = const Divider(height: 0.7, color: MyColors.grey);
  @override
  void initState() {
    super.initState();
    getOrderProducts();
  }

  void getOrderProducts() async {
    var _query = {
      "orderId": _incoming["orderId"],
    };
    dynamic response = await RestApi().getOrderProducts(_query);
    dynamic d = Map<String, dynamic>.from(response);
    var e = d["data"].toList();
    dynamic _productIds = [];
    for (dynamic i in e) {
      _productIds.add(i["productId"]);
    }
    var query = {"id": _productIds};
    dynamic a = await RestApi().getProducts(query);
    dynamic p = Map<String, dynamic>.from(a);
    if (p["success"]) {
      setState(() {
        _data = p["data"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      title: "Захиалгын дэлгэрэнгүй",
      customActions: Container(),
      body: _savedList(),
    );
  }

  Widget _savedList() {
    return ListView.separated(
      separatorBuilder: (context, index) => _divider,
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: _data.length,
      itemBuilder: (context, index) {
        var data = _data[index];
        return Container(
          height: Get.height * .14,
          color: MyColors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CachedImage(image: "${URL.AWS}/products/${data["_id"]}"),
              ),
              SizedBox(
                width: Get.width * .6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: "${data['name']}",
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    CustomText(
                      text: convertToCurrencyFormat(
                        double.parse(data["price"]),
                        toInt: true,
                        locatedAtTheEnd: true,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
