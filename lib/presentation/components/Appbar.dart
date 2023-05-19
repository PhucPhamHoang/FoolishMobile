import 'package:cached_network_image/cached_network_image.dart';
import 'package:fashionstore/bloc/productSearching/product_searching_bloc.dart';
import 'package:fashionstore/bloc/products/product_bloc.dart';
import 'package:fashionstore/bloc/translator/translator_bloc.dart';
import 'package:fashionstore/data/entity/Product.dart';
import 'package:fashionstore/util/render/UiRender.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../screens/SearchingPage.dart';

class AppBarComponent extends StatefulWidget {
  const AppBarComponent({
    Key? key,
    this.isChat = false,
    this.title = '',
    this.forceCanNotBack = false,
    this.onBack,
    this.textEditingController,
    this.hintSearchBarText,
    this.onSearch,
    this.pageName = '',
    this.isSearchable = false,
    this.translatorEditingController,
  }) : super(key: key);

  final bool isChat;
  final String pageName;
  final String title;
  final bool forceCanNotBack;
  final bool isSearchable;
  final TextEditingController? textEditingController;
  final TextEditingController? translatorEditingController;
  final void Function()? onBack;
  final void Function(String text)? onSearch;
  final String? hintSearchBarText;

  @override
  State<AppBarComponent> createState() => _AppBarComponentState();
}

class _AppBarComponentState extends State<AppBarComponent> {
  @override
  Widget build(BuildContext context) {
    return _appbarContent();
  }

  Widget _appbarContent() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            child: AppBar(
              toolbarHeight: 80,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: UiRender.generalLinearGradient(),
                ),
              ),
              elevation: 0,
              bottomOpacity: 0,
              titleSpacing: 0,
              leadingWidth: 48,
              automaticallyImplyLeading: false,
              leading: Navigator.of(context).canPop() && widget.forceCanNotBack == false
                ? IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (widget.onBack != null) {
                        widget.onBack!();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                  )
                : null,
              //leading:
              title: _buildTitle(),
              centerTitle: true,
            ),
          ),
          Positioned(
            bottom: -20,
            right: 20,
            left: 20,
            child: widget.isSearchable == false
              ? GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SearchingPage())
                  );
                },
                child: Container(
                    padding: const EdgeInsets.only(right: 30, left: 20),
                    height: 44,
                    width: MediaQuery.of(context).size.width - 40,
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0, 1),
                              blurRadius: 4.0,
                              spreadRadius: 1.0,
                              blurStyle: BlurStyle.outer
                          ),
                        ],
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.white
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.hintSearchBarText ?? '',
                          style: const TextStyle(
                              fontFamily: 'Sen',
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color(0xffacacac)
                          ),
                        ),
                        const ImageIcon(
                          AssetImage('assets/icon/translator_icon.png'),
                          color: Colors.grey,
                        ),
                      ],
                    )
                ),
              )
              : Container(
                padding: const EdgeInsets.only(right: 20, left: 20),
                height: 44,
                width: MediaQuery.of(context).size.width - 40,
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0, 1),
                          blurRadius: 4.0,
                          spreadRadius: 1.0,
                          blurStyle: BlurStyle.outer
                      ),
                    ],
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.white
                ),
                child: TextField(
                  controller: widget.textEditingController,
                  onChanged: widget.onSearch,
                  onSubmitted: widget.onSearch,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        tooltip: "Translator",
                        onPressed: () {
                          BlocProvider.of<TranslatorBloc>(context).add(OnLoadLanguageListTranslatorEvent());

                          UiRender.showSingleTextFieldDialog(
                            context,
                            widget.translatorEditingController,
                            title: 'Translator',
                            hintText: "Search...",
                            isTranslator: true
                          ).then((value) {
                            if(value == true) {
                              if(widget.translatorEditingController?.text != null &&
                                 BlocProvider.of<TranslatorBloc>(context).selectedLanguage?.languageCode != null) {
                                BlocProvider.of<TranslatorBloc>(context).add(
                                    OnTranslateEvent(
                                        widget.translatorEditingController?.text ?? '',
                                        BlocProvider.of<TranslatorBloc>(context).selectedLanguage?.languageCode ?? ''
                                    )
                                );
                              }
                              widget.translatorEditingController?.clear();
                            }
                          });
                        },
                        icon: const ImageIcon(
                          AssetImage('assets/icon/translator_icon.png'),
                          color: Colors.grey,
                        ),
                      ),
                    border: InputBorder.none,
                    hintText: widget.hintSearchBarText,
                    hintStyle: const TextStyle(
                        fontFamily: 'Sen',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color(0xffacacac)
                    )
                  ),
                ),
              ),
          ),
        ]
      ),
    );
  }

  Widget _buildTitle() {
    return widget.pageName == ''
      ? RichText(
        text: const TextSpan(
            children: [
              TextSpan(
                  text: 'Foolish ',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    color: Color(0xffFF7A00),
                    fontSize: 20,
                  )
              ),
              TextSpan(
                  text: 'Store',
                  style:
                  TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    color: Color(0xffFFffff),
                    fontSize: 20,
                  )
              ),
            ]
        )
    )
      : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
                text: const TextSpan(
                    children: [
                      TextSpan(
                          text: 'Foolish ',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            color: Color(0xffFF7A00),
                            fontSize: 12,
                          )
                      ),
                      TextSpan(
                          text: 'Store',
                          style:
                          TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontSize: 12,
                          )
                      ),
                    ]
                )
            ),
            Text(
              widget.pageName,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontSize: 18,
              ),
            )
          ],
        );
  }
}
