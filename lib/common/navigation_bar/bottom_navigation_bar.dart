import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../features/personalization/screens/user_menu/user_menu_screen.dart';
import '../../features/shop/controllers/cart_controller/cart_controller.dart';
import '../../features/shop/screen_account/home/home.dart';
import '../../features/shop/screen_account/purchase/purchase.dart';
import '../../features/shop/screen_account/sales/sales.dart';
import '../../services/firebase_analytics/firebase_analytics.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/icons.dart';
import '../widgets/loaders/loader.dart';


class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  final cartController = Get.put(CartController());

  DateTime? _lastBackPressedTime; // Variable to track the time of the last back button press
  int _currentIndex = 0;
  final screens = [
    const Home(),
    const Sales(),
    const Purchase(),
    const UserMenuScreen(),
  ];

  final List<String> _pageNames = [
    'bn_menu_home',
    'bn_menu_category',
    'bn_menu_cart',
    'bn_menu_user_menu'
  ];

  void _onTabChange(int index) {
    if (index != _currentIndex) {
      // Log page view only when navigating to a new page
      FBAnalytics.logPageView(_pageNames[index]);
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // FBAnalytics.logPageView('bottom_navigation_bar_screen');
    return PopScope(
      canPop: false, // This property disables the system-level back navigation
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        if(_currentIndex != 0){
          setState(() => _currentIndex = 0);
        } else {
          // Check if _lastBackPressedTime is not null and the difference between the current time
          // and the last back pressed time is less than 2 seconds
          if (_lastBackPressedTime != null &&
              DateTime.now().difference(_lastBackPressedTime!) <= const Duration(seconds: 2)) {
            // If the conditions are met, exit the app
            SystemNavigator.pop();
          } else {
            // If not, show a toast message and update _lastBackPressedTime
            TLoaders.customToast(message: "Press Back Again To Exit");
            _lastBackPressedTime = DateTime.now();
          }
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: screens,
        ),
        bottomNavigationBar: GNav(
            selectedIndex: _currentIndex,
            // onTabChange: (index) => setState(() => _currentIndex = index),
            onTabChange: _onTabChange,
            tabMargin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            haptic: true, // haptic feedback
            tabBorderRadius: 5,
            tabActiveBorder: Border.all(color: TColors.primaryColor, width: 1), // tab button border
            curve: Curves.easeOutExpo, // tab animation curves
            duration: const Duration(milliseconds: 100), // tab animation duration
            gap: 8, // the tab button gap between icon and text
            // color: Colors.grey[800], // unselected icon color
            activeColor: TColors.primaryColor, // selected icon and text color
            iconSize: 25, // tab button icon size
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), // navigation bar padding
            tabs: [
              GButton(
                icon: TIcons.home,
                text: 'Home',
              ),
              GButton(
                icon: TIcons.sales,
                text: 'Sale',
              ),
              // GButton(
              //   icon: LineIcons.heart,
              //   text: 'Likes',
              // ),
              GButton(
                icon: TIcons.purchase,
                text: 'Purchase',
              ),
              GButton(
                icon: TIcons.user,
                text: 'Profile',
              )
            ]
        ),
      ),
    );
  }
}
