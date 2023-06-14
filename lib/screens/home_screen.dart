import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/consts/contss.dart';
import 'package:grocery_app/inner_screens/feeds_screen.dart';
import 'package:grocery_app/inner_screens/on_sale_screen.dart';
import 'package:grocery_app/models/product_model.dart';
import 'package:grocery_app/providers/product_provider.dart';
import 'package:grocery_app/services/global_methods.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:grocery_app/widgets/feeds_item_widget.dart';
import 'package:grocery_app/widgets/on_sale_widget.dart';
import 'package:grocery_app/widgets/text_widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);
    Size size = utils.getScreenSize;
    final theme = utils.getTheme;
    final Color color = utils.color;
    final productProviders = Provider.of<ProductProvider>(context);
    List<ProductModel> allProducts =productProviders.getProducts;
    List<ProductModel> productOnSale = productProviders.getOnSaleProducts;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.33,
              child: Swiper(
                itemCount: Constss.offerImages.length,
                pagination: const SwiperPagination(
                    alignment: Alignment.bottomCenter,
                    builder: DotSwiperPaginationBuilder(
                      color: Colors.white,
                      activeColor: Colors.red,
                    )),
                //control: SwiperControl(),
                autoplay: true,
                itemBuilder: (BuildContext context, int index) {
                  return Image.asset(
                    Constss.offerImages[index],
                    fit: BoxFit.fill,
                  );
                },
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            TextButton(
                onPressed: () {
                  GlobalMethod.navigateTo(
                      ctx: context, routeName: OnSaleScreen.routeName);
                },
                child: TextWidget(
                  color: Colors.blue,
                  textSize: 20,
                  text: 'View all',
                  maxLines: 1,
                )),
            const SizedBox(
              height: 6,
            ),
            Row(
              children: [
                RotatedBox(
                  quarterTurns: -1,
                  child: Row(
                    children: [
                      TextWidget(
                        text: 'On sale'.toUpperCase(),
                        color: Colors.red,
                        textSize: 22,
                        isTitle: true,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Icon(
                        IconlyLight.discount,
                        color: Colors.red,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Flexible(
                  child: SizedBox(
                    height: size.height * 0.38,
                    child: ListView.builder(
                        itemCount: productOnSale.length<10? productOnSale.length:10,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return ChangeNotifierProvider.value(
                              value: productOnSale[index],
                              child: const OnSaleWidget());
                        }),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  TextWidget(
                    text: 'Our product',
                    color: color,
                    textSize: 22,
                    isTitle: true,
                  ),
                  const Spacer(),
                  TextButton(
                      onPressed: () {
                        GlobalMethod.navigateTo(
                            ctx: context, routeName: FeedsScreen.routeName);
                      },
                      child: TextWidget(
                        text: 'Browse all',
                        color: Colors.blue,
                        textSize: 20,
                      ))
                ],
              ),
            ),
            GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              childAspectRatio: size.width / (size.height * 0.66),
              crossAxisCount: 2,
              children: List.generate(
                  allProducts.length < 4
                      ? allProducts.length
                      : 4, (index) {
                return ChangeNotifierProvider.value(
                    value:allProducts[index],
                    child: const FeedsWidget());
              }),
            ),
          ],
        ),
      ),
    );
  }
}
