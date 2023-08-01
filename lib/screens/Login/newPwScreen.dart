import 'package:flutter/material.dart';
import 'package:project_final/screens/moreScreen.dart';
import 'package:project_final/screens/profileScreen.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import '../../const/colors.dart';
import '../../providers/auth_provider.dart';
import '../../utils/helper.dart';
import '../../utils/utils.dart';
import '../../widgets/customTextInput.dart';
import 'introScreen.dart';

class NewPwScreen extends StatelessWidget {
  final passController = TextEditingController();
  final confirmController = TextEditingController();
  static const routeName = "/newPw";
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      body: Container(
        width: Helper.getScreenWidth(context),
        height: Helper.getScreenHeight(context),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed(ProfileScreen.routeName);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text("New Password", style: Helper.getTheme(context).headline6),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Nhập mật khẩu mới để được thay đổi",
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30,
                ),
                Input(hintText: "Mật khẩu", control: passController,inputType: TextInputType.text,password: true),
                SizedBox(
                  height: 20),
                Input(hintText: "Nhập lại mật khẩu", control: confirmController,inputType: TextInputType.text,password: true),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if(passController.text!= confirmController.text){
                        showSnackBar(context, "Mật khẩu không trùng khớp vui lòng nhập lại");
                      }
                      else{
                        Map<Object,Object> data1 = {
                          "pass": passController.text,
                        };
                        ap.editUser(data1: data1);
                        toastification.show(
                          context: context,
                          title: 'Cập nhật thông tin thành công',
                          backgroundColor: Colors.green,
                          icon: Icon(
                            Icons.check_circle_sharp,
                            color: Colors.white,
                          ),
                          autoCloseDuration: const Duration(seconds: 2),
                        );
                      }
                    },
                    child: Text("Xác nhận"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
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
