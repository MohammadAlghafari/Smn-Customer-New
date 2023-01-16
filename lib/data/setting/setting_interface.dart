import 'package:smn_delivery_app/data/auth/model/user.dart';
import 'package:smn_delivery_app/data/setting/model/setting.dart';

abstract class SettingInterface {
  Future<Setting> getSetting();
  Future<User> update(User user);
  Future<void> changeLanguage(String languageCode);
}
