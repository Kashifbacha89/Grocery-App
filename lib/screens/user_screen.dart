/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/consts/firebase_consts.dart';
import 'package:grocery_app/provider/dark_theme_provider.dart';
import 'package:grocery_app/screens/auth/forgot_password.dart';
import 'package:grocery_app/screens/auth/login.dart';
import 'package:grocery_app/screens/loading_manager.dart';
import 'package:grocery_app/screens/orders/orders_screen.dart';
import 'package:grocery_app/screens/viewed_recently/viewed_recently_screen.dart';
import 'package:grocery_app/screens/wishlist/wishlist_screen.dart';
import 'package:grocery_app/services/global_methods.dart';
import 'package:grocery_app/widgets/text_widgets.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  TextEditingController _addressTextController =
      TextEditingController(text: '');
  @override
  void dispose() {
    _addressTextController;
    super.dispose();
  }

  bool _isLoading = false;
  String? _email;
  String? _name;
  String? address;
  final User? user = authInstance.currentUser;
  @override
  void initState() {
    getUserData();

    super.initState();
  }

  //fetch User information from Firestore database
  Future<void> getUserData() async {
    setState(() {
      _isLoading = true;
    });
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    try {
      String _uid = user!.uid;
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(_uid).get();
      if (user == null) {
        return;
      } else {
        _email = userDoc.get('email');
        _name = userDoc.get('name');
        address = userDoc.get('shipping-address');
        _addressTextController.text = userDoc.get('shipping-address');
      }
    } catch (error) {
      GlobalMethod.errorDialog(subTitle: '$error', context: context);
      setState(() {
        _isLoading = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black87;

    return Scaffold(
        body: LoadingManager(
      isLoading: _isLoading,
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 15,
                ),
                RichText(
                    text: TextSpan(
                        text: 'Hi, ',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.cyan,
                            fontSize: 28),
                        children: <TextSpan>[
                      TextSpan(
                        text: _name == null ? 'User' : _name,
                        style: TextStyle(
                            color: color,
                            fontSize: 25,
                            fontWeight: FontWeight.w600),
                      )
                    ])),

                TextWidget(
                    text: _email == null ? ' User-Email' : _email!,
                    color: color,
                    textSize: 18),
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  thickness: 3,
                ),
                _listTiles(
                    title: 'Address',
                    icon: IconlyLight.profile,
                    subtitle: address!,
                    color: color,
                    onPressed: () async {
                      await _showAddressDialog();
                    }),
                _listTiles(
                    title: 'Orders',
                    subtitle: '',
                    icon: IconlyLight.bag,
                    color: color,
                    onPressed: () {
                      GlobalMethod.navigateTo(
                          ctx: context, routeName: OrdersScreen.routeName);
                    }),
                _listTiles(
                    title: 'Wishlist',
                    subtitle: '',
                    icon: IconlyLight.heart,
                    color: color,
                    onPressed: () {
                      GlobalMethod.navigateTo(
                          ctx: context, routeName: WishlistScreen.routeName);
                    }),
                _listTiles(
                    title: 'Viewed',
                    subtitle: '',
                    icon: IconlyLight.show,
                    color: color,
                    onPressed: () {
                      GlobalMethod.navigateTo(
                          ctx: context,
                          routeName: ViewedRRecentlyScreen.routeName);
                    }),
                _listTiles(
                    title: 'Forgot Password',
                    subtitle: '',
                    icon: IconlyLight.unlock,
                    color: color,
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (_) => const ForgotPasswordScreen()));
                    }),
                //Dark theme section
                SwitchListTile(
                  title: TextWidget(
                      text:
                          themeState.getDarkTheme ? 'Dark mode' : 'Light mode',
                      color: color,
                      textSize: 18),
                  secondary: themeState.getDarkTheme
                      ? Icon(Icons.dark_mode_outlined)
                      : Icon(Icons.light_mode_outlined),
                  onChanged: (bool value) {
                    setState(() {
                      themeState.setDarkTheme = value;
                    });
                  },
                  value: themeState.getDarkTheme,
                ),
                _listTiles(
                    title: user == null ? 'Login' : 'Logout',
                    subtitle: '',
                    icon: user == null ? IconlyLight.login : IconlyLight.logout,
                    color: color,
                    onPressed: () async {
                      if (user == null) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (_) => const LoginScreen()));
                        return;
                      }
                      GlobalMethod.warningDialog(
                          title: 'sign out',
                          subTitle: 'Do you wanna sign out?',
                          fct: () async {
                            await authInstance.signOut();
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (_) => const LoginScreen()));
                          },
                          context: context);
                    }),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Future<void> _showAddressDialog() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Update'),
            content: TextField(
              controller: _addressTextController,
              onChanged: (value) {
                // _addressTextController.text;
              },
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Your Address',
              ),
            ),
            actions: [
              TextButton(onPressed: () async {
                String _uid= user!.uid;
                try{
                  await FirebaseFirestore.instance.collection('users').doc(_uid).update({
                    'shipping-address' :_addressTextController.text,
                  });
                  Navigator.pop(context);
                  setState(() {
                    address=_addressTextController.text;
                  });
                }catch(error){
                  GlobalMethod.errorDialog(subTitle: error.toString(), context: context);
                }
              }, child: const Text('Update'))
            ],
          );
        });
  }

  Widget _listTiles({
    required String title,
    required String subtitle,
    required IconData icon,
    required Function onPressed,
    required Color color,
  }) {
    return ListTile(
      title: TextWidget(text: title, color: color, textSize: 22),
      subtitle: TextWidget(
          text: subtitle == null ? '' : subtitle, color: color, textSize: 18),
      leading: Icon(icon),
      trailing: const Icon(IconlyLight.arrowRight2),
      onTap: () {
        onPressed();
      },
    );
  }
}*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/consts/firebase_consts.dart';
import 'package:grocery_app/screens/auth/forgot_password.dart';
import 'package:grocery_app/screens/loading_manager.dart';
import 'package:grocery_app/screens/orders/orders_screen.dart';
import 'package:grocery_app/screens/wishlist/wishlist_screen.dart';
import 'package:grocery_app/services/global_methods.dart';
import 'package:grocery_app/widgets/text_widgets.dart';
import 'package:provider/provider.dart';
import '../provider/dark_theme_provider.dart';
import 'auth/login.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final TextEditingController _addressTextController =
  TextEditingController(text: "");
  @override
  void dispose() {
    _addressTextController.dispose();
    super.dispose();
  }

  String? _email;
  String? _name;
  String? address;
  bool _isLoading = false;
  final User? user = authInstance.currentUser;
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  Future<void> getUserData() async {
    setState(() {
      _isLoading = true;
    });
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    try {
      String _uid = user!.uid;

      final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(_uid).get();
      if (userDoc == null) {
        return;
      } else {
        _email = userDoc.get('email');
        _name = userDoc.get('name');
        address = userDoc.get('shipping-address');
        _addressTextController.text = userDoc.get('shipping-address');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      GlobalMethod.errorDialog(subTitle: '$error', context: context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    return Scaffold(
        body: LoadingManager(
          isLoading: _isLoading,
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Hi,  ',
                        style: const TextStyle(
                          color: Colors.cyan,
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: _name == null ? 'user' : _name,
                              style: TextStyle(
                                color: color,
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  print('My name is pressed');
                                }),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextWidget(
                      text: _email == null ? 'Email' : _email!,
                      color: color,
                      textSize: 18,
                      // isTitle: true,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    _listTiles(
                      title: 'Address 2',
                      subtitle: address,
                      icon: IconlyLight.profile,
                      onPressed: () async {
                        await _showAddressDialog();
                      },
                      color: color,
                    ),
                    _listTiles(
                      title: 'Orders',
                      icon: IconlyLight.bag,
                      onPressed: () {
                        GlobalMethod.navigateTo(
                            ctx: context, routeName: OrdersScreen.routeName);
                      },
                      color: color,
                    ),
                    _listTiles(
                      title: 'Wishlist',
                      icon: IconlyLight.heart,
                      onPressed: () {
                        GlobalMethod.navigateTo(
                            ctx: context, routeName: WishlistScreen.routeName);
                      },
                      color: color,
                    ),
                    _listTiles(
                      title: 'Viewed',
                      icon: IconlyLight.show,
                      onPressed: () {
                        // GlobalMethod.navigateTo(
                        //     ctx: context,
                        //     routeName: ViewedRecentlyScreen.routeName);
                      },
                      color: color,
                    ),
                    _listTiles(
                      title: 'Forget password',
                      icon: IconlyLight.unlock,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      color: color,
                    ),
                    SwitchListTile(
                      title: TextWidget(
                        text: themeState.getDarkTheme ? 'Dark mode' : 'Light mode',
                        color: color,
                        textSize: 18,
                        // isTitle: true,
                      ),
                      secondary: Icon(themeState.getDarkTheme
                          ? Icons.dark_mode_outlined
                          : Icons.light_mode_outlined),
                      onChanged: (bool value) {
                        setState(() {
                          themeState.setDarkTheme = value;
                        });
                      },
                      value: themeState.getDarkTheme,
                    ),
                    _listTiles(
                      title: user == null ? 'Login' : 'Logout',
                      icon: user == null ? IconlyLight.login : IconlyLight.logout,
                      onPressed: () {
                        if (user == null) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                          return;
                        }
                        GlobalMethod.warningDialog(
                            title: 'Sign out',
                            subTitle: 'Do you wanna sign out?',
                            fct: () async {
                              await authInstance.signOut();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            context: context);
                      },
                      color: color,
                    ),
                    // listTileAsRow(),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Future<void> _showAddressDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Update'),
            content: TextField(
              // onChanged: (value) {
              //   print('_addressTextController.text ${_addressTextController.text}');
              // },
              controller: _addressTextController,
              maxLines: 5,
              decoration: const InputDecoration(hintText: "Your address"),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  String _uid = user!.uid;
                  try {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(_uid)
                        .update({
                      'shipping-address': _addressTextController.text,
                    });

                    Navigator.pop(context);
                    setState(() {
                      address = _addressTextController.text;
                    });
                  } catch (err) {
                    GlobalMethod.errorDialog(
                        subTitle: err.toString(), context: context);
                  }
                },
                child: const Text('Update'),
              ),
            ],
          );
        });
  }

  Widget _listTiles({
    required String title,
    String? subtitle,
    required IconData icon,
    required Function onPressed,
    required Color color,
  }) {
    return ListTile(
      title: TextWidget(
        text: title,
        color: color,
        textSize: 22,
        // isTitle: true,
      ),
      subtitle: TextWidget(
        text: subtitle == null ? "" : subtitle,
        color: color,
        textSize: 18,
      ),
      leading: Icon(icon),
      trailing: const Icon(IconlyLight.arrowRight2),
      onTap: () {
        onPressed();
      },
    );
  }

// // Alternative code for the listTile.
//   Widget listTileAsRow() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         children: <Widget>[
//           const Icon(Icons.settings),
//           const SizedBox(width: 10),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: const [
//               Text('Title'),
//               Text('Subtitle'),
//             ],
//           ),
//           const Spacer(),
//           const Icon(Icons.chevron_right)
//         ],
//       ),
//     );
//   }
}

