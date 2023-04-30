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
    this.textEditingController,
    required this.reload,
    required this.scrollController,
    required this.refreshIndicatorKey,
  }) : super(key: key);

  final bool useSafeArea;
  final bool isChat;
  final String title;
  final bool forceCanNotBack;
  final void Function()? onBack;
  final Widget body;
  final TextEditingController? textEditingController;
  final Map<String, dynamic>? bottomNavigateBarItemData;
  final Future<void> Function() reload;
  final ScrollController scrollController;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: AppBarComponent(
          title: widget.title,
          isChat: widget.isChat,
          forceCanNotBack: widget.forceCanNotBack,
          onBack: widget.onBack,
          textEditingController: widget.textEditingController,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: widget.reload,
        color: Colors.orange,
        key: widget.refreshIndicatorKey,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: widget.scrollController,
          child: widget.body,
        ),
      )
    );
  }
}
