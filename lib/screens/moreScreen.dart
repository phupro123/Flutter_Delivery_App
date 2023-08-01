import 'package:flutter/material.dart';
import 'package:project_final/const/colors.dart';
import 'package:project_final/screens/favoriteScreen.dart';

import 'package:project_final/screens/inboxScreen.dart';
import 'package:project_final/screens/listOrderScreen.dart';
import 'package:project_final/screens/paymentScreen.dart';
import 'package:project_final/screens/profileScreen.dart';
import 'package:project_final/utils/helper.dart';
import 'package:project_final/widgets/customNavBar.dart';
import 'package:project_final/widgets/icon_cart.dart';

class MoreScreen extends StatelessWidget {
  static const routeName = "/moreScreen";
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Stack(
          children: [
            SafeArea(
              child: Container(
                height: Helper.getScreenHeight(context),
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "More",
                          style: Helper.getTheme(context).headline5,
                        ),
                        IconCart()
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    MoreCard(
                      icon: Icons.person,
                      name: "Profile",
                      handler: () {
                        Navigator.of(context).pushNamed(ProfileScreen.routeName);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    MoreCard(
                      icon: Icons.favorite,
                      name: "My favorites",
                      handler: () {
                        Navigator.of(context).pushNamed(FavoriteScreen.routeName);
                      },
                    ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // MoreCard(
                    //   icon: Icons.payments,
                    //   name: "Payment Details",
                    //   handler: () {
                    //     Navigator.of(context).pushNamed(PaymentScreen.routeName);
                    //   },
                    // ),
                    SizedBox(
                      height: 10,
                    ),
                    MoreCard(
                      icon: Icons.history_edu,
                      name: "My Orders",
                      handler: () {
                        Navigator.of(context).pushNamed(ListOrderScreen.routeName);
                      },
                    ),

                    SizedBox(
                      height: 10,
                    ),
                  ]),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: CustomNavBar(
                more: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MoreCard extends StatelessWidget {
  const MoreCard({
    Key? key,
    required String name,
    required IconData icon,
    bool isNoti = false,
    required Function handler,
  })  : _name = name,
        _icon = icon,
        _isNoti = isNoti,
        _handler = handler,
        super(key: key);

  final String _name;
  final IconData _icon;
  final bool _isNoti;
  final Function _handler;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () { _handler(); },
      child: Container(
        height: 70,
        width: double.infinity,
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              margin: const EdgeInsets.only(
                right: 20,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                color: AppColor.placeholderBg,
              ),
              child: Row(
                children: [
                  Container(
                      width: 50,
                      height: 50,
                      decoration: ShapeDecoration(
                        shape: CircleBorder(),
                        color: AppColor.placeholder,
                      ),
                      child: Icon(
                        _icon,
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    _name,
                    style: TextStyle(
                      color: AppColor.primary,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                height: 30,
                width: 30,
                decoration: ShapeDecoration(
                  shape: CircleBorder(),
                  color: AppColor.placeholderBg,
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColor.secondary,
                  size: 17,
                ),
              ),
            ),
            if (_isNoti)
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 20,
                  width: 20,
                  margin: const EdgeInsets.only(
                    right: 50,
                  ),
                  decoration: ShapeDecoration(
                    shape: CircleBorder(),
                    color: Colors.red,
                  ),
                  child: Center(
                    child: Text(
                      "15",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}

