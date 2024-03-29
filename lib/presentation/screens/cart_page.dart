import 'package:auto_route/auto_route.dart';
import 'package:fashionstore/bloc/cart/cart_bloc.dart';
import 'package:fashionstore/bloc/productDetails/product_details_bloc.dart';
import 'package:fashionstore/data/entity/cart_item.dart';
import 'package:fashionstore/data/enum/cart_enum.dart';
import 'package:fashionstore/presentation/components/cart_item_component.dart';
import 'package:fashionstore/presentation/components/cart_item_details.dart';
import 'package:fashionstore/utils/extension/number_extension.dart';
import 'package:fashionstore/utils/extension/string%20_extension.dart';
import 'package:fashionstore/utils/render/ui_render.dart';
import 'package:fashionstore/utils/service/loading_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/app_router/app_router_path.dart';
import '../../data/enum/navigation_name_enum.dart';
import '../../data/static/global_variables.dart';
import '../../utils/render/value_render.dart';
import '../components/gradient_button.dart';
import '../layout/layout.dart';

@RoutePage()
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<StatefulWidget> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with TickerProviderStateMixin {
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  late AnimationController _bottomSheetAnimation;

  @override
  void dispose() {
    _bottomSheetAnimation.dispose();
    super.dispose();
  }

  @override
  void initState() {
    GlobalVariable.currentNavBarPage = NavigationNameEnum.CART.name;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      LoadingService(context).reloadCartPage();
    });

    super.initState();
  }

  void initAnimationController() {
    _bottomSheetAnimation = BottomSheet.createAnimationController(this);
    _bottomSheetAnimation.duration = const Duration(seconds: 1);
    _bottomSheetAnimation.reverseDuration = const Duration(seconds: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      scaffoldKey: _scaffoldKey,
      forceCanNotBack: false,
      textEditingController: _textEditingController,
      pageName: 'My Cart',
      hintSearchBarText: 'What item are you looking for?',
      onSearch: (text) {},
      body: RefreshIndicator(
        color: Colors.orange,
        key: _refreshIndicatorKey,
        onRefresh: () async {
          LoadingService(context).reloadCartPage();
        },
        child: BlocListener<CartBloc, CartState>(
          listener: (context, cartState) {
            if (cartState is CartFilteredToCheckoutState) {
              if (cartState.cartItemList.isNotEmpty) {
                context.router.pushNamed(AppRouterPath.checkout);
              }
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _totalCartPriceComponent(),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: _scrollController.hasClients
                      ? _scrollController.position.maxScrollExtent > 0
                          ? const BouncingScrollPhysics()
                          : const AlwaysScrollableScrollPhysics()
                      : const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.width),
                    child: Column(
                      children: [
                        _cartItemList(),
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                child: GradientElevatedButton(
                    buttonMargin: EdgeInsets.symmetric(vertical: 5.height),
                    borderRadiusIndex: 20.radius,
                    borderColor: Colors.transparent,
                    text: 'Check out',
                    textWeight: FontWeight.w600,
                    buttonWidth: 200.width,
                    buttonHeight: 45.height,
                    beginColor: Colors.black,
                    endColor: const Color(0xff727272),
                    textColor: Colors.white,
                    textSize: 16.size,
                    onPress: () {
                      BlocProvider.of<CartBloc>(context).add(
                        OnFilterCartEvent(status: [CartEnum.SELECTED.name]),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _totalCartPriceComponent() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.width, vertical: 15.height),
      height: 50.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total cart price: ',
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              color: const Color(0xff464646),
              fontFamily: 'Work Sans',
              fontWeight: FontWeight.w500,
              fontSize: 16.size,
            ),
          ),
          BlocBuilder<CartBloc, CartState>(builder: (context, cartState) {
            List<CartItem> cartItemList =
                BlocProvider.of<CartBloc>(context).cartItemList;

            if (cartState is CartLoadingState) {
              return SizedBox(
                height: 10.height,
                width: 10.width,
                child: CircularProgressIndicator(
                  color: Colors.orange,
                  strokeWidth: 2.width,
                ),
              );
            }

            if (cartState is AllCartListLoadedState) {
              cartItemList = cartState.cartItemList;
            }

            return Text(
              ValueRender.totalCartPrice(cartItemList).format.dollar,
              style: TextStyle(
                fontFamily: 'Sen',
                fontWeight: FontWeight.w700,
                fontSize: 16.size,
                color: Colors.orange,
              ),
            );
          })
        ],
      ),
    );
  }

  Widget _cartItemList() {
    return BlocConsumer<CartBloc, CartState>(
      listener: (context, cartState) {
        if (cartState is CartRemovedState) {
          UiRender.showDialog(context, '', cartState.message);
          LoadingService(context).reloadCartPage();
        }

        if (cartState is CartUpdatedState) {
          UiRender.showDialog(context, '', cartState.message);
          LoadingService(context).reloadCartPage();
        }

        if (cartState is CartErrorState) {
          UiRender.showDialog(context, '', cartState.message);
        }
      },
      builder: (context, cartState) {
        List<CartItem> cartItemList =
            BlocProvider.of<CartBloc>(context).cartItemList;

        if (cartState is CartLoadingState) {
          return UiRender.loadingCircle();
        }

        if (cartState is AllCartListLoadedState) {
          cartItemList = List.from(cartState.cartItemList);
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cartItemList.length,
          itemBuilder: (context, index) {
            return CartItemComponent(
              cartItem: cartItemList[index],
              onTap: () {
                setState(
                  () {
                    BlocProvider.of<ProductDetailsBloc>(context).add(
                        OnSelectProductEvent(cartItemList[index].productId));

                    initAnimationController();

                    showModalBottomSheet(
                      transitionAnimationController: _bottomSheetAnimation,
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return CartItemDetails(
                            selectedCartItem: cartItemList[index]);
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
