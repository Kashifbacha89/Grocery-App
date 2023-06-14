import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/inner_screens/product_detail_screen.dart';
import 'package:grocery_app/models/wishlisht_model.dart';
import 'package:grocery_app/providers/product_provider.dart';
import 'package:grocery_app/providers/wishlist_provider.dart';
import 'package:grocery_app/services/global_methods.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:grocery_app/widgets/heart_botton.dart';
import 'package:grocery_app/widgets/text_widgets.dart';
import 'package:provider/provider.dart';
class WishlistWidget extends StatelessWidget {
  const WishlistWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color=Utils(context).color;
    Size size=Utils(context).getScreenSize;
    final wishlistModel = Provider.of<WishlistModel>(context);
    final productProvider= Provider.of<ProductProvider>(context);
    final getCurrentProduct=productProvider.findProdById(wishlistModel.productId);
    final wishlistProvider =Provider.of<WishlistProvider>(context);
    bool? _isInWishlist =wishlistProvider.getWishlistItems.containsKey(getCurrentProduct.id);
    double usedPrice = getCurrentProduct.isOnSale
        ? getCurrentProduct.salePrice
        : getCurrentProduct.price;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: (){
          Navigator.pushNamed(context, ProductDetails.routeName,
          arguments: wishlistModel.productId
          );
        },

          child: Container(
            height: size.height*0.20,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border.all(color: color,width: 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  width: size.width*0.2,
                  height: size.width*0.25,
                  child: FancyShimmerImage(imageUrl:getCurrentProduct.imageUrl,
                    boxFit: BoxFit.fill,
                  ),


                ),
                Flexible(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            IconButton(onPressed: (){},
                              icon: Icon(IconlyLight.bag2,color: color,),
                            ),
                             HeartBTN(
                              productId: getCurrentProduct.id,
                              isInWishlist: _isInWishlist,
                            ),
                          ],
                        ),
                      ),
                      TextWidget(
                        text: getCurrentProduct.title, color: color, textSize: 20,maxLines: 1,isTitle: true,),
                      const SizedBox(height: 5,),
                      TextWidget(
                        text: '\$${usedPrice.toStringAsFixed(2)}', color: color, textSize: 18.0,maxLines: 1,isTitle: true,),
                    ],
                  ),
                ),
              ],
            ),

          )),
    );
  }
}
