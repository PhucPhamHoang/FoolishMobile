import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBarComponent extends StatefulWidget {
  const AppBarComponent({
    Key? key,
    this.isChat = false,
    this.title = '',
    this.forceCanNotBack = false,
    this.onBack,
  }) : super(key: key);

  final bool isChat;
  final String title;
  final bool forceCanNotBack;
  final void Function()? onBack;

  @override
  State<AppBarComponent> createState() => _AppBarComponentState();
}

class _AppBarComponentState extends State<AppBarComponent> {
  @override
  Widget build(BuildContext context) {
    return _appbarContent();
  }

  Widget _appbarContent() {
    return AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xffFFB800), Color(0xffFF7A00)],
        )),
      ),
      elevation: 0,
      bottomOpacity: 0,
      titleSpacing: 0,
      leadingWidth: 48,
      //leading:
      title: _buildTitle(),
      centerTitle: true,
      // actions: const [
      //   UserActionPopupButtonComponent(),
      // ],
    );
  }

  Widget _buildTitle() {
    return
       RichText(
        text: const TextSpan(children: [
          TextSpan(
              text: 'Foolish ',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xffFF7A00),
                fontSize: 18
              )
          ),
          TextSpan(
              text: 'Store',
              style:
                  TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xffFFffff),
                    fontSize: 18,
                  )
          ),
        ]));

  }
}
