import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveSenderId(String userId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('senderId', userId);
}

Future<String?> getSenderId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('senderId');
}
