import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_app/consts/contss.dart';
import 'package:grocery_app/consts/firebase_consts.dart';
import 'package:grocery_app/screens/loading_manager.dart';
import 'package:grocery_app/services/global_methods.dart';
import 'package:grocery_app/widgets/auth_button.dart';
import 'package:grocery_app/widgets/back_widget.dart';
import 'package:grocery_app/widgets/text_widgets.dart';
class ForgotPasswordScreen extends StatefulWidget {
  static const routeName='/ForgotPasswordScreen';
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController=TextEditingController();
 // bool _isLoading= false;
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
  bool _isLoading=false;
  void _forgetPassFCT()async{
    if(_emailController.text.isEmpty || !_emailController.text.contains('@')){
      GlobalMethod.errorDialog(subTitle: 'Please enter a valid email', context: context);
    }else{
      setState(() {
        _isLoading=true;
      });
     try{
       await authInstance.sendPasswordResetEmail(email: _emailController.text.toLowerCase());
     }on FirebaseException catch(error){
       GlobalMethod.errorDialog(subTitle: '${error.message}', context: context);
       Fluttertoast.showToast(msg: 'An email sent to your email address',
       toastLength: Toast.LENGTH_LONG,
         gravity: ToastGravity.BOTTOM,
         timeInSecForIosWeb: 1,
         backgroundColor: Colors.grey.shade400,
         textColor: Colors.white,
         fontSize: 16,

       );
       setState(() {
         _isLoading=false;
       });

     }catch(error){
       GlobalMethod.errorDialog(subTitle: '$error', context: context);
       _isLoading= false;

     }finally{
       setState(() {
         _isLoading= false;
       });
       
     }
    }
  }
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      body: LoadingManager(
        isLoading: _isLoading,
        child: Stack(
          children: [

            Swiper(
              duration: 800,
              autoplayDelay: 8000,
              itemBuilder: (BuildContext context, int index) {
                return Image.asset(
                  Constss.authImagesPaths[index],
                  fit: BoxFit.cover,
                );
              },
              autoplay: true,
              itemCount: Constss.authImagesPaths.length,
            ),
            Container(
              color: Colors.black.withOpacity(0.7),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  SizedBox(height: size.height*0.1,),
                  const BackWidget(),
                  const SizedBox(height: 20,),
                  TextWidget(text: 'Forgot Password', color: Colors.white, textSize: 30,isTitle: true,),
                 const  SizedBox(height: 30,),
                  TextField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Email address',
                      hintStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AuthButton(
                    buttonText: 'Reset now',
                    fct: () {
                      _forgetPassFCT();
                    },
                  ),


                ],
              ),
            )

          ],
        ),
      ),

    );
  }
}
