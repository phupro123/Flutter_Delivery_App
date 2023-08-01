import 'package:flutter/material.dart';
import 'package:project_final/const/colors.dart';
import 'package:project_final/screens/Home/BannerSlider.dart';
import 'package:project_final/screens/Home/Category.dart';
import 'package:project_final/screens/Home/NewFood.dart';
import 'package:project_final/screens/Menu/menuScreen.dart';
import 'package:project_final/screens/cartScreen.dart';
import 'package:project_final/widgets/icon_cart.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/helper.dart';
import '../../widgets/customNavBar.dart';
import '../../widgets/searchBar.dart';
import 'package:badges/badges.dart' as badges;

class HomeScreen extends StatelessWidget {
  static const routeName = "/homeScreen";

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      body: Container(
        height: Helper.getScreenHeight(context),
        child: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Xin chào",
                            style: Helper.getTheme(context).headline5,
                          ),

                          IconCart(),

                        ],
                      ),
                      Text(
                        ap.userModel.name,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColor.primary)
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          child: BannerSlider()
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Danh mục món ăn",
                            style: Helper.getTheme(context).headline5,
                          ),
                          TextButton(onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed(MenuScreen.routeName);
                          }, child: Text("View all"))
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child:  Category(),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Món ngon phải thử",
                            style: Helper.getTheme(context).headline5,
                          ),
                          TextButton(onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed(MenuScreen.routeName);
                          }, child: Text("View all"))
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child:  NewFood(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
                bottom: 0,
                left: 0,
                child: CustomNavBar(
                  home: true,
                )),
          ],
        ),
      )
    );
  }
}
