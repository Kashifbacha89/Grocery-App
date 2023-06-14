import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/consts/firebase_consts.dart';
import 'package:grocery_app/inner_screens/product_detail_screen.dart';
import 'package:grocery_app/models/viewed_model.dart';
import 'package:grocery_app/providers/cart_provider.dart';
import 'package:grocery_app/providers/product_provider.dart';
import 'package:grocery_app/providers/viewed_provider.dart';
import 'package:grocery_app/services/global_methods.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:grocery_app/widgets/text_widgets.dart';
import 'package:provider/provider.dart';
class ViewedRecentlyWidget extends StatefulWidget {
  const ViewedRecentlyWidget({Key? key}) : super(key: key);

  @override
  State<ViewedRecentlyWidget> createState() => _ViewedRecentlyWidgetState();
}

class _ViewedRecentlyWidgetState extends State<ViewedRecentlyWidget> {
  @override
  Widget build(BuildContext context) {
    final Color color=Utils(context).color;
    Size size= Utils(context).getScreenSize;
    final productProvider= Provider.of<ProductProvider>(context);
    final viewedProdModel=Provider.of<ViewedProdModel>(context);
    final viewedProdProvider=Provider.of<ViewedProvider>(context);
    final getCurrentProduct=productProvider.findProdById(viewedProdModel.productId);
    final cartProvider=Provider.of<CartProvider>(context);
    bool? _isInCart= cartProvider.getCartItems.containsKey(getCurrentProduct.id);
    double usedPrice = getCurrentProduct.isOnSale?
        getCurrentProduct.salePrice:getCurrentProduct.price;

    return Padding(padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: (){
          //GlobalMethod.navigateTo(ctx: context, routeName: ProductDetails.routeName);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FancyShimmerImage(
              width: size.width*0.27,
              height: size.width*0.25,
              boxFit: BoxFit.fill,
              imageUrl: getCurrentProduct.imageUrl,
            ),
            const SizedBox(width: 12,),
            Column(
              children: [
                TextWidget(text: getCurrentProduct.title, color: color, textSize: 24,isTitle: true,),
                const SizedBox(height: 12,),
                TextWidget(text: '\$${usedPrice.toStringAsFixed(2)}', color: color, textSize: 20,),
              ],
            ),
          const   Spacer(),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Material(
              borderRadius: BorderRadius.circular(12),
              color: Colors.green,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: _isInCart ? null:()async{
                  final User? user=authInstance.currentUser;
                  if(user==null){
                    GlobalMethod.errorDialog(subTitle: 'No user found ,please login first', context: context);
                    return;
                  }
                  await GlobalMethod.addToCart(
                      productId: getCurrentProduct.id,
                      quantity: 1,
                      context: context);
                  await cartProvider.fetchCart();
                  // cartProvider.addProductToCart(productId: getCurrentProduct.id,
                  //     quantity: 1);
                },
                child:  Padding(
                  padding:  const EdgeInsets.all(8.0),
                  child:  Icon(_isInCart? Icons.check
                      :IconlyBold.plus,
                  color: Colors.white,
                  size: 28,),

                ),
              ),
            ),),

          ],
        ),
      ),
    ) ;
  }
}

