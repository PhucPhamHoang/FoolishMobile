import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

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

  static Future<bool> showConfirmDialog(
      BuildContext context,
      String title,
      String message, {
        String confirmText = 'OK',
      }) async {
    bool? result = await showCupertinoDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext ctx) {
        return CupertinoAlertDialog(
          title: title.isNotEmpty ? Text(title) : null,
          content: message.isNotEmpty ? Text(message) : null,
          actions: [
            // The "Yes" button
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              isDefaultAction: true,
              child: Text(
                confirmText,
                style: const TextStyle(
                  color: CupertinoColors.activeBlue,
                ),
              ),
            ),
            // The "No" button
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              isDestructiveAction: true,
              child: const Text('Cancel'),
            )
          ],
        );
      },
    );

    return result ?? false;
  }

  static Future<void> showDialog(BuildContext context, String title, String message) async {
    return showCupertinoDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext ctx) {
        return CupertinoAlertDialog(
          title: title.isNotEmpty ? Text(title) : null,
          content: message.isNotEmpty ? Text(message) : null,
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              isDefaultAction: true,
              child: const Text(
                'Got it',
                style: TextStyle(
                  color: CupertinoColors.activeBlue,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showLoaderDialog(BuildContext context) async {
    return showCupertinoDialog(
      barrierDismissible: true,
      context:context,
      builder:(BuildContext cxt){
        return Container(
          height: 100,
          width: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
          ),
          child: const Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              )
          ),
        );
      },
    );
  }

  static Future<void> showTextFieldDialog(BuildContext context, TextEditingController? controller) async {
    showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
        title: const Text('Input the quantity you want to purchase!'),
        content: TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Your quantity...',
            hintStyle: TextStyle(
                fontFamily: 'Trebuchet MS',
                fontWeight: FontWeight.w400,
                fontSize: 15,
                color: Color(0xff8D8D8C)
            ),
          ),
        ),
        actions: <Widget>[
          PlatformDialogAction(
            child: const Text('OK'),
            onPressed: () {
              // Do something with the input text
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}