import 'package:flutter/material.dart';
import 'package:project_final/screens/cartScreen.dart';

import '../const/colors.dart';
import '../screens/Home/homeScreen.dart';
import '../screens/Menu/menuScreen.dart';
import '../screens/moreScreen.dart';
import '../utils/helper.dart';

class CustomNavBar extends StatelessWidget {
  final bool home;
  final bool menu;
  final bool offer;
  final bool more;

  const CustomNavBar(
      {Key? key,
        this.home = false,
        this.menu = false,
        this.offer = false,
        this.more = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: Helper.getScreenWidth(context),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 80,
              width: Helper.getScreenWidth(context),
              padding: const EdgeInsets.symmetric(horizontal: 30),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        if (!home) {
                          Navigator.of(context)
                              .pushReplacementNamed(HomeScreen.routeName);
                        }
                      },
                      child: NavBarItem(icon: Icons.home, name: "Home", isSelected: home)
                  ),
                  GestureDetector(
                    onTap: () {
                      if (!menu) {
                        Navigator.of(context)
                            .pushReplacementNamed(MenuScreen.routeName);
                      }
                    },
                    child: NavBarItem(icon: Icons.widgets, name: "Menu", isSelected: menu),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (!offer) {
                        Navigator.of(context)
                            .pushReplacementNamed(CartScreen.routeName);
                      }
                    },
                    child: NavBarItem(icon: Icons.shopping_cart, name: "Offer", isSelected: offer),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (!more) {
                        Navigator.of(context)
                            .pushReplacementNamed(MoreScreen.routeName);
                      }
                    },
                    child: NavBarItem(icon: Icons.view_list, name: "More", isSelected: more),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NavBarItem extends StatelessWidget {
  const NavBarItem({
    Key? key,
    required IconData icon,
    required String name,
    bool isSelected = false,
  })  : _icon = icon,
        _name = name,
        _isSelected = isSelected,
        super(key: key);

  final IconData _icon;
  final String _name;
  final bool _isSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _isSelected
            ? Icon(
          _icon,
          color: AppColor.orange,
        )
            : Icon(
          _icon,
        ),
        _isSelected
            ? Text(_name,
            style: TextStyle(color: AppColor.orange))
            : Text(_name),
      ],
    );
  }
}

class CustomNavBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width * 0.3, 0);
    path.quadraticBezierTo(
      size.width * 0.375,
      0,
      size.width * 0.375,
      size.height * 0.1,
    );
    path.cubicTo(
      size.width * 0,
      size.height * 0,
      size.width * 0,
      size.height * 0,
      size.width * 0,
      size.height * 0,
    );
    path.quadraticBezierTo(
      size.width * 0.625,
      0,
      size.width * 0.7,
      0.1,
    );
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
