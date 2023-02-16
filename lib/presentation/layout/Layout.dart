import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/Appbar.dart';

class Layout extends StatefulWidget {
  const Layout({
    Key? key,
    this.useSafeArea = true,
    this.isChat = false,
    this.title = '',
    this.forceCanNotBack = false,
    this.onBack,
    required this.body,
    this.bottomNavigateBarItemData,
  }) : super(key: key);

  final bool useSafeArea;
  final bool isChat;
  final String title;
  final bool forceCanNotBack;
  final void Function()? onBack;
  final Widget body;

  final Map<String, dynamic>? bottomNavigateBarItemData;

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          PreferredSize(
              preferredSize: const Size.fromHeight(110),
              child: AppBarComponent(
                title: widget.title,
                isChat: widget.isChat,
                forceCanNotBack: widget.forceCanNotBack,
                onBack: widget.onBack,
              ),
            )

    );
  }
}
