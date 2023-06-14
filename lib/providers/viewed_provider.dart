import 'package:flutter/cupertino.dart';
import 'package:grocery_app/models/cart_model.dart';
import 'package:grocery_app/models/viewed_model.dart';
import 'package:grocery_app/models/wishlisht_model.dart';

class ViewedProvider with ChangeNotifier {
  Map<String, ViewedProdModel> _viewedProdListItems = {};
  Map<String, ViewedProdModel> get getViewedProdListItems {
    return _viewedProdListItems;
  }
  void addProductToHistory({required String productId} ){

    _viewedProdListItems.putIfAbsent(productId,
            () => ViewedProdModel(id: DateTime.now().toString(),
                productId: productId));
  }

  void clearHistory(){
    _viewedProdListItems.clear();
    notifyListeners();
  }


}