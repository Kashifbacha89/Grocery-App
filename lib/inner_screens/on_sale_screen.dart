import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/models/product_model.dart';
import 'package:grocery_app/providers/product_provider.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:grocery_app/widgets/back_widget.dart';
import 'package:grocery_app/widgets/empty_product_widget.dart';
import 'package:grocery_app/widgets/on_sale_widget.dart';
import 'package:grocery_app/widgets/text_widgets.dart';
import 'package:provider/provider.dart';
class OnSaleScreen extends StatelessWidget {
  static const routeName='/onSaleScreen';
  const OnSaleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size=Utils(context).getScreenSize;
    final Color color=Utils(context).color;
    final productProviders= Provider.of<ProductProvider>(context);
    List<ProductModel> productsOnSale = productProviders.getOnSaleProducts;
    //bool isEmpty=false;
    return Scaffold(
      appBar: AppBar(
        leading: const BackWidget(),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: TextWidget(text: 'product on sale',color: color,textSize: 24,isTitle: true,),
      ),
      body: productsOnSale.isEmpty?const EmptyProductWidget(
        text: 'No product is on sale yet!\n stay tuned',
      ):GridView.count(crossAxisCount: 2,
        padding: EdgeInsets.zero,
        childAspectRatio: size.width/(size.height * 0.45),
      children: List.generate(productsOnSale.length, (index) {
        return ChangeNotifierProvider.value(
            value: productsOnSale[index],
            child: const OnSaleWidget());
      }),
      ),
    );
  }
}
