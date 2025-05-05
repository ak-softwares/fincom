import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../features/accounts/screen/home/home.dart';
import '../../features/accounts/screen/purchase/purchase.dart';
import '../../features/accounts/screen/sales/sales.dart';
import '../../features/personalization/screens/user_menu/user_menu_screen.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/icons.dart';
import '../dialog_box_massages/snack_bar_massages.dart';


class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {

  DateTime? _lastBackPressedTime; // Variable to track the time of the last back button press
  int _currentIndex = 0;
  final screens = [
    const Analytics(),
    const Sales(),
    const Purchase(),
    const UserMenuScreen(),
  ];

  void _onTabChange(int index) {
    if (index != _currentIndex) {
      // Log page view only when navigating to a new page
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
            AppMassages.showToastMessage(message: "Press Back Again To Exit");
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
            tabActiveBorder: Border.all(color: AppColors.primaryColor, width: 1), // tab button border
            curve: Curves.easeOutExpo, // tab animation curves
            duration: const Duration(milliseconds: 100), // tab animation duration
            gap: 8, // the tab button gap between icon and text
            // color: Colors.grey[800], // unselected icon color
            activeColor: AppColors.primaryColor, // selected icon and text color
            iconSize: 25, // tab button icon size
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), // navigation bar padding
            tabs: [
              GButton(
                icon: AppIcons.home,
                text: 'Home',
              ),
              GButton(
                icon: AppIcons.sales,
                text: 'Sale',
              ),
              // GButton(
              //   icon: LineIcons.heart,
              //   text: 'Likes',
              // ),
              GButton(
                icon: AppIcons.purchase,
                text: 'Purchase',
              ),
              GButton(
                icon: AppIcons.user,
                text: 'Profile',
              )
            ]
        ),
      ),
    );
  }
}
