import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishlistModel with ChangeNotifier{
  final String id, productId;


  WishlistModel({
    required this.id,
    required this.productId,
    });
}