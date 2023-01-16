import 'package:shared_preferences/shared_preferences.dart';

String get api_base_url {
  // return 'https://smnfood.app/api/';
  return 'https://staging.smnfood.app/api/';
}

String get baseUrl {
  // return 'https://smnfood.app/';
  return 'https://staging.smnfood.app/';
}


// String? lang;
Future<String> lang() async {
  var prefs = await SharedPreferences.getInstance();
  if (prefs.getString("language_code") == null) return "en";
  return prefs.getString("language_code") ?? "en";
}

String login() {
  return "${api_base_url}login";
}

String resetPassword() {
  return "$api_base_url/send_reset_link_email";
}

String setting()  {
  return "${api_base_url}settings";
}

String changeUserLanguage() {
  return '${api_base_url}language';
}

String getStatistics(String id) {
  return "${baseUrl}api/manager/dashboard/$id";
}

String getOrders({required String userId, required String apiToken}) {
  return "${api_base_url}orders?api_token=${apiToken}&with=user;foodOrders;foodOrders.food;foodOrders.extras;orderStatus;payment&search=user.id:$userId&searchFields=user.id:=&orderBy=id&sortedBy=desc&isCustomer=1";
}

String cancelOrder(String id) {
  return "$api_base_url/api/orders/$id";
}

String orderStatuses() {
  return "${baseUrl}api/order_statuses";
}

String markAsReadNotifications(String notificationsId, String apiToken) {
  return '${api_base_url}notifications/$notificationsId?$apiToken';
}

String removeNotification(String cartId, String apiToken) {
  return '${api_base_url}notifications/$cartId?$apiToken';
}

String updateSettings(String userId, String apiToken) {
  return '${api_base_url}users/$userId?$apiToken';
}

String getFaqCategories(String apiToken) {
  return '${api_base_url}faq_categories?with=faqs';
}

String checkRegister() {
  return '${api_base_url}check-register';
}

String register() {
  return '${api_base_url}register';
}

String getFavorite({required String apiToken, required String userId}) {
  return '${api_base_url}favorites?api_token=${apiToken}&with=food;user;extras&search=user_id:$userId&searchFields=user_id:=';
}

String addOrder({required String apiToken}) {
  return '${api_base_url}orders?api_token=$apiToken';
}

String getCuisines() {
  return '${api_base_url}cuisines?orderBy=updated_at&sortedBy=desc';
}

String addFavorite(String apiToken) {
  return '${api_base_url}favorites?$apiToken';
}

String deleteFavorite(String apiToken, String favoriteId) {
  return '${api_base_url}favorites/$favoriteId?$apiToken';
}

String isFavorite(String apiToken, String userId, String foodId) {
  return '${api_base_url}favorites/exist?${apiToken}food_id=$foodId&user_id=$userId';
}

String getOrderStatuses(String apiToken) {
  return '${api_base_url}order_statuses?$apiToken';
}

String foodReviews() {
  return '${api_base_url}food_reviews';
}

String restaurantReviews() {
  return '${api_base_url}restaurant_reviews';
}

String deleteAccount() {
  return "${api_base_url}delete_account";
}
String createChat() {
  return '${api_base_url}chat_create';
}
String sendChat() {
  return '${api_base_url}message_create';
}

String sendOTP() {
  return "${api_base_url}send-otp";
}

String verifyOTP() {
  return "${api_base_url}check-otp";
}