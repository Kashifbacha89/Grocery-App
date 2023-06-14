import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/consts/firebase_consts.dart';
import 'package:grocery_app/providers/cart_provider.dart';
import 'package:grocery_app/providers/product_provider.dart';
import 'package:grocery_app/providers/viewed_provider.dart';
import 'package:grocery_app/providers/wishlist_provider.dart';
import 'package:grocery_app/services/global_methods.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:grocery_app/widgets/heart_botton.dart';
import 'package:grocery_app/widgets/text_widgets.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  static const routeName = '/ProductDetails';
  const ProductDetails({Key? key}) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final _quantityTextController = TextEditingController(text: '1');
  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final productProviders = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final getCurrentProduct = productProviders.findProdById(productId);
    double usedPrice = getCurrentProduct.isOnSale
        ? getCurrentProduct.salePrice
        : getCurrentProduct.price;
    double totalPrice = usedPrice * int.parse(_quantityTextController.text);
    bool? _isInCart=cartProvider.getCartItems.containsKey(getCurrentProduct.id);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? _isInWishlist = wishlistProvider.getWishlistItems.containsKey(getCurrentProduct.id);
    final viewedProdProvider= Provider.of<ViewedProvider>(context);

    return WillPopScope(
      onWillPop: ()async {
        viewedProdProvider.addProductToHistory(productId: productId);
        return true;

      },
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.canPop(context) ? Navigator.pop(context) : null;
            },
            child: Icon(
              IconlyLight.arrowLeft2,
              color: color,
              size: 24,
            ),
          ),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: Column(
          children: [
            Flexible(
              flex: 2,
              child: FancyShimmerImage(
                imageUrl: getCurrentProduct.imageUrl,
                boxFit: BoxFit.scaleDown,
                width: size.width,
                // height: size.width*0.2,
              ),
            ),
            Flexible(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      )),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 20, left: 30, right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: TextWidget(
                                text: getCurrentProduct.title,
                                color: color,
                                textSize: 25,
                                isTitle: true,
                              ),
                            ),
                             HeartBTN(
                              productId: getCurrentProduct.id,
                               isInWishlist: _isInWishlist,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 20, left: 30, right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextWidget(
                              text: '\$${usedPrice.toStringAsFixed(2)}/',
                              color: Colors.green,
                              textSize: 22,
                              isTitle: true,
                            ),
                            TextWidget(
                              text: getCurrentProduct.isPiece ? 'Piece' : '/Kg',
                              color: color,
                              textSize: 12,
                              isTitle: false,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Visibility(
                              visible: getCurrentProduct.isOnSale?true:false,
                              child: Text(
                                '\$${getCurrentProduct.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                    color: color,
                                    fontSize: 15,
                                    decoration: TextDecoration.lineThrough),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(63, 200, 101, 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: TextWidget(
                                text: 'Free delivery',
                                color: color,
                                textSize: 20,
                                isTitle: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          quantityController(
                              fct: () {
                                if (_quantityTextController.text == '1') {
                                  return;
                                } else {
                                  setState(() {
                                    _quantityTextController.text =
                                        (int.parse(_quantityTextController.text) -
                                                1)
                                            .toString();
                                  });
                                }
                              },
                              icon: CupertinoIcons.minus,
                              color: Colors.red),
                          Flexible(
                              flex: 1,
                              child: TextField(
                                controller: _quantityTextController,
                                key: const ValueKey('quantity'),
                                keyboardType: TextInputType.number,
                                maxLines: 1,
                                decoration: const InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(),
                                  ),
                                ),
                                textAlign: TextAlign.center,
                                cursorColor: Colors.green,
                                enabled: true,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[0-9]')),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    if (value.isEmpty) {
                                      _quantityTextController.text = '1';
                                    } else {}
                                  });
                                },
                              )),
                          quantityController(
                              fct: () {
                                setState(() {
                                  _quantityTextController.text =
                                      (int.parse(_quantityTextController.text) +
                                              1)
                                          .toString();
                                });
                              },
                              icon: CupertinoIcons.plus,
                              color: Colors.green),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 30),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20),
                            )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget(
                                    text: 'Total',
                                    color: Colors.red.shade300,
                                    textSize: 20,
                                    isTitle: true,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  FittedBox(
                                    child: Row(
                                      children: [
                                        TextWidget(
                                          text: '\$${totalPrice.toStringAsFixed(2)}/',
                                          color: color,
                                          textSize: 22,
                                          isTitle: true,
                                        ),
                                        TextWidget(
                                          text:
                                              '${_quantityTextController.text}kg',
                                          color: color,
                                          textSize: 12,
                                          isTitle: false,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Flexible(
                              child: Material(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(10),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: _isInCart? null:() async{
                                    final User? user=authInstance.currentUser;
                                    if(user==null){
                                      GlobalMethod.errorDialog(subTitle: 'No user found ,please login first', context: context);
                                    return;
                                    }

                                    await GlobalMethod.addToCart(
                                        productId: getCurrentProduct.id,
                                        quantity: int.parse(_quantityTextController.text),
                                        context: context);
                                    await cartProvider.fetchCart();
                                    // cartProvider.addProductToCart(productId: getCurrentProduct.id,
                                    //     quantity: int.parse(_quantityTextController.text));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: TextWidget(
                                        text: _isInCart?'In Cart':'Add to Cart',
                                        color: Colors.white,
                                        textSize: 18),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget quantityController(
      {required Function fct, required IconData icon, required Color color}) {
    return Flexible(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Material(
          color: color,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: () {
              fct();
            },
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
