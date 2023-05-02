import 'package:fashionstore/data/enum/NavigationNameEnum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/static/GlobalVariable.dart';
import '../../util/render/UiRender.dart';

class BottomNavigationBarComponent extends StatefulWidget {
  const BottomNavigationBarComponent({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BottomNavigationBarComponentState();
}

class _BottomNavigationBarComponentState extends State<BottomNavigationBarComponent> {
  

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 75,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(left: 18, right: 18),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _navBarButton(
                'assets/icon/home_icon.png',
                'Home',
                onTap: () {
                  GlobalVariable.currentPage = NavigationNameEnum.HOME.name;
                  //pop to page
                }
              ),
              _navBarButton(
                  'assets/icon/category_icon.png',
                  'Category',
                  onTap: () {
                    GlobalVariable.currentPage = NavigationNameEnum.CATEGORIES.name;
                    //pop to page
                  }
              ),
              _navBarButton(
                  'assets/icon/account_icon.png',
                  'Account',
                  onTap: () {
                    GlobalVariable.currentPage = NavigationNameEnum.ACCOUNT.name;
                    //pop to page
                  }
              ),
            ],
          ),
        ),
        Positioned(
            top: -15,
            right: 0,
            child: _cartButton(
              onTap: () {
                GlobalVariable.currentPage = NavigationNameEnum.CART.name;
                //pop to page
              }
            )
        ),
      ]
    );
  }

  Widget _navBarButton(String iconUrl, String name, {required void Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 35),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
                iconUrl,
                height: 20,
                width: 20,
                fit: BoxFit.fill,
                color: GlobalVariable.currentPage != name.toUpperCase() ? const Color(0xffa4a4a4) : Colors.orange
            ),
            Text(
              name,
              style: TextStyle(
                  fontFamily: 'Work Sans',
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: GlobalVariable.currentPage != name.toUpperCase() ? const Color(0xffa4a4a4) : Colors.orange
              ),
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
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            bottomLeft: Radius.circular(40),
          ),
          gradient: UiRender.generalLinearGradient(),
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
            const SizedBox(width: 4,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '\$9999',
                  style: TextStyle(
                      fontFamily: 'Work Sans',
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.white
                  ),
                ),
                Text(
                  '3 items',
                  style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontFamily: 'Work Sans',
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.white
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}