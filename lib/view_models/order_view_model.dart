import 'package:flutter/material.dart';
import 'package:smn_delivery_app/data/order/model/order.dart';
import 'package:smn_delivery_app/data/order/model/order_status.dart';
import 'package:smn_delivery_app/data/order/order_repo.dart';

class OrderViewModel extends ChangeNotifier {
  bool loadingData = true;
  OrderRepo orderRepo;
  List<Order> orders = <Order>[];
  List<OrderStatus> orderStatus = <OrderStatus>[];

  OrderViewModel({required this.orderRepo}) {
    listenForOrders();
    listenForOrderStatus();
  }

  Future<void> listenForOrders() async {
    loadingData = true;
    orders = await orderRepo.getOrders();
    loadingData = false;
    notifyListeners();
  }

  void doCancelOrder(Order order) {
    orderRepo
        .cancelOrder(order)
        .then((value) {
          orders[orders.indexWhere((element) => element.id == order.id)]
              .active = false;
        })
        .catchError((e) {})
        .whenComplete(() {
          notifyListeners();
        });
  }

  Future<void> listenForOrderStatus() async {
    orderStatus = await orderRepo.getOrderStatus();
  }

  Future<void> refreshOrders() async {
    orders.clear();
    orderStatus.clear();
    await listenForOrders();
    await listenForOrderStatus();
  }
}
