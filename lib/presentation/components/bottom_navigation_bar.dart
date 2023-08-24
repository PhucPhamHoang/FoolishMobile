import 'package:fashionstore/bloc/cart/cart_bloc.dart';
import 'package:fashionstore/data/enum/navigation_name_enum.dart';
import 'package:fashionstore/presentation/screens/all_categories_page.dart';
import 'package:fashionstore/presentation/screens/cart_page.dart';
import 'package:fashionstore/presentation/screens/home_page.dart';
import 'package:fashionstore/presentation/screens/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../bloc/categories/category_bloc.dart';
import '../../data/static/global_variables.dart';
import '../../utils/render/ui_render.dart';
import '../screens/all_products_page.dart';

class BottomNavigationBarComponent extends StatefulWidget {
  const BottomNavigationBarComponent({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BottomNavigationBarComponentState();
}

class _BottomNavigationBarComponentState
    extends State<BottomNavigationBarComponent> {
  final ItemScrollController _itemScrollController = ItemScrollController();
  int _selectedNavIndex = 0;
  final List<String> _navNameList = [
    NavigationNameEnum.HOME.name,
    NavigationNameEnum.CATEGORIES.name,
    NavigationNameEnum.CLOTHINGS.name,
    NavigationNameEnum.PROFILE.name
  ];
  late List<Widget> _navList;

  @override
  void initState() {
    _navList = [
      _navBarButton('assets/icon/home_icon.png', 'Home', onTap: () {
        if (GlobalVariable.currentNavBarPage != NavigationNameEnum.HOME.name) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
              (Route<dynamic> route) => false);

          GlobalVariable.currentNavBarPage = NavigationNameEnum.HOME.name;
        }
      }),
      _navBarButton('assets/icon/category_icon.png', 'Categories', onTap: () {
        if (GlobalVariable.currentNavBarPage !=
            NavigationNameEnum.CATEGORIES.name) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => const AllCategoriesPage()),
              (Route<dynamic> route) => false);

          GlobalVariable.currentNavBarPage = NavigationNameEnum.CATEGORIES.name;
        }
      }),
      _navBarButton('assets/icon/clothing_icon.png', 'Clothings', onTap: () {
        if (GlobalVariable.currentNavBarPage !=
            NavigationNameEnum.CLOTHINGS.name) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const AllProductsPage()),
              (Route<dynamic> route) => false);

          GlobalVariable.currentNavBarPage = NavigationNameEnum.CLOTHINGS.name;
          BlocProvider.of<CategoryBloc>(context)
              .add(const OnSelectedCategoryEvent('All'));
        }
      }),
      _navBarButton('assets/icon/account_icon.png', 'Profile', onTap: () {
        if (GlobalVariable.currentNavBarPage !=
            NavigationNameEnum.PROFILE.name) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
              (Route<dynamic> route) => false);

          GlobalVariable.currentNavBarPage = NavigationNameEnum.PROFILE.name;
        }
      }),
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (GlobalVariable.currentNavBarPage != NavigationNameEnum.CART.name) {
        _selectedNavIndex =
            _navNameList.indexOf(GlobalVariable.currentNavBarPage);

        Future.delayed(const Duration(milliseconds: 500), () {
          _itemScrollController.scrollTo(
              index: _selectedNavIndex,
              duration: const Duration(milliseconds: 1000));
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(clipBehavior: Clip.none, children: [
      Container(
        height: 70,
        alignment: Alignment.centerLeft,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(left: 18, right: 18),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          color: Colors.white,
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 140,
          child: ScrollablePositionedList.builder(
              itemScrollController: _itemScrollController,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: _navNameList.length,
              itemBuilder: (context, index) {
                if (index > 0) {
                  return _navList[index];
                }

                return Container();
              }),
        ),
      ),
      Positioned(
          top: -15,
          right: 0,
          child: _cartButton(onTap: () {
            if (GlobalVariable.currentNavBarPage !=
                NavigationNameEnum.CART.name) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const CartPage()),
                  (Route<dynamic> route) => false);

              GlobalVariable.currentNavBarPage = NavigationNameEnum.CART.name;
            }
          })),
    ]);
  }

  Widget _navBarButton(String iconUrl, String name,
      {required void Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(iconUrl,
                height: 20,
                width: 20,
                fit: BoxFit.fill,
                color: GlobalVariable.currentNavBarPage != name.toUpperCase()
                    ? const Color(0xffa4a4a4)
                    : Colors.orange),
            Text(
              name,
              style: TextStyle(
                  fontFamily: 'Work Sans',
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: GlobalVariable.currentNavBarPage != name.toUpperCase()
                      ? const Color(0xffa4a4a4)
                      : Colors.orange),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cartButton({required void Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 54,
        width: 120,
        decoration: BoxDecoration(
          color:
              GlobalVariable.currentNavBarPage == NavigationNameEnum.CART.name
                  ? Colors.orange
                  : null,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            bottomLeft: Radius.circular(40),
          ),
          gradient:
              GlobalVariable.currentNavBarPage == NavigationNameEnum.CART.name
                  ? null
                  : UiRender.generalLinearGradient(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icon/cart_icon.png',
              width: 30,
              height: 30,
              color: Colors.white,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              width: 4,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'My Cart',
                  style: TextStyle(
                      fontFamily: 'Work Sans',
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.white),
                ),
                BlocBuilder<CartBloc, CartState>(builder: (context, cartState) {
                  int totalItems =
                      BlocProvider.of<CartBloc>(context).totalCartItemQuantity;
                  if (cartState is TotalCartItemQuantityLoadedState) {
                    totalItems = cartState.totalQuantity;
                  }

                  return Text(
                    '$totalItems items',
                    style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontFamily: 'Work Sans',
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.white),
                  );
                })
              ],
            )
          ],
        ),
      ),
    );
  }
}
