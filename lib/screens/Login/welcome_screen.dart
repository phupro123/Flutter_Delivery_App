import 'package:flutter/material.dart';
import 'package:project_final/screens/Home/homeScreen.dart';
import 'package:project_final/screens/Login/loginScreen.dart';
import 'package:project_final/screens/Login/phoneScreen.dart';
import 'package:project_final/widgets/custom_button.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../utils/helper.dart';

class WelcomeScreen extends StatefulWidget {
  static const routeName = "/welcomeScreen";

  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(

      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                Helper.getAssetName(
                "welcome.png",
                  "real",
                ),),
                const SizedBox(height: 20),
                const Text(
                  "Let's get started",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Never a better time than now to start.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black38,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                // custom button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (ap.isSignedIn == true) {
                        await ap.getDataFromSP().whenComplete(
                              () =>  Navigator.of(context)
                                  .pushReplacementNamed(HomeScreen.routeName)
                        );
                      } else {
                        Navigator.of(context)
                            .pushReplacementNamed(LoginScreen.routeName);

                      }
                    },
                    child:Text( "Get started") ,

                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
