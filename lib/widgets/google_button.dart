import 'package:flutter/material.dart';
class GoogleButton extends StatelessWidget {
  const GoogleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blue,
      child: InkWell(
        onTap: (){},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              child: Image.asset('assets/images/google.png',
              width: 40,),
            ),
            const SizedBox(width: 8,),
            const Text('Sign in with Google',style: TextStyle(fontSize: 18,color: Colors.white),),

          ],
        ),
      ),
    );
  }
}
