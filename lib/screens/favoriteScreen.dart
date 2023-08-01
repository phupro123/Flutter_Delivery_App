import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_final/const/colors.dart';
import 'package:project_final/model/product_model.dart';
import 'package:project_final/providers/auth_provider.dart';
import 'package:project_final/screens/ItemDetail.dart';
import 'package:project_final/screens/Menu/menuScreen.dart';
import 'package:project_final/utils/helper.dart';
import 'package:project_final/widgets/customNavBar.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatelessWidget {
  static const routeName = "/FavoriteScreen";

  FavoriteScreen({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          height: Helper.getScreenHeight(context),
          child:  Stack(
            children: [
              SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
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
                              "Yêu thích",
                              style: Helper.getTheme(context).headline5,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: _buildBody(context),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: CustomNavBar(
                    more: true,
                  ),
                ),
              )
            ],
          ),
        )
    );
  }

  Widget _buildBody(BuildContext context) {
    final ap = Provider
        .of<AuthProvider>(context, listen: false)
        .userModel;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('favorites')
          .doc(ap.uid)
          .snapshots(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Text('Awaiting result...');
          default:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            else {
              if (snapshot.data?.data() == null || snapshot.data!['arrayFavorite']!.isEmpty) {
                return _empty(context);
              }
              var array = snapshot.data!['arrayFavorite'];

              return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...array.map<Widget>((item) =>
                          Card(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: Image(
                                    width: 60,
                                    height: 40,
                                    image: NetworkImage(item['productModel']['image']),
                                    fit:BoxFit.cover,
                                  ),
                                  title: Text(item['productModel']['name'], style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColor.orange),),
                                  subtitle: Text('${item['productModel']['price']}đ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColor.primary),),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ListDetailPage(product: ProductModel.fromMap(item['productModel'])),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          )
                      ).toList(),
                    ]
                );
            }
        }
      },
    );
  }

  Widget _empty(BuildContext context) {
    return Column(
      children: [
        new Container(margin: new EdgeInsets.only(top: 160)),
        Icon(
          Icons.heart_broken,
          size: 100,
        ),
        const Center(
            child: Text(
              'Yêu thích trống',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            )),
        const Center(
            child: Text(
              'Hiện tại bạn chưa có món yêu thích nào.',
              style: TextStyle(fontSize: 15.0),
            )),
        new Container(margin: new EdgeInsets.only(top: 10)),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
              textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(MenuScreen.routeName);
          },
          child: const Text(
            'Chọn món ngay',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}