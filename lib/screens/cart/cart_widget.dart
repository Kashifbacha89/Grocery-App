import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_app/inner_screens/product_detail_screen.dart';
import 'package:grocery_app/models/cart_model.dart';
import 'package:grocery_app/models/product_model.dart';
import 'package:grocery_app/providers/cart_provider.dart';
import 'package:grocery_app/providers/product_provider.dart';
import 'package:grocery_app/providers/wishlist_provider.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:grocery_app/widgets/heart_botton.dart';
import 'package:grocery_app/widgets/text_widgets.dart';
import 'package:provider/provider.dart';

class CartWidget extends StatefulWidget {
  const CartWidget({Key? key, required this.q}) : super(key: key);
  final int q;

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  final TextEditingController _quantityTextController = TextEditingController();
  @override
  void initState() {
    _quantityTextController.text = widget.q.toString();
    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final productProvider = Provider.of<ProductProvider>(context);
    final cartModel = Provider.of<CartModel>(context);
    final getCurrentProduct = productProvider.findProdById(cartModel.productId);
    double usedPrice = getCurrentProduct.isOnSale
        ? getCurrentProduct.salePrice
        : getCurrentProduct.price;
    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? _isInWishlist = wishlistProvider.getWishlistItems.containsKey(getCurrentProduct.id);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ProductDetails.routeName,
        arguments:  cartModel.productId);
      },
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).backgroundColor,
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      height: size.width * 0.25,
                      width: size.width * 0.25,
                      child: FancyShimmerImage(
                        boxFit: BoxFit.fill,
                        imageUrl: getCurrentProduct.imageUrl,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          text: getCurrentProduct.title,
                          color: color,
                          textSize: 22,
                          isTitle: true,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          width: size.width * 0.3,
                          child: Row(
                            children: [
                              quantityController(
                                  fct: () {
                                    if (_quantityTextController.text == '1') {
                                      return;
                                    } else {
                                      setState(() {
                                        _quantityTextController.text =
                                            (int.parse(_quantityTextController
                                                        .text) -
                                                    1)
                                                .toString();
                                      });
                                    }
                                  },
                                  icon: CupertinoIcons.minus,
                                  color: Colors.red),
                              Flexible(
                                flex: 1,
                                child: TextFormField(
                                  controller: _quantityTextController,
                                  keyboardType: TextInputType.number,
                                  maxLines: 1,
                                  decoration: const InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(),
                                  )),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9]')),
                                  ],
                                  onChanged: (v) {
                                    setState(() {
                                      if (v.isEmpty) {
                                        _quantityTextController.text = '1';
                                      } else {
                                        return;
                                      }
                                    });
                                  },
                                ),
                              ),
                              quantityController(
                                  fct: () {
                                    cartProvider.increaseQuantityByOne(cartModel.productId);
                                    setState(() {

                                      _quantityTextController.text = (int.parse(
                                                  _quantityTextController
                                                      .text) +
                                              1)
                                          .toString();
                                    });
                                  },
                                  icon: CupertinoIcons.plus,
                                  color: Colors.green),
                            ],
                          ),
                        )
                      ],
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () async{
                              await cartProvider.removeOneItem(cartId: cartModel.id,productId: cartModel.productId,
                              quantity: cartModel.quantity);
                            },
                            child: const Icon(
                              CupertinoIcons.cart_badge_minus,
                              size: 20,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                           HeartBTN(
                            productId: getCurrentProduct.id,
                             isInWishlist: _isInWishlist,
                          ),
                          TextWidget(
                            text: '\$${(usedPrice* int.parse(_quantityTextController.text)).toStringAsFixed(2)}',
                            color: color,
                            textSize: 18,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
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
