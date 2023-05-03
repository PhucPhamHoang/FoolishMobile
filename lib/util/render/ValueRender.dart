import 'package:shared_preferences/shared_preferences.dart';

class ValueRender {
  const ValueRender._();


  static String getGoogleDriveImageUrl(String imageId) {
    return 'https://drive.google.com/uc?export=view&id=$imageId';
  }

  static double getDiscountPrice(double orgPrice, double discount) {
    return orgPrice * (discount / 100);
  }

  static void setLocalStorageVariable(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value.toString());
  }

  static Future<dynamic> getLocalStorageVariable(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get(key) ?? '';
  }
}