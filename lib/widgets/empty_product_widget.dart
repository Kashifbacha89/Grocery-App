import 'package:flutter/material.dart';
import 'package:grocery_app/services/utils.dart';
class EmptyProductWidget extends StatelessWidget {
  const EmptyProductWidget({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    Color color = Utils(context).color;
    return Center(child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.asset('assets/images/box.png'),
          ),
          Text(text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30,color: color,fontWeight: FontWeight.w700),
          ),
        ],
      ),
    ));
  }
}
