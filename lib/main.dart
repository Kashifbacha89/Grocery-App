import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/consts/theme_data.dart';
import 'package:grocery_app/fetch_screen.dart';
import 'package:grocery_app/inner_screens/categories_screen.dart';
import 'package:grocery_app/inner_screens/feeds_screen.dart';
import 'package:grocery_app/inner_screens/on_sale_screen.dart';
import 'package:grocery_app/inner_screens/product_detail_screen.dart';
import 'package:grocery_app/provider/dark_theme_provider.dart';
import 'package:grocery_app/providers/cart_provider.dart';
import 'package:grocery_app/providers/orders_provider.dart';
import 'package:grocery_app/providers/product_provider.dart';
import 'package:grocery_app/providers/viewed_provider.dart';
import 'package:grocery_app/providers/wishlist_provider.dart';
import 'package:grocery_app/screens/auth/forgot_password.dart';
import 'package:grocery_app/screens/auth/login.dart';
import 'package:grocery_app/screens/auth/register.dart';
import 'package:grocery_app/screens/orders/orders_screen.dart';
import 'package:grocery_app/screens/viewed_recently/viewed_recently_screen.dart';
import 'package:grocery_app/screens/wishlist/wishlist_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatefulWidget {
   MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  DarkThemeProvider themeChangeProvider=DarkThemeProvider();

  void getCurrentAppTheme()  async{
    themeChangeProvider.setDarkTheme= await
    themeChangeProvider.darkThemePrefs.getTheme();

  }
  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }
  final Future<FirebaseApp>_firebaseInitialization=Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    bool isDark=true;

    return FutureBuilder(
      future: _firebaseInitialization,
      builder: (context,snapshot) {
        if(snapshot.connectionState==ConnectionState.waiting){
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
            body: Center(child: CircularProgressIndicator(),),
          ),);
        }else if(snapshot.hasError){
          return const  MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Text('A error has occurred'),
              ),
            ),
          );
        }
        return MultiProvider(

          providers: [
            ChangeNotifierProvider(create: (_){
              return themeChangeProvider;
            }),
            ChangeNotifierProvider(create: (_){
              return ProductProvider();
            }),
            ChangeNotifierProvider(create: (_){
              return CartProvider();
            }),
            ChangeNotifierProvider(create: (_){
              return WishlistProvider();
            }),
            ChangeNotifierProvider(create: (_){
              return ViewedProvider();
            }),
            ChangeNotifierProvider(create: (_){
              return OrdersProvider();
            }),
          ],
          child: Consumer<DarkThemeProvider>(
            builder: (context,themeProvider,child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Flutter Demo',
                theme: Styles.themeData(themeProvider.getDarkTheme,context),
                home: const FetchScreen(),
                routes: {
                  OnSaleScreen.routeName:(context)=> const OnSaleScreen(),
                  FeedsScreen.routeName:(context)=> const FeedsScreen(),
                  ProductDetails.routeName:(context)=>const ProductDetails(),
                  WishlistScreen.routeName:(context)=> const WishlistScreen(),
                  OrdersScreen.routeName:(context)=> const OrdersScreen(),
                  ViewedRRecentlyScreen.routeName:(context)=> const ViewedRRecentlyScreen(),
                  RegisterScreen.routeName:(context)=> const RegisterScreen(),
                  LoginScreen.routeName:(context)=> const LoginScreen(),
                  ForgotPasswordScreen.routeName:(context)=>const ForgotPasswordScreen(),
                  CategoryScreen.routeName:(context)=> const CategoryScreen(),
                },
              );
            }
          ),
        );
      }
    );
  }
}

