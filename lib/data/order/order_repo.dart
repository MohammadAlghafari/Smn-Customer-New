import 'package:smn_delivery_app/data/order/model/order_status.dart';
import 'package:smn_delivery_app/data/order/api/order_api.dart';
import 'package:smn_delivery_app/data/order/model/order.dart';

import 'order_interface.dart';

class OrderRepo implements OrderInterFace{

  OrderApi orderApi;

  OrderRepo({required this.orderApi}) {}

  @override
  Future<List<Order>> getOrders() {
    return orderApi.getOrders();
  }

  @override
  Future<Order> cancelOrder(Order order) {
    return orderApi.cancelOrder(order);
  }
  @override
  Future<List<OrderStatus>> getOrderStatus() {
    return orderApi.getOrderStatus();
  }



}