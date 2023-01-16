import 'package:smn_delivery_app/data/auth/model/address.dart';
import 'package:smn_delivery_app/data/auth/model/user.dart';

abstract class AuthInterface {
  Future<User?> login(String email, String password);

  Future<bool> resetPassword(String email);

  Future<Address> changeCurrentLocation(Address address);

  Future<List<Address>> getAddresses(User user);

  Future<dynamic> setCurrentLocation(String googleMapsKey);

  Future<Address> addAddress(Address address, User user);

  Future<Address> updateAddress(Address address, User user);

  Future<Address> removeDeliveryAddress(Address address, User user);

  Future<Map<String, dynamic>> checkRegister(Map<String, dynamic> body);

  Future<User> register(Map<String, dynamic> body);

  Future<bool> sendOTP(String number);

  Future<bool> verifyOTP(String phone, String code);

  Future<bool> deleteAccount( String apiToken);
}
