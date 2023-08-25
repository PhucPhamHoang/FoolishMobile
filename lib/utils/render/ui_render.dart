import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fashionstore/bloc/translator/translator_bloc.dart';
import 'package:fashionstore/data/entity/translator_language.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      BuildContext context, String title, String message,
      {String confirmText = 'OK', bool needCenterMessage = true}) async {
    bool? result = await showCupertinoDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext ctx) {
        return CupertinoAlertDialog(
          title: title.isNotEmpty ? Text(title) : null,
          content: message.isNotEmpty
              ? Text(message,
                  textAlign: needCenterMessage == true
                      ? TextAlign.center
                      : TextAlign.start)
              : null,
          actions: [
            // The "Yes" button
            CupertinoDialogAction(
              onPressed: () {
                context.router.pop();
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
                context.router.pop(false);
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

  static Future<void> showDialog(
      BuildContext context, String title, String message) async {
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
                context.router.pop(true);
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
      context: context,
      builder: (BuildContext cxt) {
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
          )),
        );
      },
    );
  }

  static Future<bool> showSingleTextFieldDialog(
      BuildContext context, TextEditingController? controller,
      {String? title,
      String? hintText,
      bool needCenterText = false,
      bool isTranslator = false}) async {
    bool? result = await showPlatformDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext ctx) {
        return PlatformAlertDialog(
          title: Text(title ?? ''),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                textAlign:
                    needCenterText == true ? TextAlign.center : TextAlign.start,
                controller: controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hintText ?? '',
                  hintStyle: const TextStyle(
                      fontFamily: 'Trebuchet MS',
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: Color(0xff8D8D8C)),
                ),
              ),
              isTranslator == true
                  ? BlocBuilder<TranslatorBloc, TranslatorState>(
                      builder: (context, translatorState) {
                      List<TranslatorLanguage> languageList =
                          BlocProvider.of<TranslatorBloc>(context).languageList;
                      List<DropdownMenuItem> dropDownItemList = [];
                      TranslatorLanguage? selectedLanguage =
                          BlocProvider.of<TranslatorBloc>(context)
                              .selectedLanguage;

                      if (translatorState is TranslatorSelectedState) {
                        selectedLanguage = translatorState.selectedLanguage;
                      }

                      if (translatorState
                          is TranslatorLanguageListLoadedState) {
                        languageList = translatorState.translatorLanguageList;
                      }

                      for (TranslatorLanguage language in languageList) {
                        dropDownItemList.add(DropdownMenuItem(
                          value: language.languageCode,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              children: [
                                Container(
                                    height: 40,
                                    width: 60,
                                    margin: const EdgeInsets.only(right: 15),
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(language
                                                .imageLocalStoragePath)),
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                Text(
                                  language.name,
                                  style: const TextStyle(
                                      fontFamily: 'Trebuchet MS',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17,
                                      color: Color(0xff8D8D8C)),
                                )
                              ],
                            ),
                          ),
                        ));
                      }

                      return Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                              // value: selectedLanguage ?? '',
                              itemHeight: null,
                              items: dropDownItemList,
                              isDense: true,
                              isExpanded: true,
                              hint: Text(
                                selectedLanguage != null
                                    ? selectedLanguage.name
                                    : 'Select your language...',
                                style: const TextStyle(
                                    fontFamily: 'Trebuchet MS',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: Color(0xff8D8D8C)),
                              ),
                              selectedItemBuilder: (context) {
                                return dropDownItemList;
                              },
                              onChanged: (value) {
                                BlocProvider.of<TranslatorBloc>(context).add(
                                    OnSelectLanguageCodeTranslatorEvent(value));
                              }),
                        ),
                      );
                    })
                  : Container()
            ],
          ),
          actions: [
            // The "Yes" button
            CupertinoDialogAction(
              onPressed: () {
                context.router.pop(true);
              },
              isDefaultAction: true,
              child: const Text(
                'OK',
                style: TextStyle(
                  color: CupertinoColors.activeBlue,
                ),
              ),
            ),
            // The "No" button
            CupertinoDialogAction(
              onPressed: () {
                context.router.pop(true);
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

  static Widget buildCachedNetworkImage(
    BuildContext context,
    String url, {
    double? width,
    double? height,
    EdgeInsets margin = EdgeInsets.zero,
    EdgeInsets padding = EdgeInsets.zero,
    BorderRadiusGeometry? borderRadius,
    BoxFit fit = BoxFit.cover,
    Alignment alignment = Alignment.center,
    Widget? content,
    BoxBorder? border,
  }) {
    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
          alignment: alignment,
          margin: margin,
          padding: padding,
          width: width,
          height: height,
          decoration: BoxDecoration(
              border: border,
              borderRadius: borderRadius,
              image: DecorationImage(image: imageProvider, fit: fit)),
          child: content),
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator(color: Colors.orange)),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
