import 'package:shared_preferences/shared_preferences.dart';

import '../../data/entity/Product.dart';

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

  static List<String> getProductImagesFromDifferentColors(List<Product> productList) {
    List<String> result = [];

    String imgUrl = '';

    for(int i = 0; i < productList.length; i++){
      if(i == 0) {
        imgUrl = productList[i].image1;
        result.add(imgUrl);
      }
      else if(productList[i].image1 != productList[i-1].image1) {
        imgUrl = productList[i].image1;
        result.add(imgUrl);
      }
    }

    return result;
  }

  static List<String> getProductSizeListByColor(String color, List<Product> productList) {
    return productList.where((element) => element.color == color).map((e) => e.size).toList();
  }
}