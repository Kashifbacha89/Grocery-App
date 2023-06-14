

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/consts/firebase_consts.dart';
import 'package:grocery_app/providers/product_provider.dart';
import 'package:grocery_app/providers/wishlist_provider.dart';
import 'package:grocery_app/services/global_methods.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:provider/provider.dart';

class HeartBTN extends StatefulWidget {
  const HeartBTN({Key? key, required this.productId, this.isInWishlist = false})
      : super(key: key);
  final String productId;
  final bool? isInWishlist;

  @override
  State<HeartBTN> createState() => _HeartBTNState();
}

class _HeartBTNState extends State<HeartBTN> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    final productProvider = Provider.of<ProductProvider>(context);
    final getCurrProduct = productProvider.findProdById(widget.productId);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    return GestureDetector(
      onTap: () async {
        setState(() {
          loading = true;
        });
        try {
          final User? user = authInstance.currentUser;
          if (user == null) {
            GlobalMethod.errorDialog(
                subTitle: 'No user found ,please login first',
                context: context);
            return;
          }
          if (widget.isInWishlist == false && widget.isInWishlist != null) {
            await GlobalMethod.addToWishlist(
                productId: widget.productId, context: context);
          } else {
            await wishlistProvider.removeOneItem(
                wishlistId:
                    wishlistProvider.getWishlistItems[getCurrProduct.id]!.id,
                productId: widget.productId);
          }
          await wishlistProvider.fetchWishlist();
          setState(() {
            loading = false;
          });
        } catch (error) {
          GlobalMethod.errorDialog(subTitle: '$error', context: context);
        } finally {
          setState(() {
            setState(() {
              loading = false;
            });
          });
        }
      },
      // wishlistProvider.addRemoveProductToWishlist(productId: productId);

      child: loading
          ? const Padding(
            padding:  EdgeInsets.all(8.0),
            child:  SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(),
              ),
          )
          : Icon(
              widget.isInWishlist != null && widget.isInWishlist == true
                  ? IconlyBold.heart
                  : IconlyLight.heart,
              color: widget.isInWishlist != null && widget.isInWishlist == true
                  ? Colors.red
                  : color,
              size: 22,
            ),
    );
  }
}
