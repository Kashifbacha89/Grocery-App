import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/consts/firebase_consts.dart';
import 'package:grocery_app/inner_screens/product_detail_screen.dart';
import 'package:grocery_app/models/product_model.dart';
import 'package:grocery_app/providers/cart_provider.dart';
import 'package:grocery_app/providers/wishlist_provider.dart';
import 'package:grocery_app/services/global_methods.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:grocery_app/widgets/heart_botton.dart';
import 'package:grocery_app/widgets/price_widget.dart';
import 'package:grocery_app/widgets/text_widgets.dart';
import 'package:provider/provider.dart';

class OnSaleWidget extends StatefulWidget {
  const OnSaleWidget({Key? key}) : super(key: key);

  @override
  State<OnSaleWidget> createState() => _OnSaleWidgetState();
}

class _OnSaleWidgetState extends State<OnSaleWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    Size size = Utils(context).getScreenSize;
    final Color color = Utils(context).color;
    final productModel = Provider.of<ProductModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    bool? _isInCart = cartProvider.getCartItems.containsKey(productModel.id);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? _isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(productModel.id);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor.withOpacity(0.9),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.pushNamed(context, ProductDetails.routeName,
                arguments: productModel.id);
            //GlobalMethod.navigateTo(ctx: context, routeName: ProductDetails.routeName);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FancyShimmerImage(
                      width: size.width * 0.22,
                      height: size.height * 0.22,
                      imageUrl: productModel.imageUrl,
                      boxFit: BoxFit.cover,
                    ),
                    Column(
                      children: [
                        TextWidget(
                          text: productModel.isPiece ? '1Piece' : '1KG',
                          color: color,
                          textSize: 22,
                          isTitle: true,
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: _isInCart
                                  ? null
                                  : () async{
                                final User? user=authInstance.currentUser;
                                if(user==null){
                                  GlobalMethod.errorDialog(subTitle: 'No user found ,please login first',
                                      context: context);
                                  return;
                                }

                                await GlobalMethod.addToCart(productId: productModel.id,
                                    quantity: 1, context: context);
                               await cartProvider.fetchCart();
                                      // cartProvider.addProductToCart(
                                      //     productId: productModel.id,
                                      //     quantity: 1);
                                    },
                              child: Icon(
                                _isInCart ? IconlyBold.bag2 : IconlyLight.bag2,
                                color: _isInCart ? Colors.green : color,
                                size: 22,
                              ),
                            ),
                            HeartBTN(
                              productId: productModel.id,
                              isInWishlist: _isInWishlist,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                PriceWidget(
                  salePrice: productModel.salePrice,
                  price: productModel.price,
                  textPrice: '1',
                  isOnSale: true,
                ),
                const SizedBox(
                  height: 5,
                ),
                TextWidget(
                  text: productModel.title,
                  color: color,
                  textSize: 16,
                  isTitle: true,
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
