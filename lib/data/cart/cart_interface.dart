import 'package:smn_delivery_app/data/home/model/payment.dart';
import 'package:smn_delivery_app/data/order/model/order.dart';

import 'model/cart_item.dart';
import 'model/coupon.dart';

abstract class CartInterface {
  Future<List<CartItem>> getCart();

  Future<int> getCartCount();

  Future<CartItem> addCart(CartItem cart, bool reset);

  Future<CartItem?> updateCart(CartItem cart);

  Future<bool> removeCart(CartItem cart);

  Future<double> getDeliveryFee({required String restaurantId});

  Future<Coupon?> verifyCoupon(String code);

  Future<Order?> addOrder(Order order, Payment payment);
}
