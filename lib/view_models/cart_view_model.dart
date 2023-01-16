import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:smn_delivery_app/const/widgets.dart';
import 'package:smn_delivery_app/data/auth/model/address.dart';
import 'package:smn_delivery_app/data/cart/cart_repo.dart';
import 'package:smn_delivery_app/data/cart/model/cart_item.dart';
import 'package:smn_delivery_app/data/cart/model/coupon.dart';
import 'package:smn_delivery_app/data/home/model/food.dart';
import 'package:smn_delivery_app/data/home/model/food_order.dart';
import 'package:smn_delivery_app/data/home/model/payment.dart';
import 'package:smn_delivery_app/data/order/model/order.dart';
import 'package:smn_delivery_app/data/order/model/order_status.dart';
import 'package:smn_delivery_app/smn_customer.dart';
import 'package:smn_delivery_app/view_models/auth_view_model.dart';
import 'package:smn_delivery_app/view_models/order_view_model.dart';

class CartViewModel extends ChangeNotifier {
  List<CartItem> cartItems = [];
  double taxAmount = 0.0;
  double deliveryFee = 0.0;
  int cartCount = 0;
  double subTotal = 0.0;
  double subTotalWithoutCoupon = 0.0;
  double total = 0.0;
  double quantity = 0;
  CartRepo cartRepo;
  Coupon? coupon;
  AuthViewModel authViewModel;
  String paymentMethod = 'Pay on Pickup';

  CartViewModel({required this.cartRepo, required this.authViewModel}) {
    listenForCart();
  }

  Future<void> listenForCart() async {
    cartItems = await cartRepo.getCart();
    calculateSubtotal();
    changeDeliveryAddress();
    notifyListeners();
  }

  incrementQuantity(CartItem cart) async {
    if (cart.quantity <= 99) {
      ++cart.quantity;
      if (await cartRepo.updateCart(cart) == null) {
        refreshCarts();
        return;
      }
      calculateSubtotal();
    }
  }

  decrementQuantity(CartItem cart) async {
    if (cart.quantity > 1) {
      --cart.quantity;
      if (await cartRepo.updateCart(cart) == null) {
        refreshCarts();
        return;
      }
      calculateSubtotal();
    } else {
      removeFromCart(cart);
    }
  }

  void calculateSubtotal() async {
    if (cartItems.isEmpty) return;
    double cartPrice = 0;
    subTotal = 0;
    for (var cart in cartItems) {
      if (cart.food.discountPrice > 0) {
        cartPrice = cart.food.discountPrice;
      } else {
        cartPrice = cart.food.price;
      }

      for (var element in cart.extras) {
        cartPrice += element.price;
      }
      cartPrice *= cart.quantity;
      subTotal += cartPrice;
    }
    subTotalWithoutCoupon = subTotal;
    taxAmount = (subTotal + deliveryFee) *
        cartItems[0].food.restaurant.defaultTax /
        100;
    if (coupon != null) subTotal -= (coupon!.discount / 100) * subTotal;
    total = subTotal + taxAmount + deliveryFee;

    notifyListeners();
  }

  bool isSameRestaurants(Food food) {
    if (cartItems.isNotEmpty) {
      return cartItems[0].food.restaurant.id == food.restaurant.id;
    }
    return true;
  }

  addToCart(Food food, double quantity, BuildContext context,
      {bool reset = false, bool doPop = true, bool foodDetails = false}) async {
    if (reset || cartItems.isEmpty) {
      buildShowDialog(context);
      cartItems.clear();
      deliveryFee =
          await cartRepo.getDeliveryFee(restaurantId: food.restaurant.id);
    }
    var _newCartItem = CartItem.fromJSON({'quantity': quantity});
    _newCartItem.food = food;
    _newCartItem.extras =
        food.extras.where((element) => element.checked).toList();
    // if food exist in the cart then increment quantity
    var _oldCartItem = isExistInCart(_newCartItem);
    if (_oldCartItem != null) {
      // _oldCartItem.quantity += quantity;
      cartItems.add(_oldCartItem);
      if (await cartRepo.updateCart(_oldCartItem) == null) {
        refreshCarts();
        return;
      }
      showToast(
          context: context,
          message: AppLocalizations.of(context)!.food_updated_successfully,
          gravity: ToastGravity.CENTER);
    } else {
      // the food doesnt exist in the cart add new one
      CartItem temp = await cartRepo.addCart(_newCartItem, reset);
      _newCartItem.id = temp.id;
      cartItems.add(_newCartItem);
      showToast(
          context: context,
          message: AppLocalizations.of(context)!.food_added_successfully,
          gravity: ToastGravity.CENTER);
      if (reset) Navigator.pop(context);
    }
    calculateSubtotal();
    if (doPop) {
      if (foodDetails) Navigator.pop(context);
      Navigator.pop(context);
    }
    notifyListeners();
  }

  CartItem? isExistInCart(CartItem _cartItem) {
    for (var oldCartItem in cartItems) {
      if (_cartItem.isSame(oldCartItem)) {
        _cartItem.quantity += oldCartItem.quantity;
        _cartItem.id = oldCartItem.id;
        cartItems
            .removeWhere((element) => element.food.id == _cartItem.food.id);
        return _cartItem;
      }
    }
    return null;
  }

  void doApplyCoupon(String code) async {
    coupon = await cartRepo.verifyCoupon(code);
    calculateSubtotal();
    notifyListeners();
  }

  void removeFromCart(CartItem _cart) async {
    cartItems.remove(_cart);
    calculateSubtotal();
    if (await cartRepo.removeCart(_cart) == false) {
      refreshCarts();
      return;
    }
    if (cartItems.isEmpty) {
      coupon = null;
      deliveryFee = 0.0;
    }
    notifyListeners();
  }

  Future<void> refreshCarts() async {
    cartItems.clear();
    await listenForCart();
  }

  void goCheckout(BuildContext context) {
    if (cartItems[0].food.restaurant.closed) {
      showToast(
          context: context,
          message: AppLocalizations.of(context)!.this_restaurant_is_closed_,
          gravity: ToastGravity.CENTER);
    } else {
      Navigator.of(context).pushNamed('/DeliveryPickup');
    }
  }

  Color getCouponIconColor(BuildContext context) {
    if (coupon?.valid == true) {
      return Colors.green;
    } else if (coupon?.valid == false) {
      return Colors.redAccent;
    }
    return Theme.of(context).focusColor.withOpacity(0.7);
  }

  Future<void> changeDeliveryAddress() async {
    if (cartItems.isNotEmpty) {
      deliveryFee = await cartRepo.getDeliveryFee(
          restaurantId: cartItems[0].food.restaurant.id);
      calculateSubtotal();
      notifyListeners();
    }
  }

  Future<void> addOrder(BuildContext context) async {
    if (authViewModel.deliveryAddress == null &&
        paymentMethod != 'Pay on Pickup') {
      showToast(
          context: context,
          message: AppLocalizations.of(context)!.add_delivery_address);
      Navigator.pop(NavigationService.navigatorKey.currentState!.context);
      return;
    }
    if (paymentMethod == 'Pay on Pickup') {
      authViewModel.deliveryAddress = null;
    }
    Order _order = Order.fromJSON({});
    _order.foodOrders = [];
    _order.tax = cartItems[0].food.restaurant.defaultTax;
    _order.deliveryFee = deliveryFee;
    OrderStatus _orderStatus = OrderStatus.fromJSON({'id': '1'});
    _order.orderStatus = _orderStatus;
    _order.deliveryAddress = authViewModel.deliveryAddress;
    for (var _cart in cartItems) {
      FoodOrder _foodOrder = FoodOrder.fromJSON({});
      _foodOrder.quantity = _cart.quantity;
      _foodOrder.price = _cart.food.price;
      _foodOrder.food = _cart.food;
      _foodOrder.extras = _cart.extras;
      _order.foodOrders.add(_foodOrder);
      _order.total = total;
    }
    Order? order = await cartRepo.addOrder(
        _order, Payment(paymentMethod, methodAr: 'الدفع عند الاستلام'));

    if (order != null) {
      Provider.of<OrderViewModel>(
              NavigationService.navigatorKey.currentState!.context,
              listen: false)
          .refreshOrders();
      Map<String, dynamic> mapArguments = {
        'defaultTax': cartItems[0].food.restaurant.defaultTax.toString(),
        'deliveryFee': deliveryFee,
        'paymentMethod': paymentMethod,
        'subtotal': subTotal,
        'taxAmount': taxAmount,
        'total': total,
      };
      if (coupon != null && coupon!.valid!) {
        mapArguments['subTotalWithoutCoupon'] = subTotalWithoutCoupon;
      }
      Navigator.pushNamed(NavigationService.navigatorKey.currentState!.context,
          'OrderSuccessScreen',
          arguments: mapArguments);
      cartItems.clear();
      coupon = null;
      deliveryFee = 0.0;
      notifyListeners();
    }
  }
}
