import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UiRender {
  const UiRender._();

  static LinearGradient generalLinearGradient() {
    return const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Color(0xff8D8D8C), Color(0xff000000)],
    );
  }

  static Widget loadingCircle() {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.orange,
      ),
    );
  }
}