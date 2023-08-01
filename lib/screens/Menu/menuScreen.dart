import 'package:flutter/material.dart';
import 'package:project_final/screens/Menu/Categories.dart';
import 'package:project_final/screens/Menu/ListFood.dart';
import 'package:project_final/utils/helper.dart';
import 'package:project_final/widgets/customNavBar.dart';
import 'package:project_final/widgets/icon_cart.dart';

class MenuScreen extends StatefulWidget {
  static const routeName = "/menuScreen";
  const MenuScreen({Key? key, required this.categoryId,required this.categoryName
  })
      : super(key: key);

  final int categoryId;
  final String categoryName;

  @override
  State<MenuScreen> createState() => _MenuScreen();
}

class _MenuScreen extends State<MenuScreen> {
  late int _categoryId = widget.categoryId;
  late String _categoryName = widget.categoryName;

  void handleChangeCategory(categoryId, categoryName) {
    setState(() { _categoryId = categoryId; _categoryName = categoryName; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Container(
              height: Helper.getScreenHeight(context),
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Menu",
                          style: Helper.getTheme(context).headline5,
                        ),
                        IconCart(

                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Categories(categoryId: _categoryId, handleChangeCategory: handleChangeCategory),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: ListFood(title: _categoryName, idQuery: _categoryId),
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
              menu: true,
            ),
          )
        ],
      ),
    );
  }
}
