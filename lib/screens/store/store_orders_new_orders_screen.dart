import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/loading.dart';
import 'package:Erdenet24/controller/store_controller.dart';
import 'package:Erdenet24/screens/store/store_orders_to_delivery_view.dart';

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
    return Obx(
      () => _storeCtx.filteredOrderList.isEmpty
          ? const CustomLoadingIndicator(text: "Захиалга байхгүй байна")
          : ListView.separated(
              separatorBuilder: (context, index) {
                return const SizedBox(height: 7);
              },
              physics: const BouncingScrollPhysics(),
              itemCount: _storeCtx.filteredOrderList.length,
              itemBuilder: (context, index) {
                var data = _storeCtx.filteredOrderList[index];
                return _cardListItem(data);
              },
            ),
    );
  }

  Widget _cardListItem(dynamic data) {
    return GestureDetector(
      onTap: (() {
        storeOrdersToDeliveryView(context, data);
      }),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 12),
        child: ListTile(
          title: CustomText(
            text: "${data["orderId"]}",
            fontSize: 14,
          ),
          subtitle: CustomText(
            text: data["orderTime"],
            fontSize: 12,
          ),
          // trailing: _itemStatus(data["orderStatus"] == "sent"),
          // trailing: _remainingTimeIndicator(),
        ),
      ),
    );
  }

  Widget _remainingTimeIndicator() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            value: 0.7,
            color: MyColors.primary,
            backgroundColor: MyColors.background,
            strokeWidth: 1.5,
          ),
        ),
        CustomText(
          text: "15:23",
          fontSize: 12,
        )
      ],
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
