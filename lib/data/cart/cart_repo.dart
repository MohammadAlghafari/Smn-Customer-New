import 'package:smn_delivery_app/data/cart/api/cart_api.dart';
import 'package:smn_delivery_app/data/cart/cart_interface.dart';
import 'package:smn_delivery_app/data/cart/model/cart_item.dart';
import 'package:smn_delivery_app/data/home/model/payment.dart';
import 'package:smn_delivery_app/data/order/model/order.dart';

import 'model/coupon.dart';

class CartRepo implements CartInterface{
  CartApi cartApi;
  CartRepo({required this.cartApi});
  @override
  Future<CartItem> addCart(CartItem cart, bool reset) {
    return cartApi.addCart(cart, reset);
  }

  @override
  Future<List<CartItem>> getCart() {
    return cartApi.getCart();

  }

  @override
  Future<int> getCartCount() {
    return cartApi.getCartCount();

  }

  @override
  Future<bool> removeCart(CartItem cart) {
    return cartApi.removeCart(cart);

  }

  @override
  Future<CartItem?> updateCart(CartItem cart) {
    return cartApi.updateCart(cart);
  }
  @override
  Future<double> getDeliveryFee({required String restaurantId}){
    return cartApi.getDeliveryFee(restaurantId: restaurantId);
  }
  @override
  Future<Coupon?> verifyCoupon(String code){
    return cartApi.verifyCoupon(code);
  }
  @override
  Future<Order?> addOrder(Order order, Payment payment)async {
    return cartApi.addOrder(order, payment);
  }
}