import 'package:fashionstore/util/render/UiRender.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  }) : super(key: key);

  final bool isChat;
  final String title;
  final bool forceCanNotBack;
  final TextEditingController? textEditingController;
  final void Function()? onBack;
  final void Function()? onSearch;
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
              // actions: const [
              //   UserActionPopupButtonComponent(),
              // ],
            ),
          ),
          Positioned(
            bottom: -20,
            right: 20,
            left: 20,
            child: Container(
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
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: widget.onSearch,
                    icon: const ImageIcon(
                      AssetImage('assets/icon/search_icon.png'),
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
            )
          )
        ]
      ),
    );
  }

  Widget _buildTitle() {
    return RichText(
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
    );
  }
}
