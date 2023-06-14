import 'package:flutter/material.dart';
import 'package:grocery_app/inner_screens/categories_screen.dart';
import 'package:grocery_app/provider/dark_theme_provider.dart';
import 'package:grocery_app/widgets/text_widgets.dart';
import 'package:provider/provider.dart';

class CategoriesWidget extends StatelessWidget {
   CategoriesWidget({Key? key,required this.catText,required this.imgPath,required this.passedColor}) : super(key: key);
  final String catText,imgPath;
  final Color passedColor;

  @override
  Widget build(BuildContext context) {

    double _screenWidth=MediaQuery.of(context).size.width;
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color=themeState.getDarkTheme?Colors.white:Colors.black;
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, CategoryScreen.routeName,
        arguments: catText
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: passedColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: passedColor.withOpacity(0.7),
            width: 3,
          ),
        ),
        child: Column(
          children: [
            Container(
              height: _screenWidth *0.3,
              width: _screenWidth * 0.3,
              decoration:  BoxDecoration(
                image:  DecorationImage(
                  image: AssetImage(imgPath),fit: BoxFit.cover,
                )
              ),

            ),
            TextWidget(text: catText, color: color, textSize: 20,isTitle: true,)
          ],
        ),
      ),
    );
  }
}
