import 'package:elive/screens/cartScreen.dart';
import 'package:elive/screens/homeScreen.dart';
import 'package:elive/utils/constants.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      HomeScreen(),
      CartScreen(),
    ];
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: FFNavigationBar(
        theme: FFNavigationBarTheme(
          barBackgroundColor: Colors.black,
          selectedItemBorderColor: getPrimaryColor(context),
          selectedItemBackgroundColor: Colors.black,
          selectedItemIconColor: getPrimaryColor(context),
          selectedItemLabelColor: Colors.white,
        ),
        items: [
          FFNavigationBarItem(
            iconData: Icons.home,
            label: 'Home',
          ),
          FFNavigationBarItem(
            iconData: Icons.shopping_cart,
            label: 'Cart',
          ),
        ],
        selectedIndex: _selectedIndex,
        onSelectTab: _onItemTapped,
      ),
    );
  }
}
