import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/providers/orders_provider.dart';
import 'package:grocery_app/screens/orders/orders_widget.dart';
import 'package:grocery_app/services/global_methods.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:grocery_app/widgets/back_widget.dart';
import 'package:grocery_app/widgets/empty_screen.dart';
import 'package:grocery_app/widgets/text_widgets.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = "/OrdersScreen";
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final orderList = ordersProvider.getOrders;
    //bool _isEmpty= true;
    return FutureBuilder(
      future: ordersProvider.fetchOrders(),
      builder: (context,snapshot) {
        return orderList.isEmpty
            ? const EmptyScreen(
                title: 'Your cart is empty',
                subtitle: 'Add something and make me happy :)',
                buttonText: 'Shop now',
                imagePath: 'assets/images/cart.png',
              )
            : Scaffold(
                appBar: AppBar(
                  leading: const BackWidget(),
                  elevation: 0,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  title: TextWidget(
                      text: 'My Orders ${orderList.length}',
                      color: color,
                      textSize: 22,
                      isTitle: true),
                  actions: [
                    IconButton(
                        onPressed: () {
                          GlobalMethod.warningDialog(
                              title: 'Empty your Orders',
                              subTitle: 'Are you sure?',
                              fct: () {},
                              context: context);
                        },
                        icon: Icon(
                          IconlyBroken.delete,
                          color: color,
                        )),
                  ],
                ),
                body: ListView.separated(
                    itemCount: orderList.length,
                    itemBuilder: (ctx, index) {
                      return Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                        child: ChangeNotifierProvider.value(
                            value: orderList[index],
                            child: const OrdersWidget()),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        color: color,
                      );
                    },
                    ),
              );
      }
    );
  }
}
