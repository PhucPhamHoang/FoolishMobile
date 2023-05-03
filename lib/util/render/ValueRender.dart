class ValueRender {
  const ValueRender._();



  static String getGoogleDriveImageUrl(String imageId) {
    return 'https://drive.google.com/uc?export=view&id=$imageId';
  }

  static double getDiscountPrice(double orgPrice, double discount) {
    return orgPrice * (discount / 100);
  }
}