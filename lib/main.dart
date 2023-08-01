import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_final/providers/auth_provider.dart';
import 'package:project_final/providers/cart_provider.dart';
import 'package:project_final/providers/favorite_provider.dart';
import 'package:project_final/providers/order_provider.dart';
import 'package:project_final/providers/rating_provider.dart';
import 'package:project_final/screens/Location/location_search_screen.dart';
import 'package:project_final/screens/Login/forgetPwScreen.dart';
import 'package:project_final/screens/Login/introScreen.dart';
import 'package:project_final/screens/Login/landingScreen.dart';
import 'package:project_final/screens/Login/loginScreen.dart';
import 'package:project_final/screens/Login/newPwScreen.dart';
import 'package:project_final/screens/Login/signUpScreen.dart';
import 'package:project_final/screens/Login/spashScreen.dart';
import 'package:project_final/screens/favoriteScreen.dart';
import 'package:project_final/screens/Home/homeScreen.dart';
import 'package:project_final/screens/Menu/menuScreen.dart';
import 'package:project_final/screens/cartScreen.dart';
import 'package:project_final/screens/Login/changeAddressScreen.dart';
import 'package:project_final/screens/listOrderScreen.dart';
import 'package:project_final/screens/Login/phoneScreen.dart';
import 'package:project_final/screens/Login/user_information_screen.dart';
import 'package:project_final/screens/Login/verifyScreen.dart';
import 'package:project_final/screens/Login/welcome_screen.dart';
import 'package:provider/provider.dart';

import './screens/moreScreen.dart';
import './screens/profileScreen.dart';
import './screens/paymentScreen.dart';

import './screens/inboxScreen.dart';
import 'screens/Login/checkoutScreen.dart';
import './const/colors.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() async{
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => RatingProvider()),
          ChangeNotifierProvider(create: (_) => FavoriteProvider()),
          ChangeNotifierProvider(create: (_) => OrderProvider()),

        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              fontFamily: "Metropolis",
              primarySwatch: Colors.red,
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    AppColor.orange,
                  ),
                  shape: MaterialStateProperty.all(
                    StadiumBorder(),
                  ),
                  elevation: MaterialStateProperty.all(0),
                ),
              ),
              textButtonTheme: TextButtonThemeData(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(
                    AppColor.orange,
                  ),
                ),
              ),
              textTheme: TextTheme(
                headline3: TextStyle(
                  color: AppColor.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                headline4: TextStyle(
                  color: AppColor.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                headline5: TextStyle(
                  color: AppColor.primary,
                  fontWeight: FontWeight.normal,
                  fontSize: 25,
                ),
                headline6: TextStyle(
                  color: AppColor.primary,
                  fontSize: 25,
                ),
                bodyText2: TextStyle(
                  color: AppColor.secondary,
                ),
              ),
              scaffoldBackgroundColor: Colors.white
          ),
          home: SplashScreen(),
          routes: {
            LandingScreen.routeName: (context) => LandingScreen(),
            LoginScreen.routeName: (context) => LoginScreen(),
            SignUpScreen.routeName: (context) => SignUpScreen(),
            ForgetPwScreen.routeName: (context) => ForgetPwScreen(),
            NewPwScreen.routeName: (context) => NewPwScreen(),
            IntroScreen.routeName: (context) => IntroScreen(),
            HomeScreen.routeName: (context) => HomeScreen(),
            MenuScreen.routeName: (context) => MenuScreen(categoryId: 1, categoryName: "Gà giòn"),
            ProfileScreen.routeName: (context) => ProfileScreen(),
            MoreScreen.routeName: (context) => MoreScreen(),
            PaymentScreen.routeName: (context) => PaymentScreen(),
            InboxScreen.routeName: (context) => InboxScreen(),
            CheckoutScreen.routeName: (context) => CheckoutScreen(),
            ChangeAddressScreen.routeName: (context) => ChangeAddressScreen(),
            PhoneScreen.routeName:(context)=>PhoneScreen(),
            VerifyScreen.routeName:(context)=>VerifyScreen(),
            UserInfromationScreen.routeName:(context)=>UserInfromationScreen(),
            WelcomeScreen.routeName:(context)=>WelcomeScreen(),
            CartScreen.routeName:(context)=>CartScreen(),
            ListOrderScreen.routeName:(context)=>ListOrderScreen(),
            FavoriteScreen.routeName:(context)=>FavoriteScreen(),
            SearchLocationScreen.routeName:(context)=>SearchLocationScreen(),

          },
        )
    );

  }
}


