import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/providers/viewed_provider.dart';
import 'package:grocery_app/screens/viewed_recently/viewed_recently_widget.dart';
import 'package:grocery_app/services/global_methods.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:grocery_app/widgets/back_widget.dart';
import 'package:grocery_app/widgets/empty_screen.dart';
import 'package:grocery_app/widgets/text_widgets.dart';
import 'package:provider/provider.dart';

class ViewedRRecentlyScreen extends StatefulWidget {
  static const routeName = "/ViewedRRecentlyScreen";
  const ViewedRRecentlyScreen({Key? key}) : super(key: key);

  @override
  State<ViewedRRecentlyScreen> createState() => _ViewedRRecentlyScreenState();
}

class _ViewedRRecentlyScreenState extends State<ViewedRRecentlyScreen> {
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final viewedProdProvider= Provider.of<ViewedProvider>(context);
    final viewedProdItemsList= viewedProdProvider.getViewedProdListItems.values.toList().reversed.toList();
    //bool _isEmpty = true;
    return viewedProdItemsList.isEmpty
        ? const EmptyScreen(
            imagePath: 'assets/images/history.png',
            title: 'Your history is empty ',
            subtitle: 'No product hase been viewed yet!',
            buttonText: 'Shop now')
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              automaticallyImplyLeading: false,
              leading: const BackWidget(),
              elevation: 0,
              backgroundColor:
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
              title: TextWidget(
                  text: 'History', color: color, textSize: 22, isTitle: true),
              actions: [
                IconButton(
                    onPressed: () {
                      GlobalMethod.warningDialog(
                          title: 'Empty your History',
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
            body: ListView.builder(
                itemCount: viewedProdItemsList.length,
                itemBuilder: (context, index) {
                  return  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                    child: ChangeNotifierProvider.value(
                        value: viewedProdItemsList[index],
                        child: const ViewedRecentlyWidget()),
                  );
                }),
          );
  }
}
