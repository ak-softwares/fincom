import 'package:flutter/material.dart';

import '../../features/personalization/screens/user_menu/user_menu_screen.dart';
import '../../features/shop/screens/cart/cart.dart';
import '../../features/shop/screens/category/all_category_screen.dart';
import '../../features/shop/screens/home/home.dart';
import '../../services/firebase_analytics/firebase_analytics.dart';
import '../../utils/constants/icons.dart';


class BottomNavigation1 extends StatefulWidget {
  const BottomNavigation1({super.key});

  @override
  State<BottomNavigation1> createState() => _BottomNavigation1State();
}

class _BottomNavigation1State extends State<BottomNavigation1> {
  int _currentIndex = 0;
  final screens = [
    const MyHomePage(),
    const CategoryScreen(),
    // const FavouriteScreen(),
    const CartScreen(),
    const UserMenuScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    FBAnalytics.logPageView('bottom_navigation_bar1_screen');
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        iconSize: 28,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
        backgroundColor: Colors.white,
        // selectedFontSize: 10,
        // unselectedFontSize: 20,
        fixedColor: Colors.black,
        unselectedItemColor: Colors.grey[700],
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(TIcons.home),
          ),
          BottomNavigationBarItem(
            label: 'Category',
            icon: Icon(TIcons.category),
          ),
          // BottomNavigationBarItem(
          //   label: 'Wishlist',
          //   icon: Icon(TIcons.favorite),
          // ),
          BottomNavigationBarItem(
            label: 'Cart',
            icon: Icon(TIcons.bottomNavigationCart),
          ),
          BottomNavigationBarItem(
            label: 'Account',
            icon: Icon(TIcons.user),
          ),
        ],
      ),
    );
  }
}
