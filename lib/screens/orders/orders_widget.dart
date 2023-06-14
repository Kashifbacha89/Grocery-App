import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/inner_screens/product_detail_screen.dart';
import 'package:grocery_app/models/orders_model.dart';
import 'package:grocery_app/providers/product_provider.dart';
import 'package:grocery_app/services/global_methods.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:grocery_app/widgets/text_widgets.dart';
import 'package:provider/provider.dart';
class OrdersWidget extends StatefulWidget {
  const OrdersWidget({Key? key}) : super(key: key);

  @override
  State<OrdersWidget> createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends State<OrdersWidget> {
  late String orderDateToShow;
  @override
  void didChangeDependencies() {
    final ordersModel =Provider.of<OrderModel>(context);
    var orderDate =ordersModel.orderDate.toDate();
    orderDateToShow ='${orderDate.day}/${orderDate.month}/${orderDate.year}';
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    final ordersModel= Provider.of<OrderModel>(context);
    final productProvider= Provider.of<ProductProvider>(context);
    final getCurrProduct = productProvider.findProdById(ordersModel.productId);
    
    final Color color=Utils(context).color;
    Size size =Utils(context).getScreenSize;
    return ListTile(
      subtitle:  Text('Paid: \$${double.parse(ordersModel.price).toStringAsFixed(2)}'),
      onTap: (){
        GlobalMethod.navigateTo(ctx: context, routeName: ProductDetails.routeName);
      },
      leading: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: FancyShimmerImage(
          width: size.width*0.2,
          boxFit: BoxFit.fill,
          imageUrl: ordersModel.imageUrl,
        ),
      ),
      title: TextWidget(text: '${getCurrProduct.title}  x${ordersModel.quantity}',
          color: color, textSize: 18),
      trailing: TextWidget(text: orderDateToShow, color: color, textSize: 18),

    );
  }
}
