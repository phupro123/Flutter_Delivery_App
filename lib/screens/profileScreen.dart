import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project_final/const/colors.dart';
import 'package:project_final/screens/Home/homeScreen.dart';
import 'package:project_final/screens/Login/loginScreen.dart';
import 'package:project_final/screens/Login/newPwScreen.dart';
import 'package:project_final/screens/Login/phoneScreen.dart';
import 'package:project_final/utils/helper.dart';
import 'package:project_final/widgets/customNavBar.dart';
import 'package:project_final/widgets/icon_cart.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {

  TextEditingController nameController = TextEditingController();
  static const routeName = "/profileScreen";

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    nameController = new TextEditingController(text: ap.userModel.name);
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Container(
              height: Helper.getScreenHeight(context),
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(
                                Icons.arrow_back_ios_rounded,
                              ),
                            ),
                            Text(
                              "Profile",
                              style: Helper.getTheme(context).headline5,
                            ),
                          ],
                        ),
                       IconCart(),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ClipOval(
                      child: Stack(
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            child: Image.network(
                              ap.userModel.profilePic,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              height: 20,
                              width: 80,
                              color: Colors.black.withOpacity(0.3),
                              child: Image.asset(Helper.getAssetName(
                                  "camera.png", "virtual")),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          Helper.getAssetName("edit_filled.png", "virtual"),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap:(){
                            Navigator.of(context)
                                .pushReplacementNamed(NewPwScreen.routeName);
                          },
                          child:
                            Text(
                              "Change Password",
                              style: TextStyle(color: AppColor.orange),
                            ),

                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Xin chào ${ap.userModel.name}",
                      style: Helper.getTheme(context).headline4?.copyWith(
                        color: AppColor.primary,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    new GestureDetector(
                      onTap: () {
                        ap.userSignOut().then(
                              (value) => Navigator.of(context)
                              .pushReplacementNamed(LoginScreen.routeName),
                        );
                      },
                      child: new Text("Đăng xuất"),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    MyCustomForm(control: nameController,


                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomFormImput(
                      label: "Email",
                      value: ap.userModel.email,
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    CustomFormImput(
                      label: "Address",
                      value: ap.userModel.bio,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomFormImput(
                      label: "Phone",
                      value: ap.userModel.phoneNumber,

                    ),
                    SizedBox(
                      height: 20,
                    ),

                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async{
                          Map<Object,Object> data1 = {
                                "name": nameController.text.trim(),
                          };
                                // ap.editUser(data1: data1);

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
                        },
                        child: Text("Lưu"),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: CustomNavBar(
              more: true,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomFormImput extends StatelessWidget {
  const CustomFormImput({
    Key? key,
    required String label,
    required String value,

    bool isPassword = false,
  })  : _label = label,
        _value = value,
        _isPassword = isPassword,
        super(key: key);

  final String _label;
  final String _value;
  final bool _isPassword;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      padding: const EdgeInsets.only(left: 40),
      decoration: ShapeDecoration(
        shape: StadiumBorder(),
        color: AppColor.placeholderBg,
      ),
      child: TextFormField(
        enabled: false,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: _label,
          contentPadding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
          ),
        ),
        obscureText: _isPassword,
        initialValue: _value,
        style: TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }

}



class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key,  required this.control,});
  final TextEditingController control;

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

// Define a corresponding State class.
// This class holds data related to the Form.
class _MyCustomFormState extends State<MyCustomForm> {
  // Create a text controller. Later, use it to retrieve the
  // current value of the TextField.
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    widget.control.dispose();
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    myController.text = ap.userModel.name;
    return Container(
      width: double.infinity,
      height: 50,
      padding: const EdgeInsets.only(left: 40),
      decoration: ShapeDecoration(
        shape: StadiumBorder(),
        color: AppColor.placeholderBg,
      ),
      child: TextFormField(
          onChanged: (text){
            Map<Object,Object> data1 = {
              "name": text,
            };
             ap.editUser(data1: data1);

          },
        controller:myController,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: "Name",

          contentPadding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
          ),
        ),
        // initialValue: _value,
        style: TextStyle(
          fontSize: 14,
        ),
      ),
    );

  }
}
