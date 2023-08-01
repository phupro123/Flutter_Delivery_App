

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import '../../const/colors.dart';
import '../../model/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../utils/utils.dart';
import 'loginScreen.dart';
import '../../utils/helper.dart';


class SignUpScreen extends StatelessWidget {
  static const routeName = '/signUpScreen';
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final bioController = TextEditingController();

  final passController = TextEditingController();
  final confirmController = TextEditingController();
  @override
  Widget build(BuildContext context) {


    return Scaffold(
        body: Container(
      width: Helper.getScreenWidth(context),
      height: Helper.getScreenHeight(context),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
          child: Column(
            children: [
              Text(
                "Đăng ký",
                style: Helper.getTheme(context).headline6,
              ),
              Spacer(),
              Text(
                "Điền thông tin chi tiết",
              ),
              Spacer(),
              Input(hintText: "Tên", control: nameController, inputType: TextInputType.name, ),
              Spacer(),
              Input(hintText: "Email", control: emailController,inputType: TextInputType.emailAddress,),
              Spacer(),
              Input(hintText: "Số điện thoại", control: phoneController,inputType: TextInputType.number,),
              Spacer(),
              Input(hintText: "Địa chỉ", control: bioController,inputType: TextInputType.text,),
              Spacer(),
              Input(hintText: "Mật khẩu", control: passController,inputType: TextInputType.text,password: true),
              Spacer(),
              Input(hintText: "Nhập lại mật khẩu", control: confirmController,inputType: TextInputType.text,password: true),
              Spacer(),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    handle(context);
                  },
                  child: Text("Đăng ký"),
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(LoginScreen.routeName);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Đã có tài khoản? "),
                    Text(
                      "Đăng nhập",
                      style: TextStyle(
                        color: AppColor.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));

  }
  void handle(BuildContext context) async {
    final ap = Provider.of<AuthProvider>(context, listen: false);

    if(passController.text.trim()!= confirmController.text.trim()){
      showSnackBar(context, "Mật khẩu không trùng khớp vui lòng nhập lại");
    }
    else{
      var phone = phoneController.text.trim();
      String result = phone.substring(1, phone.length);
      var end = "+84$result";

      UserModel userModel = UserModel(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        bio: bioController.text.trim(),
        profilePic: "https://firebasestorage.googleapis.com/v0/b/flutterfinal-e0b1e.appspot.com/o/profilePic%2Ffi1SnJJiIpNeSRUBR2tlAnSTGa63?alt=media&token=0754897c-ae36-4f4e-aeb0-4d5a6c176c8f",
        createdAt:  DateTime.now().millisecondsSinceEpoch.toString(),
        phoneNumber: end,
        uid: end,
        pass:passController.text.trim(),
      );

      ap.saveUserDataToFirebase2(
        context: context,
        userModel: userModel,
      );
        Navigator.of(context)
        .pushReplacementNamed(LoginScreen.routeName);
      toastification.show(
        context: context,
        title: 'Đăng ký tài khoản mới thành công!',
        backgroundColor: Colors.green,
        icon: Icon(
          Icons.check_circle_sharp,
          color: Colors.white,
        ),
        autoCloseDuration: const Duration(seconds: 3),
      );

    }




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
