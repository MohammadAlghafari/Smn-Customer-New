import 'package:smn_delivery_app/data/auth/api/auth_api.dart';
import 'package:smn_delivery_app/data/auth/auth_interfce.dart';
import 'package:smn_delivery_app/data/auth/model/address.dart';
import 'package:smn_delivery_app/data/auth/model/user.dart';

class AuthRepo implements AuthInterface {
  AuthApi authApi;

  AuthRepo({required this.authApi});

  @override
  Future<User?> login(String email, String password) async {
    return await authApi.login(email, password);
  }

  @override
  Future<bool> resetPassword(String email) {
    return authApi.resetPassword(email);
  }

  @override
  Future<List<Address>> getAddresses(User user) async {
    return authApi.getAddresses(user);
  }

  @override
  Future<Address> changeCurrentLocation(Address address) {
    return authApi.changeCurrentLocation(address);
  }

  @override
  Future<dynamic> setCurrentLocation(String googleMapsKey) {
    return authApi.setCurrentLocation( googleMapsKey);
  }

  @override
  Future<Address> addAddress(Address address, User user) {
    return authApi.addAddress(address, user);
  }

  @override
  Future<Address> updateAddress(Address address, User user) {
    return authApi.updateAddress(address, user);
  }

  @override
  Future<Address> removeDeliveryAddress(Address address, User user) {
    return authApi.removeDeliveryAddress(address, user);
  }

  @override
  Future<Map<String, dynamic>> checkRegister(Map<String,dynamic>body) async {
    return await authApi.checkRegister(body);
  }

  @override
  Future<User> register(Map<String,dynamic>body) async{
    return authApi.register(body);
  }

  @override
  Future<bool> deleteAccount( String apiToken) {
    return authApi.deleteAccount(apiToken);
  }

  @override
  Future<bool> sendOTP(String number) {
    return authApi.sendOTP(number);
  }

  @override
  Future<bool> verifyOTP(String phone, String code) {
    return authApi.verifyOTP(phone, code);
  }
}
