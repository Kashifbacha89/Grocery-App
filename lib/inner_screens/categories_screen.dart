import 'package:flutter/material.dart';
import 'package:grocery_app/models/product_model.dart';
import 'package:grocery_app/providers/product_provider.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:grocery_app/widgets/back_widget.dart';
import 'package:grocery_app/widgets/empty_product_widget.dart';
import 'package:grocery_app/widgets/feeds_item_widget.dart';
import 'package:grocery_app/widgets/text_widgets.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  static const routeName = '/CategoryScreen';
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  TextEditingController _searchController = TextEditingController();
  final FocusNode _searchTextFocusNode = FocusNode();
  List<ProductModel> listProductSearch=[];
  @override
  void dispose() {
    _searchController.dispose();
    _searchTextFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final productProvider = Provider.of<ProductProvider>(context);
    final catName = ModalRoute.of(context)!.settings.arguments as String;
    List<ProductModel> productByCat = productProvider.findByCategory(catName);

    return Scaffold(
      appBar: AppBar(
        leading: const BackWidget(),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: TextWidget(
          text: catName,
          color: color,
          textSize: 24,
          isTitle: true,
        ),
        centerTitle: true,
      ),
      body: productByCat.isEmpty
          ? const EmptyProductWidget(text: 'No product belongs to this category',)
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: kBottomNavigationBarHeight,
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchTextFocusNode,
                        onChanged: (valuee) {
                          setState(() {
                            listProductSearch =productProvider.searchQuery(valuee);
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "what's  in your mind",
                          prefixIcon: Icon(Icons.search),
                          suffix: IconButton(
                            onPressed: () {
                              _searchController.clear();
                              _searchTextFocusNode.unfocus();
                            },
                            icon: Icon(
                              Icons.close,
                              color: _searchTextFocusNode.hasFocus
                                  ? Colors.red
                                  : color,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Colors.greenAccent, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Colors.greenAccent, width: 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                  _searchController.text.isNotEmpty &&
                  listProductSearch.isEmpty?
                      const EmptyProductWidget(text: 'No product found,please try another keyword')
                      : GridView.count(
                    crossAxisCount: 2,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    childAspectRatio: size.width / (size.height * 0.79),
                    children: List.generate(
                        _searchController.text.isNotEmpty?
                            listProductSearch.length:
                        productByCat.length, (index) {
                      return ChangeNotifierProvider.value(

                          value: _searchController.text.isNotEmpty?
                              listProductSearch[index]:
                          productByCat[index],
                          child: const FeedsWidget());
                    }),
                  ),
                ],
              ),
            ),
    );
  }
}
