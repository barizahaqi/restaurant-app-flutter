import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:restaurant_app/common/styles.dart';
import 'package:restaurant_app/ui/restaurant_detail_page.dart';
import 'package:restaurant_app/ui/restaurant_list_page.dart';
import 'package:restaurant_app/ui/favorite_page.dart';
import 'package:restaurant_app/ui/setting_page.dart';
import 'package:restaurant_app/utils/notification_helper.dart';
import 'package:restaurant_app/widgets/platform_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const routeName = '/home_page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _bottomNavIndex = 0;
  final NotificationHelper _notificationHelper = NotificationHelper();

  @override
  void initState() {
    super.initState();
    _notificationHelper
        .configureSelectNotificationSubject(RestaurantDetailPage.routeName);
  }

  final List<Widget> _listWidget = [
    const RestaurantListPage(),
    const FavoritePage(),
    const SettingsPage(),
  ];

  final List<BottomNavigationBarItem> _bottomNavItems = [
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS ? CupertinoIcons.home : Icons.home,
          color: primaryColor),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(
          Platform.isIOS ? CupertinoIcons.square_favorites : Icons.favorite,
          color: primaryColor),
      label: 'Favorite',
    ),
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS ? CupertinoIcons.settings : Icons.settings,
          color: primaryColor),
      label: 'Settings',
    ),
  ];
  void _onBottomNavTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      body: _listWidget[_bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: secondaryColor,
        unselectedItemColor: secondaryColor,
        currentIndex: _bottomNavIndex,
        items: _bottomNavItems,
        onTap: _onBottomNavTapped,
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: _bottomNavItems,
          activeColor: secondaryColor,
        ),
        tabBuilder: (context, index) {
          return _listWidget[index];
        });
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIos);
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }
}
