import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:project_final/const/colors.dart';
import 'package:project_final/model/cart_model.dart';
import 'package:project_final/model/product_model.dart';
import 'package:project_final/model/rating_model.dart';
import 'package:project_final/providers/auth_provider.dart';
import 'package:project_final/providers/cart_provider.dart';
import 'package:project_final/providers/rating_provider.dart';
import 'package:project_final/screens/Menu/menuScreen.dart';
import 'package:project_final/screens/Product/Favorite.dart';
import 'package:project_final/screens/Product/Rating.dart';
import 'package:project_final/utils/helper.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'cartScreen.dart';

class ListDetailPage extends StatefulWidget {
  const ListDetailPage({Key? key, required this.product})
      : super(key: key);

  final ProductModel product;

  @override
  State<ListDetailPage> createState() => _ListDetailPage();
}

class _ListDetailPage extends State<ListDetailPage> {
  int _quantity = 1;

  void increase() {
    setState(() { _quantity += 1; });
  }

  void decrease() {
    if(_quantity==1){
      setState(() {
        _quantity=1;
      });
    }
    else{
      setState(() { _quantity -= 1; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.grey,
            ),
          ),
          title: Text(
            widget.product.name,
            style: TextStyle(
                color: Colors.grey
            ),
          ),

        ),
        body:
          _buildBody(context));
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection("ratings").doc(widget.product.id.toString()).snapshots(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Text('Press button to start');
          case ConnectionState.waiting:
            return const Text('Awaiting result...');
          default:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            else {
              var array, average = 0.0;
              if (snapshot.data?.data() == null) {
                array = [];
              }
              else {
                array = snapshot.data!['arrayRating'];
                average = array.map((m) => m['star']).reduce((a, b) => a + b) / array.length;
              }
              final cF = NumberFormat('#,###', );

              return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Card(
                            elevation: 5.0,
                            child: Container(
                                child: Center(
                                    child: Image.network(
                                      widget.product.image,
                                      fit: BoxFit.cover,
                                    )
                                )
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 20,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Favorite(product: widget.product),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: Text(
                          widget.product.name,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Text(
                          '${cF.format(widget.product.price)}đ',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 20
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      average.toStringAsFixed(1),
                                      style: TextStyle(
                                          fontSize: 17, color: AppColor.orange),
                                    ),
                                    RatingBarIndicator(
                                      rating: average,
                                      direction: Axis.horizontal,
                                      itemCount: 5,
                                      itemSize: 20,
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: AppColor.orange,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Đánh giá: ${array.length}",
                                  style: TextStyle(
                                      fontSize: 17, color: AppColor.orange),
                                ),
                              ],
                            ),
                            Rating(
                              id: widget.product.id,
                              name: widget.product.name,
                              image: widget.product.image,
                              arrayLength: array.length,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: const Text(
                          "Chi tiết:",
                          style: TextStyle(
                            fontSize: 17.0,
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ), // Description Container
                      Container(
                        child: Text(
                          widget.product.detail,
                          style: TextStyle(
                              fontSize: 15.0
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                'Tổng tiền: ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                '${cF.format(widget.product.price * _quantity)}đ',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              height: 40,
                              width: 130,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: decrease,
                                    icon: Icon(Icons.remove, color: Colors.white, size: 15,),
                                  ),
                                  Text(_quantity.toString(),
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      )
                                  ),
                                  IconButton(
                                    onPressed: increase,
                                    icon: Icon(Icons.add, color: Colors.white, size: 15),
                                  ),
                                ],
                              )
                          ),
                          Align(
                            alignment: FractionalOffset.topCenter,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                                  textStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              onPressed: () {
                                storeData();
                                Timer(Duration(milliseconds: 300), () {
                                  Navigator.of(context)
                                      .pushReplacementNamed(CartScreen.routeName);
                                });
                              },
                              child: const Text(
                                'Thêm vào giỏ hàng',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Bình luận',
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ...array.map<Widget>((item) =>
                                Column(
                                  children: [
                                    Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          ClipOval(
                                            child: Container(
                                              height: 40,
                                              width: 40,
                                              child: Image.network(
                                                item['profilePic'],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(item['name'], style: TextStyle(fontSize: 16),),
                                              RatingBarIndicator(
                                                rating: item['star'].toDouble(),
                                                direction: Axis.horizontal,
                                                itemCount: 5,
                                                itemSize: 20,
                                                itemBuilder: (context, _) => Icon(
                                                  Icons.star,
                                                  color: AppColor.orange,
                                                ),
                                              ),
                                              Text(item['content']),
                                            ],
                                          ),
                                        ]
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                )
                            ).toList()
                          ],
                        ),
                      ),
                    ],
                  )
              );
            }
        }
      },
    );
  }

  void storeData() async {
    final cp = Provider.of<CartProvider>(context, listen: false);
    final ap = Provider.of<AuthProvider>(context, listen: false).userModel;

    CartModel cartModel = CartModel(
      id: const Uuid().v4(),
      productId: widget.product.id.toString(),
      productName: widget.product.name,
      productPrice: widget.product.price,
      quantity: _quantity,
      image: widget.product.image,
    );
    cp.addToCart(context: context,uid: ap.uid, cartModel: cartModel);
  }
}