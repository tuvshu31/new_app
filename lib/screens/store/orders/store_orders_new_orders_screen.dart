import 'dart:developer';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/controller/store_controller.dart';
import 'package:Erdenet24/screens/store/orders/store_orders_notification_view.dart';
import 'package:Erdenet24/screens/store/orders/store_orders_to_delivery_view.dart';
import 'package:Erdenet24/utils/shimmers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/loading.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreOrdersNewOrdersScreen extends StatefulWidget {
  const StoreOrdersNewOrdersScreen({super.key});

  @override
  State<StoreOrdersNewOrdersScreen> createState() =>
      _StoreOrdersNewOrdersScreenState();
}

class _StoreOrdersNewOrdersScreenState
    extends State<StoreOrdersNewOrdersScreen> {
  final _storeCtx = Get.put(StoreController());

  @override
  Widget build(BuildContext context) {
    return _storeCtx.orderList.isEmpty && !_storeCtx.fetching.value
        ? const CustomLoadingIndicator(text: "Шинэ захиалга байхгүй байна")
        : ListView.separated(
            separatorBuilder: (context, index) {
              return Container(height: 8);
            },
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount:
                _storeCtx.orderList.isEmpty ? 4 : _storeCtx.orderList.length,
            itemBuilder: (context, index) {
              if (_storeCtx.orderList.isEmpty) {
                return MyShimmers().listView2();
              } else {
                return _cardListItem(index);
              }
            });
  }

  Widget _cardListItem(int index) {
    var data = _storeCtx.orderList[index];
    return GestureDetector(
      onTap: (() {
        // _showOrderDetauls(index);
        // showOrdersSetTime(context);
        storeOrdersToDeliveryView(context, _storeCtx.orderList[index]);
      }),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 12),
        child: ListTile(
          title: CustomText(
            text: data["orderId"].toString(),
            fontSize: 14,
          ),
          subtitle: CustomText(
            text: data["orderTime"],
            fontSize: 12,
          ),
          // trailing: _itemStatus(data["orderStatus"] == "sent"),
        ),
      ),
    );
  }

  Widget _itemStatus(bool isNew) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          width: 1,
          color: MyColors.primary,
        ),
      ),
      child: const CustomText(
        text: "Шинэ",
        color: MyColors.primary,
        fontSize: 10,
      ),
    );
  }
}
