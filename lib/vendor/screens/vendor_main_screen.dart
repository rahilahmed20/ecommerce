import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macstore/vendor/screens/edit_product_screen.dart';
import 'package:macstore/vendor/screens/vendor_account_screen.dart';
import 'package:macstore/vendor/screens/vendor_orders_screen.dart';
import 'package:macstore/views/screens/bottomNav_screens/cart_product_widget.dart';
import 'package:macstore/views/screens/bottomNav_screens/stores_screen.dart';
import 'package:macstore/views/screens/home_Screen.dart';

class vendorMainScreen extends StatefulWidget {
  const vendorMainScreen({super.key});

  @override
  State<vendorMainScreen> createState() => _vendorMainScreenState();
}

class _vendorMainScreenState extends State<vendorMainScreen> {
  List<Widget> _pages = [
    HomeScreen(),
    // StoresScreen(),
    CartScreenProduct(),
    ProductUploadPage(),
    VendorOrderScreen(),
    VendorAccountScreen(),
  ];
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            pageIndex = value;
          });
        },
        currentIndex: pageIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF3C55EF),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.white.withOpacity(0.95),
            icon: Image.asset(
              'assets/icons/home.png',
              width: 25,
              color: pageIndex == 0 ? Color(0xFF3C55EF) : Colors.grey,
            ),
            label: 'Home',
          ),
          // BottomNavigationBarItem(
          //   backgroundColor: Colors.white.withOpacity(0.95),
          //   icon: Image.asset(
          //     'assets/icons/mart.png',
          //     width: 25,
          //     color: pageIndex == 1 ? Color(0xFF3C55EF) : Colors.grey,
          //   ),
          //   label: 'Stores',
          // ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/cart.png',
              width: 25,
              color: pageIndex == 1 ? Color(0xFF3C55EF) : Colors.grey,
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit,
                color: pageIndex == 2 ? Color(0xFF3C55EF) : Colors.grey),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined,
                color: pageIndex == 3 ? Color(0xFF3C55EF) : Colors.grey),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.money_dollar,
                color: pageIndex == 4 ? Color(0xFF3C55EF) : Colors.grey),
            label: 'Account',
          ),
        ],
      ),
      body: _pages[pageIndex],
    );
  }
}
