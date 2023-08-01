import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:project_final/screens/Home/homeScreen.dart';
import 'package:project_final/screens/Login/phoneScreen.dart';
import 'package:project_final/screens/Login/user_information_screen.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../utils/utils.dart';

class VerifyScreen extends StatefulWidget {
  static const routeName = "/verifyScreen";

  const VerifyScreen({Key? key}) : super(key: key);

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  var code ='';
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context)
                .pushReplacementNamed(PhoneScreen.routeName);
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/virtual/logo_kp.png',
                width: 150,
                height: 150,
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Vui lòng nhập mã OTP chúng tôi đã gửi cho bạn!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 30,
              ),
              Pinput(
                length: 6,
                // defaultPinTheme: defaultPinTheme,
                // focusedPinTheme: focusedPinTheme,
                // submittedPinTheme: submittedPinTheme,

                showCursor: true,
                onCompleted: (pin) => code=pin,
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green.shade600,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      try{
                        // PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: PhoneScreen.verify, smsCode: code);
                        //
                        //
                        // await auth.signInWithCredential(credential);
                        // Navigator.of(context)
                        //     .pushReplacementNamed(HomeScreen.routeName);
                        if (code != "") {
                          verifyOtp(context, code!);
                        } else {
                          showSnackBar(context, "Enter 6-Digit code");
                        }
                      }catch(e){

                      }

                    },
                    child: Text("Xác nhận")),
              ),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed(PhoneScreen.routeName);

                      },
                      child: Text(
                        "Số điện thoại không đúng?",
                        style: TextStyle(color: Colors.black),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  void verifyOtp(BuildContext context, String userOtp) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    ap.verifyOtp(
      context: context,
      verificationId: PhoneScreen.verify,
      userOtp: userOtp,
      onSuccess: () {
        // checking whether user exists in the db
        ap.checkExistingUser().then(
              (value) async {
            if (value == true) {
              // user exists in our app
              ap.getDataFromFirestore().then(
                    (value) =>
                    ap.saveUserDataToSP().then(
                          (value) =>
                          ap.setSignIn().then(
                                  (value) =>
                                  Navigator.of(context)
                                      .pushReplacementNamed(HomeScreen.routeName)
                          ),
                    ),
              );
            } else {
              // new user
              Navigator.of(context)
                  .pushReplacementNamed(UserInfromationScreen.routeName);
            }
          },
        );
      },
    );
  }
}
