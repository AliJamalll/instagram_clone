import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clonee/resouces/auth_method.dart';
import 'package:instagram_clonee/screens/signup_screen.dart';
import 'package:instagram_clonee/utils/colors.dart';
import 'package:instagram_clonee/utils/global_variables.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_screen_layout.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/utils.dart';
import '../widgets/text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void signInUser()async{
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethod().signInUser(
      email: _emailController.text,
      password: _passwordController.text
    );
    setState(() {
      _isLoading = false;
    });
    if(res == "success"){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder:
          (context) =>  ResponsiveLayout(
        webScreenLayout: WebScreenLayout(),
        mobileScreenLayout: MobileScreenLayout(),
      )
      ));    }else{
      ShowSnackBar(res,context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: MediaQuery.of(context).size.width > webScreenSize?
          EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/3):
          const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: Container(),flex: 2,),
              SvgPicture.asset(
                'assets/images/ic_instagram.svg',
                color: primaryColor,
                height: 64,
              ),
              SizedBox(
                height: 64,
              ),
              TextFieldInput(
                textEditingController: _emailController,
                hintText: 'Email',
                textInputType: TextInputType.emailAddress,
              ),
              SizedBox(
                height: 24,
              ),
              TextFieldInput(
                textEditingController: _passwordController,
                hintText: 'Password',
                textInputType: TextInputType.text,
                isPass: true,
              ),
              SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: signInUser,
                child: Container(
                  child:_isLoading ?  Center(child: CircularProgressIndicator(
                    color: primaryColor,
                  ),) : const Text(
                    'Log in'
                  ),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)
                    ),
                    color: Colors.blue
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Flexible(child: Container(),flex: 2,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: const Text(
                        'don\'t have an account?',
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  GestureDetector(
                    onTap: NavToSignUp,
                    child: Container(
                      child: const Text(
                        ' Sign up',style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      )
    );
  }

  void NavToSignUp() {
     Navigator.of(context).push(MaterialPageRoute(builder:
    (context){
      return SignUpScreen();
    }
    ));
  }
}
