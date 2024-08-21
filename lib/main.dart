import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clonee/providers/user_provider.dart';
import 'package:instagram_clonee/responsive/mobile_screen_layout.dart';
import 'package:instagram_clonee/responsive/responsive_screen_layout.dart';
import 'package:instagram_clonee/responsive/web_screen_layout.dart';
import 'package:instagram_clonee/screens/login_screen.dart';
import 'package:instagram_clonee/utils/colors.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCzJ1EL4cvuD0WXrxI9Xjaguk88mdhUNd8",
          appId: "1:450473717862:web:8c133b786db108616abda7",
          messagingSenderId: "450473717862",
          projectId: "instagram-clone-cc9e6",
          storageBucket: 'instagram-clone-cc9e6.appspot.com'
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram Clone',
        theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: mobileBackgroundColor
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context,snapshot){
            if(snapshot.connectionState == ConnectionState.active){
              if(snapshot.hasData){
                return ResponsiveLayout(
                webScreenLayout: WebScreenLayout(),
                 mobileScreenLayout: MobileScreenLayout(),
                );
              }
            }else if(snapshot.hasError){
              return Center(child: Text(('${snapshot.error}')),);
            }
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(
                color: primaryColor,
              ),);
            }

            return LoginScreen();
          },
        )
        //LoginScreen()

      ),
    );
  }
}

