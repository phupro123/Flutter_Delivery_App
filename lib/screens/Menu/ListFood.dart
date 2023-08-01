import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_final/const/colors.dart';
import 'package:project_final/model/product_model.dart';
import 'package:project_final/screens/ItemDetail.dart';
import 'package:project_final/screens/Menu/menuScreen.dart';
import 'package:project_final/utils/helper.dart';

class ListFood extends StatefulWidget {
  final String title;
  final int idQuery;
  ListFood({Key? key, required this.title, required this.idQuery})
      : super(key: key);

  @override
  State<ListFood> createState() => _ListFoodState();
}

class _ListFoodState extends State<ListFood> {
  final searchFilter = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              width: double.infinity,
              decoration: ShapeDecoration(
                shape: StadiumBorder(),
                color: AppColor.placeholderBg,
              ),
              child: TextFormField(
                controller: searchFilter,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                      Icons.search
                  ),
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: AppColor.placeholder,
                    fontSize: 18,
                  ),
                  contentPadding: const EdgeInsets.only(
                    top: 17,
                  ),
                ),
                onChanged: (String value) {
                  setState(() {
                  });
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(widget.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColor.primary),),
            SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  _buildBody(context)
                ],
              ),
            ),
          ]
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('menus')
          .where('category', isEqualTo: widget.idQuery)
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
              if (snapshot.hasData == null) {
                return _empty(context);
              }
              var array = snapshot.data?.docs ?? [];

              return Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ...array.map<Widget>((item) {
                          if (item['name'].toLowerCase().contains(searchFilter.text.toLowerCase())) {
                            return Card(
                              margin: const EdgeInsets.only(bottom: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    leading: Image(
                                      width: 60,
                                      height: 40,
                                      image: NetworkImage(item['image']),
                                      fit: BoxFit.cover,
                                    ),
                                    title: Text(item['name'], style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColor.orange),),
                                    subtitle: Text('${item['price']}đ',
                                      style: TextStyle(fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppColor.primary),),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ListDetailPage(
                                                  product: ProductModel.fromMap(
                                                      item.data() as Map<
                                                          String,
                                                          dynamic>)),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          }
                          return Container();
                        }).toList(),
                      ]
                  ));
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
          Icons.menu,
          size: 100,
        ),
        const Center(
            child: Text(
              'Menu trống',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            )),
        const Center(
            child: Text(
              'Hiện tại menu chưa có món nào.',
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
            'Chọn món khác',
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
