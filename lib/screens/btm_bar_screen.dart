import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/provider/dark_theme_provider.dart';
import 'package:grocery_app/providers/cart_provider.dart';
import 'package:grocery_app/screens/cart/cart_screen.dart';
import 'package:grocery_app/screens/category_screen.dart';
import 'package:grocery_app/screens/home_screen.dart';
import 'package:grocery_app/screens/user_screen.dart';
import 'package:grocery_app/widgets/text_widgets.dart';
import 'package:provider/provider.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'page': const HomeScreen(),
      'title': 'Home Screen',
    },
    {
      'page': CategoriesScreen(),
      'title': 'Categories Screen',
    },
    {
      'page': const CartScreen(),
      'title': 'Cart Screen',
    },
    {
      'page':  UserScreen(),
      'title': 'User Screen',
    },
  ];
  void _selectedPages(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool isDark = themeState.getDarkTheme;
    return Scaffold(
      /* appBar: AppBar(
        title: Text(_pages[_selectedIndex]['title']),
      ),*/
      body: _pages[_selectedIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: isDark ? Theme.of(context).cardColor : Colors.white,
        unselectedItemColor: isDark ? Colors.white10 : Colors.black87,
        selectedItemColor: isDark ? Colors.lightBlue.shade200 : Colors.black87,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        onTap: _selectedPages,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                  _selectedIndex == 0 ? IconlyBold.home : IconlyLight.home),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 1
                  ? IconlyBold.category
                  : IconlyLight.category),
              label: 'Category'),
          BottomNavigationBarItem(
              icon: Consumer<CartProvider>(builder: (_, myCart, ch) {
                return Badge(
                    toAnimate: false,
                    shape: BadgeShape.circle,
                    badgeColor: Colors.blue,
                    borderRadius: BorderRadius.circular(8.0),
                    position: BadgePosition.topEnd(top: -7, end: -7),
                    badgeContent: FittedBox(
                        child: TextWidget(
                            text: myCart.getCartItems.length.toString(),
                            color: Colors.white,
                            textSize: 14)),
                    child: Icon(_selectedIndex == 2
                        ? IconlyBold.buy
                        : IconlyLight.buy));
              }),
              label: 'Cart'),
          BottomNavigationBarItem(
              icon: Icon(
                  _selectedIndex == 3 ? IconlyBold.user2 : IconlyLight.user2),
              label: 'User'),
        ],
      ),
    );
  }
}
