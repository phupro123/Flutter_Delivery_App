import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:project_final/model/cart_model.dart';
import 'package:project_final/providers/auth_provider.dart';
import 'package:project_final/providers/cart_provider.dart';
import 'package:project_final/providers/order_provider.dart';
import 'package:project_final/screens/Home/homeScreen.dart';
import 'package:project_final/screens/Location/location_search_screen.dart';
import 'package:provider/provider.dart';

import '../const/colors.dart';
import '../model/order_model.dart';
import '../utils/helper.dart';
import '../widgets/customTextInput.dart';

class CartScreen extends StatefulWidget {
  static const routeName = "/cartScreen";

  const CartScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
  }
  int _site =0;
  int _discount = 0;
  var total =0;
  var tongcong=0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.grey,
            ),
          ),
          title: const Text(
            "Giỏ hàng  ",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        body: _buildBody(context));
  }

  Widget _buildBody(BuildContext context) {
    final currencyFormatter = NumberFormat(
      '#,###',
    );

    final ap = Provider.of<AuthProvider>(context, listen: false).userModel;
    var flag = false;
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('carts')
          .doc(ap.uid)
          .snapshots(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          default:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.data!['arrayCart']!.isEmpty) {
              return _empty(context);
            } else {
              var array = [];
              if (snapshot.data?.data() == null) {
                array = [];
              } else {
                array = snapshot.data!['arrayCart'];
              }
              var sum = 0;
              var a = array.map((e) async {
                sum = e["productPrice"] * e['quantity'] + sum;

                return 1;
              });


              print(a);
              total = sum;
              if(total<200000 && _site>=20){
                _site =0;
                _discount=0;
              }
              else if(total <300000 && _site>=30){
                _site=0;
                _discount=0;
              }
              tongcong = sum-_discount*sum/100;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    Align(
                    alignment: AlignmentDirectional.topStart,
                      child:
                        Container(
                           margin: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            "Giao hàng đến",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 19,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ),
                    SizedBox(height: 3,),
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).pushReplacementNamed(SearchLocationScreen.routeName);
                      },
                      child: Row(
                          children: [
                            Container(
                                    margin: const EdgeInsets.only(left: 7.0),

                            child:
                                Icon(Icons.location_on_outlined,size: 22,),

                            ),
                            Flexible(
                                child: Container(
                                    padding: new EdgeInsets.symmetric(horizontal: 5),
                                    child: RichText(
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      text: TextSpan(
                                          text: '',
                                          style: TextStyle(
                                              color: Colors.blueGrey.shade800,
                                              fontSize: 16.0),
                                          children: [

                                            TextSpan(
                                                text:
                                                ap.bio,
                                                style: const TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold)),
                                          ]),
                                    )
                                ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 7.0),
                              child:
                              Icon(Icons.mode_edit_outline_outlined,size: 22,)

                            ),

                          ],
                        ),
                      // Flexible(
                      //   child: Text(
                      //       ap.bio,
                      //       maxLines: 4,
                      //       style:  TextStyle(
                      //           fontWeight:
                      //           FontWeight.bold
                      //       )
                      //   ),
                      // )
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Container(
                      //       margin: const EdgeInsets.only(left: 7.0),
                      //       child:
                      //       // Row(
                      //       //   children: [
                      //       //     Icon(Icons.location_on_outlined,size: 22,),
                      //       //     SizedBox(
                      //       //       width: 10
                      //       //     ),
                      //       //     RichText(
                      //       //       overflow: TextOverflow.ellipsis,
                      //       //       maxLines: 2,
                      //       //       text: TextSpan(
                      //       //           text: '',
                      //       //           style: TextStyle(
                      //       //               color: Colors.blueGrey.shade800,
                      //       //               fontSize: 16.0),
                      //       //           children: [
                      //       //             TextSpan(
                      //       //                 text:
                      //       //                 ap.bio,
                      //       //                 style: const TextStyle(
                      //       //                     fontWeight:
                      //       //                     FontWeight.bold)),
                      //       //           ]),
                      //       //     ),
                      //       //     // Text(
                      //       //     //   ap.bio,
                      //       //     //   style: TextStyle(
                      //       //     //     color: Colors.black,
                      //       //     //     fontSize: 18,
                      //       //     //     fontWeight: FontWeight.w500,
                      //       //     //   ),
                      //       //     // ),
                      //       //   ],
                      //       // ),
                      //     ),
                      //     Container(
                      //         margin: const EdgeInsets.only(right: 7.0),
                      //         child: Icon(Icons.mode_edit_outline_outlined,size: 22,)),
                      //   ],
                      // ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 1.0),
                      child: Divider(
                        color: AppColor.placeholder
                            .withOpacity(0.5),
                        thickness: 1.1,
                        height: 5,
                      ),
                    ),
                    SizedBox(height: 12,),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: array.length,
                      itemBuilder: (context, index) {
                        CartModel temp = CartModel(
                          id: array[index]['id'],
                          productId: array[index]['productId'].toString(),
                          productName: array[index]['productName'],
                          productPrice: array[index]['productPrice'],
                          quantity: array[index]['quantity'],
                          image: array[index]['image'],
                        );
                        return Card(
                          color: Colors.white,
                          elevation: 5.0,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Image.network(
                                  array[index]['image'],
                                  height: 80,
                                  width: 60,
                                ),
                                SizedBox(
                                  width: 170,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      RichText(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        text: TextSpan(
                                            text: '',
                                            style: TextStyle(
                                                color: Colors.blueGrey.shade800,
                                                fontSize: 16.0),
                                            children: [
                                              TextSpan(
                                                  text:
                                                  '${array[index]['productName']}\n',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold)),
                                            ]),
                                      ),
                                      RichText(
                                        maxLines: 2,
                                        text: TextSpan(
                                            text: 'Giá: ',
                                            style: TextStyle(
                                                color: Colors.blueGrey.shade800,
                                                fontSize: 17.0),
                                            children: [
                                              TextSpan(
                                                  text:
                                                  '${currencyFormatter.format(array[index]['productPrice'] * array[index]['quantity'])}đ\n',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold)),
                                            ]),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        height: 40,
                                        width: 110,
                                        decoration: BoxDecoration(
                                          color: Colors.black12,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 1, right: 1),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    if (array[index]['quantity'] >
                                                        1) {
                                                      editProduct(
                                                          temp,
                                                          false,
                                                          array[index]
                                                          ['quantity'] -
                                                              1);
                                                    }
                                                  },
                                                  icon: Icon(
                                                    Icons.remove,
                                                    color: Colors.black54,
                                                    size: 18,
                                                  ),
                                                ),
                                                Text(
                                                    array[index]['quantity']
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.black54,
                                                    )),
                                                IconButton(
                                                  onPressed: () async {
                                                    await editProduct(
                                                        temp,
                                                        true,
                                                        array[index]['quantity'] +
                                                            1);
                                                    if (array.length == 1) {
                                                      flag = true;
                                                    }
                                                  },
                                                  icon: Icon(
                                                    Icons.add,
                                                    color: Colors.black54,
                                                    size: 20,
                                                  ),
                                                ),
                                              ],
                                            ))),
                                  ],
                                ),
                                IconButton(
                                    onPressed: () async {
                                      await removeProduct(temp, false);
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red.shade800,
                                    )),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    Column(
                      children: [
                        Divider(
                          color: AppColor.placeholder.withOpacity(0.25),
                          thickness: 1.5,
                        ),

                        discount(context),

                        Divider(
                          color: AppColor.placeholder.withOpacity(0.25),
                          thickness: 1.5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                "Phương thức thanh toán",
                                style: Helper.getTheme(context).headline3,
                              ),
                            ),
                            TextButton(
                                onPressed: () {},
                                child: Row(
                                  children: [
                                    // Icon(
                                    //   Icons.add,
                                    //   color: AppColor.orange,
                                    // ),
                                    Text(
                                      "Tiền mặt",
                                      style: TextStyle(
                                        color: AppColor.orange,
                                      ),
                                    )
                                  ],
                                ))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                "Tạm tính",
                                style: Helper.getTheme(context).headline3,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 10.0),

                              child:   Text(
                                "${currencyFormatter.format(sum)} đ",
                                style: Helper.getTheme(context).headline3?.copyWith(
                                  color: AppColor.orange,
                                ),
                              ),
                            )

                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                "Giảm giá",
                                style: Helper.getTheme(context).headline3,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 10.0),

                              child:   Text(
                                "${currencyFormatter.format(_discount*sum/100)} đ",
                                style: Helper.getTheme(context).headline3?.copyWith(
                                  color: AppColor.orange,
                                ),
                              ),
                            )

                          ],
                        ),

                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                "Phí giao hàng",
                                style: Helper.getTheme(context).headline3,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 10.0),
                              child:Text(
                                "0 đ",
                                style: Helper.getTheme(context).headline3?.copyWith(
                                  color: AppColor.orange,
                                ),
                              ) ,
                            )

                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Divider(
                          color: AppColor.placeholder.withOpacity(0.25),
                          thickness: 1.5,
                        ),
                        Column(

                          children:[

                            Container(

                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      'Tổng cộng: ',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(right: 10.0),
                                    child: Text(
                                      '${ currencyFormatter.format(sum-_discount*sum/100)} ₫',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 160, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0)),
                                    textStyle: const TextStyle(
                                        fontSize: 22, fontWeight: FontWeight.bold)),
                                onPressed: () async {
                                  var now = DateTime.now();
                                  var formatter = DateFormat('dd-MM-yyyy');
                                  String formattedDate = formatter.format(now);
                                  final ap = Provider.of<AuthProvider>(context,
                                      listen: false)
                                      .userModel;
                                  OrderModel order = OrderModel(
                                    id: formattedDate,
                                    userId: ap.uid,
                                    address: "1 Võ Văn Ngân",
                                    totalPrice: tongcong,
                                    payment: "",
                                    listCart: array,
                                    discount:_discount.toString(),
                                    ship:"0"
                                  );
                                  CartModel temp1 = CartModel(
                                    id: array[0]['id'],
                                    productId: array[0]['productId'].toString(),
                                    productName: array[0]['productName'],
                                    productPrice: array[0]['productPrice'],
                                    quantity: array[0]['quantity'],
                                    image: array[0]['image'],
                                  );
                                  await addOrder(order);
                                  await removeProduct(temp1, true);
                                },
                                child: const Text(
                                  'Đặt hàng',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],

                        ),


                      ],
                    ),
                  ],
                ),

              );
            }
        }
        ;
      },
    );

  }

  Future<String> addOrder(OrderModel orderModel) async {
    final op = Provider.of<OrderProvider>(context, listen: false);
    // final ap = Provider.of<AuthProvider>(context, listen: false).userModel;
    op.addOrder(context: context, orderModel: orderModel);
    return "1";
  }

  Future<String> editProduct(CartModel cartModel, bool add, int number) async {
    final cp = Provider.of<CartProvider>(context, listen: false);
    final ap = Provider.of<AuthProvider>(context, listen: false).userModel;
    cp.editCart(
      context: context,
      uid: ap.uid,
      cartModel: cartModel,
      add: add,
      number: number,
    );

    return "1";
  }

  Future<String> removeProduct(CartModel cartModel, bool all) async {
    final cp = Provider.of<CartProvider>(context, listen: false);
    final ap = Provider.of<AuthProvider>(context, listen: false).userModel;
    cp.removeToCart(
        context: context, uid: ap.uid, cartModel: cartModel, all: all);

    return "1";
  }

  Widget discount(BuildContext context) {
    final currencyFormatter = NumberFormat(
      '#,###',
    );


    return StreamBuilder<QuerySnapshot>(

        stream: FirebaseFirestore.instance
        .collection('code')
        .snapshots(),
    builder: (context, snapshot) {
    switch (snapshot.connectionState) {
    case ConnectionState.waiting:
    return const Center(
    child: CircularProgressIndicator(),
    );
    default:
    if (snapshot.hasError) {
    return Text('Error: ${snapshot.error}');
    } else {
      return GestureDetector(
        onTap: () async { await showModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            isScrollControlled: true,
            isDismissible: true,
            context: context,
            builder: (context) {
              return StatefulBuilder(builder: (BuildContext context, StateSetter state)
              {
                return Container(
                  height: Helper.getScreenHeight(context),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(
                                Icons.clear,
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0),
                          child: Row(
                            children: [
                              Text(
                                "Chọn E-voucher để được giảm giá",
                                style: Helper
                                    .getTheme(context)
                                    .headline3,
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0),
                          child: Divider(
                            color: AppColor.placeholder
                                .withOpacity(0.5),
                            thickness: 1.5,
                            height: 40,
                          ),
                        ),

                        Container(
                          margin: const EdgeInsets.only(right: 200.0),
                          child: Text(
                            'Mã ưu đãi của bạn: ',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            child: Column(
                              children: [
                                ...snapshot.data!.docs.map<Widget>((data) {
                                  var isDisabled = true;

                                  if(total>= int.parse(data['condition'])){
                                    isDisabled =false;
                                  }
                                  print(total);
                                  return Container(
                                    height: 100,
                                    width: Helper.getScreenWidth(context),
                                    decoration: BoxDecoration(
                                      color: AppColor.placeholderBg,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColor.placeholder.withOpacity(0.5),
                                          offset: Offset(0, 10),
                                          blurRadius:10,
                                          spreadRadius:1,
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 20,
                                      ),
                                      child: Column(
                                        children: [

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                height: 60,
                                                child: Image.network(
                                                  data['img'],
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  Text(data['info'], style: TextStyle(
                                                    fontSize: 16.0,

                                                  ),),
                                                  Text("Cho đơn hàng từ ${currencyFormatter.format(int.parse(data['condition']))}₫", style: TextStyle(
                                                    fontSize: 16.0,

                                                  ),),
                                                ],
                                              ),

                                              // Text("2187"),
                                              Radio(
                                                  value:data['price'] ,
                                                  groupValue: _site,

                                                  onChanged:  (value) {
                                                    isDisabled ? null :
                                                    state(() {
                                                      _site = value;
                                                       _discount=value;

                                                    });})

                                            ],
                                          ),

                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                  //               snapshot.data!.docs.map((data) =>
                  //           return Container(),
                  // )
                    ]
                        )),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0),
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [

                                    Text("Áp dụng ưu đãi"),

                                  ],
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              });
            }
        );setState((){}); },
        child: Container(
          height: 40,

          child: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,

                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),

                ),
                child: Row(
                  children: [
                    Icon(Icons.card_giftcard),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Chọn mã giảm giá",
                      style: TextStyle(
                        color: AppColor.orange,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.only(right: 10.0),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColor.secondary,
                    size: 17,
                  ),
                ),
              ),

            ],
          ),
        ),
      );
    }}});
  }


  Widget _empty(BuildContext context) {
    return Column(
      children: [
        new Container(margin: new EdgeInsets.only(top: 150)),
        Image.network(
          "https://media.istockphoto.com/id/1139666909/vector/shopping-cart-shop-trolley-or-basket-in-the-supermarket.jpg?s=612x612&w=0&k=20&c=_HajO7ifYKxuwzKFf-Fx9lsLKBa_1Rq9vuzGiPq8Q5Q=",
          width: 200,
        ),
        const Center(
            child: Text(
          'Giỏ hàng trống',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        )),
        const Center(
            child: Text(
          'Hiện tại bạn chưa đặt món nào trong',
          style: TextStyle(fontSize: 15.0),
        )),
        const Center(
            child: Text(
          'giỏ hàng cả.',
          style: TextStyle(fontSize: 15.0),
        )),
        new Container(margin: new EdgeInsets.only(top: 10)),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
              textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
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
