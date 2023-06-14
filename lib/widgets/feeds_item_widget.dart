import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class FeedsWidget extends StatefulWidget {
  const FeedsWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<FeedsWidget> createState() => _FeedsWidgetState();
}

class _FeedsWidgetState extends State<FeedsWidget> {
  TextEditingController _quantityTextController = TextEditingController();
  @override
  void initState() {
    _quantityTextController.text = '1';
    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final Color color = Utils(context).color;
    final productModel = Provider.of<ProductModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    bool? _isInCart = cartProvider.getCartItems.containsKey(productModel.id);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? _isInWishlist = wishlistProvider.getWishlistItems.containsKey(productModel.id);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            //GlobalMethod.navigateTo(ctx: context, routeName: ProductDetails.routeName);
            Navigator.pushNamed(context, ProductDetails.routeName,
                arguments: productModel.id);
          },
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: [
              FancyShimmerImage(
                imageUrl: productModel.imageUrl,
                boxFit: BoxFit.fill,
                width: size.width * 0.21,
                height: size.width * 0.2,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 3,
                      child: TextWidget(
                        text: productModel.title,
                        color: color,
                        maxLines: 1,
                        textSize: 18,
                        isTitle: true,
                      ),
                    ),
                     Flexible(flex: 1, child: HeartBTN(
                      productId: productModel.id,
                       isInWishlist: _isInWishlist,

                    )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 3,
                      child: PriceWidget(
                        salePrice: productModel.salePrice,
                        price: productModel.price,
                        textPrice: _quantityTextController.text,
                        isOnSale: productModel.isOnSale,
                      ),
                    ),
                    Flexible(
                      flex: 6,
                      child: Row(
                        children: [
                          FittedBox(
                            child: TextWidget(
                              color: color,
                              textSize: 20,
                              text: productModel.isPiece ? 'Piece' : 'Kg',
                              isTitle: true,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Flexible(
                              flex: 2,
                              child: TextFormField(
                                controller: _quantityTextController,
                                key: const ValueKey('10'),
                                style: TextStyle(
                                  color: color,
                                  fontSize: 18,
                                ),
                                keyboardType: TextInputType.number,
                                maxLines: 1,
                                enabled: true,
                                onChanged: (valuee) {
                                  setState(() {});
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[0-9. ]'))
                                ],
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: _isInCart? null:() async{
                   /* if(_isInCart){
                      return;
                    }*/
                    final User? user=authInstance.currentUser;
                    if(user==null){
                      GlobalMethod.errorDialog(subTitle: 'No user found ,please login first',
                          context: context);
                      return;
                    }
                    await GlobalMethod.addToCart(productId: productModel.id,
                        quantity: int.parse(_quantityTextController.text),
                        context: context);
                    await cartProvider.fetchCart();
                    // cartProvider.addProductToCart(productId: productModel.id,
                    //     quantity: int.parse(_quantityTextController.text));
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.lightBlue),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12.0),
                        bottomRight: Radius.circular(12.0),
                      )))),
                  child: TextWidget(
                      text: _isInCart? 'In cart':'Add to cart', color: color, textSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
