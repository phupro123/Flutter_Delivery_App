import 'package:flutter/material.dart';
import 'package:project_final/screens/Home/homeScreen.dart';
import 'package:project_final/screens/Login/forgetPwScreen.dart';
import 'package:project_final/screens/Login/phoneScreen.dart';
import 'package:provider/provider.dart';

import '../../const/colors.dart';
import '../../providers/auth_provider.dart';
import '../../utils/utils.dart';
import 'forgetPwScreen.dart';
import 'signUpScreen.dart';
import '../../utils/helper.dart';
import '../../widgets/customTextInput.dart';
// import '/screens/sentOTPScreen.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = "/loginScreen";
  final emailController = TextEditingController();
  final passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Helper.getScreenHeight(context),
        width: Helper.getScreenWidth(context),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 30,
            ),
            child: Column(
              children: [
                Text(
                  "Đăng nhập",
                  style: Helper.getTheme(context).headline6,
                ),
                Spacer(),
                Text('Điền thông tin để đăng nhập'),
                Spacer(),
                Input(hintText: "Email", control: emailController,inputType: TextInputType.emailAddress,),

                Spacer(),
                Input(hintText: "Mật khẩu", control: passController,inputType: TextInputType.text,password: true),

                Spacer(),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      handle(context);
                    },
                    child: Text("Đăng nhập"),
                  ),
                ),
                Spacer(),
                // GestureDetector(
                //   onTap: () {
                //     // Navigator.of(context)
                //     //     .pushReplacementNamed(ForgetPwScreen.routeName);
                //   },
                //   child: Text("Quên mật khẩu?"),
                // ),
                Spacer(
                  flex: 2,
                ),
                Text("hoặc Đăng nhập bằng"),
                Spacer(),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Color(
                          0xFF73CB342,
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed(PhoneScreen.routeName);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacementNamed(PhoneScreen.routeName);
                          }, // Image tapped
                          child:   Image.asset(
                            Helper.getAssetName(
                              "phone.png",
                              "virtual",
                            ),

                          ),
                        ),

                        SizedBox(
                          width: 20,

                        ),
                        Text("Số điện thoại")
                      ],
                    ),
                  ),
                ),
                Spacer(),

                Spacer(
                  flex: 4,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(SignUpScreen.routeName);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Chưa có tài khoản?"),
                      Text(
                        "Đăng ký",
                        style: TextStyle(
                          color: AppColor.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void handle(BuildContext context) async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    var email = emailController.text;
    var pass = passController.text;
    ap.checkLogin(email, pass).then((value) => {
      if(value == true){
        ap.getDataFromFirestore2(email, pass).then(
          (value) =>
          ap.saveUserDataToSP().then(
                (value) =>
                ap.setSignIn().then(
                        (value) =>
                        Navigator.of(context)
                            .pushReplacementNamed(HomeScreen.routeName)
                ),
          ),
        ),
      }
      else{
        showSnackBar(context, "Tài khoản hoặc mật khẩu không đúng vui lòng nhập lại")
      }
    });

   



  }

  Widget Input( {required String hintText, required TextEditingController control, required TextInputType inputType,bool? password}) {
    EdgeInsets _padding = const EdgeInsets.only(left: 40);
    if(password != null){
      return Container(
        width: double.infinity,
        height: 50,
        decoration: ShapeDecoration(
          color: AppColor.placeholderBg,
          shape: StadiumBorder(),
        ),
        child: TextField(
          controller: control,
          keyboardType: inputType,
          obscureText: true,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(
              color: AppColor.placeholder,
            ),
            contentPadding: _padding,
          ),
        ),
      );
    }
    else{
      return Container(
        width: double.infinity,
        height: 50,
        decoration: ShapeDecoration(
          color: AppColor.placeholderBg,
          shape: StadiumBorder(),
        ),
        child: TextField(
          controller: control,
          keyboardType: inputType,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(
              color: AppColor.placeholder,
            ),
            contentPadding: _padding,
          ),
        ),
      );
    }

  }
}
