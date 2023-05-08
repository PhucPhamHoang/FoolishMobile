import 'package:flutter/material.dart';

import '../components/Appbar.dart';
import '../components/BottomNavigationBar.dart';

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
    this.textEditingController,
    this.hintSearchBarText,
    this.onSearch,
    this.scaffoldKey,
    this.pageName = '',
  }) : super(key: key);

  final bool useSafeArea;
  final bool isChat;
  final String title;
  final String pageName;
  final String? hintSearchBarText;
  final bool forceCanNotBack;
  final void Function()? onBack;
  final void Function()? onSearch;
  final Widget body;
  final TextEditingController? textEditingController;
  final Map<String, dynamic>? bottomNavigateBarItemData;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: AppBarComponent(
          title: widget.title,
          pageName: widget.pageName,
          isChat: widget.isChat,
          forceCanNotBack: widget.forceCanNotBack,
          onBack: widget.onBack,
          textEditingController: widget.textEditingController,
          onSearch: widget.onSearch,
          hintSearchBarText: widget.hintSearchBarText,
        ),
      ),
      backgroundColor: const Color(0xfff3f3f3),
      body: widget.body,
      bottomNavigationBar: const BottomNavigationBarComponent(),
    );
  }
}
