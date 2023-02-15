import 'dart:developer';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/screens/store/orders/store_orders_notification_view.dart';
import 'package:Erdenet24/screens/store/orders/store_orders_set_time_view.dart';
import 'package:Erdenet24/utils/shimmers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/loading.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';

class StoreOrdersNewOrdersScreen extends StatefulWidget {
  const StoreOrdersNewOrdersScreen({super.key});

  @override
  State<StoreOrdersNewOrdersScreen> createState() =>
      _StoreOrdersNewOrdersScreenState();
}

class _StoreOrdersNewOrdersScreenState
    extends State<StoreOrdersNewOrdersScreen> {
  dynamic _newOrdersList = [];
  bool fetching = false;
  @override
  void initState() {
    super.initState();
    fetchNewOrders();
  }

  void fetchNewOrders() async {
    fetching = true;
    dynamic response =
        await RestApi().getStoreOrders(RestApiHelper.getUserId(), {});
    dynamic d = Map<String, dynamic>.from(response);
    if (d["success"]) {
      _newOrdersList = d["data"];
    }
    fetching = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _newOrdersList.isEmpty && !fetching
        ? const CustomLoadingIndicator(text: "Шинэ захиалга байхгүй байна")
        : ListView.separated(
            separatorBuilder: (context, index) {
              return Container(height: 8);
            },
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: _newOrdersList.isEmpty ? 4 : _newOrdersList.length,
            itemBuilder: (context, index) {
              if (_newOrdersList.isEmpty) {
                return MyShimmers().listView2();
              } else {
                return _cardListItem(index);
              }
            });
  }

  Widget _cardListItem(int index) {
    var data = _newOrdersList[index];
    return GestureDetector(
      onTap: (() {
        // _showOrderDetauls(index);
        // showOrdersSetTime(context);
        showOrdersNotificationView(context);
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
          trailing: _itemStatus(data["orderStatus"] == "sent"),
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
