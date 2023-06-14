import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_app/consts/firebase_consts.dart';
import 'package:grocery_app/providers/cart_provider.dart';
import 'package:grocery_app/providers/orders_provider.dart';
import 'package:grocery_app/providers/product_provider.dart';
import 'package:grocery_app/screens/cart/cart_widget.dart';
import 'package:grocery_app/services/global_methods.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:grocery_app/widgets/empty_screen.dart';
import 'package:grocery_app/widgets/text_widgets.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItemsList =
        cartProvider.getCartItems.values.toList().reversed.toList();

    //bool _isEmpty=false;

    return cartItemsList.isEmpty
        ? const EmptyScreen(
            title: 'Your cart is empty',
            subtitle: 'Add something and make me happy :)',
            buttonText: 'Shop now',
            imagePath: 'assets/images/cart.png',
          )
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: TextWidget(
                  text: 'cart (${cartItemsList.length})',
                  color: color,
                  textSize: 22,
                  isTitle: true),
              actions: [
                IconButton(
                    onPressed: () {
                      GlobalMethod.warningDialog(
                          title: 'Empty your cart',
                          subTitle: 'Are you sure?',
                          fct: () async {
                            await cartProvider.clearCartOnline();
                            cartProvider.clearLocalCart();
                          },
                          context: context);
                    },
                    icon: Icon(
                      IconlyBroken.delete,
                      color: color,
                    )),
              ],
            ),
            body: Column(
              children: [
                _checkOut(ctx: context),
                Expanded(
                  child: ListView.builder(
                      itemCount: cartItemsList.length,
                      itemBuilder: (context, index) {
                        return ChangeNotifierProvider.value(
                            value: cartItemsList[index],
                            child: CartWidget(
                              q: cartItemsList[index].quantity,
                            ));
                      }),
                ),
              ],
            ));
  }

  Widget _checkOut({required BuildContext ctx}) {
    Size size = Utils(ctx).getScreenSize;
    final Color color = Utils(ctx).color;
    final cartProvider = Provider.of<CartProvider>(ctx);
    final productProvider = Provider.of<ProductProvider>(ctx);
    final ordersProvider= Provider.of<OrdersProvider>(ctx);
    double total = 0.0;
    cartProvider.getCartItems.forEach((key, value) {
      final getCurrProduct = productProvider.findProdById(value.productId);
      total += (getCurrProduct.isOnSale
              ? getCurrProduct.salePrice
              : getCurrProduct.price) *
          value.quantity;
    });
    return SizedBox(
      width: double.infinity,
      height: size.height * 0.1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Material(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                // store orders data to firebase
                onTap: () async {
                  User? user = authInstance.currentUser;
                  final orderId = const Uuid().v4();
                  final productProvider = Provider.of<ProductProvider>(ctx,listen: false);

                  cartProvider.getCartItems.forEach((key, value) async {
                    final getCurrProduct =
                        productProvider.findProdById(value.productId);
                    try {
                      await FirebaseFirestore.instance
                          .collection('orders')
                          .doc(orderId)
                          .set({
                        'orderId': orderId,
                        'userId': user!.uid,
                        'productId': value.productId,
                        'price': (getCurrProduct.isOnSale
                                ? getCurrProduct.salePrice
                                : getCurrProduct.price) *
                            value.quantity,
                        'total':total,
                        'quantity':value.quantity,
                        'imageUrl':getCurrProduct.imageUrl,
                        'userName':user.displayName,
                        'orderDate': Timestamp.now(),
                      });
                      await cartProvider.clearCartOnline();
                      cartProvider.clearLocalCart();
                      ordersProvider.fetchOrders();
                      Fluttertoast.showToast(msg: 'your order has been placed',
                      gravity: ToastGravity.CENTER,
                        toastLength: Toast.LENGTH_SHORT,
                      );
                    } catch (error) {
                      GlobalMethod.errorDialog(
                          subTitle: error.toString(), context: ctx);
                    } finally {}
                  });
                },
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextWidget(
                    text: 'Order Now',
                    textSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const Spacer(),
            FittedBox(
              child: TextWidget(
                text: 'Total: \$${total.toStringAsFixed(2)}',
                color: color,
                textSize: 18,
                isTitle: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
