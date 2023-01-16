import 'package:smn_delivery_app/data/order/model/order_status.dart';

import 'model/order.dart';

abstract class OrderInterFace{
  Future<List<Order>> getOrders();
  Future<Order> cancelOrder(Order order);
  Future<List<OrderStatus>> getOrderStatus();

}