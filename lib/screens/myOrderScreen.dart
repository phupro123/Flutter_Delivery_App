import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_final/const/colors.dart';
import 'package:project_final/model/order_model.dart';
import 'package:project_final/screens/Login/checkoutScreen.dart';
import 'package:project_final/utils/helper.dart';

class MyOrderScreen extends StatelessWidget {
  static const routeName = "/myOrderScreen";
  const MyOrderScreen({Key? key, required this.item,
    })
      : super(key: key);

  final OrderModel item;


  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat('#,###', );
    double discount =item.totalPrice *int.parse(item.discount)/100;
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
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
                    Expanded(
                      child: Text(
                        "Chi tiết đơn hàng",
                        style: Helper.getTheme(context).headline5,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SizedBox(
                    height: 80,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: 80,
                            width: 80,
                            child: Icon(
                                Icons.fastfood
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              "Gà rán KFC",
                              style: Helper.getTheme(context).headline3,
                            ),
                            Row(
                              children: [
                                Icon(
                                    Icons.star
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "4.9",
                                  style: TextStyle(
                                    color: AppColor.orange,
                                  ),
                                ),
                                Text(" (124 Đánh giá)"),
                              ],
                            ),
                            Row(
                              children: [
                                Text("Thức ăn nhanh"),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 5,
                                  ),
                                  child: Text(
                                    ".",
                                    style: TextStyle(
                                      color: AppColor.orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  height: 15,
                                  child: Icon(
                                      Icons.location_on
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("251 Võ Văn Ngân")
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: double.infinity,
                  color: AppColor.placeholderBg,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: item.listCart!.map((data) =>
                         BurgerCard(name: data['productName'], price: data['productPrice'],quantity: data['quantity'],)).toList(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: AppColor.placeholder.withOpacity(0.25),
                            ),
                          ),
                        ),

                        child: Row(
                          children: [
                            Expanded(
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
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(

                            child: Text(
                              "Tạm tính",
                              style: Helper.getTheme(context).headline3,
                            ),
                          ),
                          Container(
                            // margin: const EdgeInsets.only(right: 10.0),

                            child:   Text(
                              "${currencyFormatter.format((item.totalPrice+discount).round())} đ",
                              style: Helper.getTheme(context).headline3?.copyWith(
                                color: AppColor.orange,
                              ),
                            ),
                          )

                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Giảm giá",
                              style: Helper.getTheme(context).headline3,
                            ),
                          ),
                          Text(
                              "${currencyFormatter.format(discount)}đ",
                            style: Helper.getTheme(context).headline3?.copyWith(
                                  color: AppColor.orange,
                                ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Phí giao hàng",
                              style: Helper.getTheme(context).headline3,
                            ),
                          ),
                          Text(
                            "0đ",
                            style: Helper.getTheme(context).headline3?.copyWith(
                                  color: AppColor.orange,
                                ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        color: AppColor.placeholder.withOpacity(0.25),
                        thickness: 1.5,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Tổng cộng",
                              style: Helper.getTheme(context).headline3,
                            ),
                          ),
                          Text(
                            "${currencyFormatter.format(item.totalPrice.round())}đ",
                            style: Helper.getTheme(context).headline3?.copyWith(
                                  color: AppColor.orange,
                                  fontSize: 22,
                                ),
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(CheckoutScreen.routeName);
                          },
                          child: Text("Đặt lại đơn hàng"),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   child: CustomNavBar(),
          // ),
        ],
      ),
    );
  }
}

class BurgerCard extends StatelessWidget {

  const BurgerCard({
    Key? key,
    required String name,
    required int price,
    required int quantity,
    bool isLast = false,
  })  : _name = name,
        _price = price,
        _quantity = quantity,

      _isLast = isLast,
        super(key: key);

  final String _name;
  final int _price;
  final int _quantity;

  final bool _isLast;
  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat('#,###', );
    return Container(
      height: 60,
      decoration: BoxDecoration(
        border: Border(
          bottom: _isLast
              ? BorderSide.none
              : BorderSide(
                  color: AppColor.placeholder.withOpacity(0.25),
                ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "${_name} x$_quantity",
              style: TextStyle(
                color: AppColor.primary,
                fontSize: 19,
              ),
            ),
          ),
          Text(
            "${currencyFormatter.format(_price*_quantity)}đ",
            style: TextStyle(
              color: AppColor.primary,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          )
        ],
      ),
    );
  }
}


