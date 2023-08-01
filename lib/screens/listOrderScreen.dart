import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_final/const/colors.dart';

import 'package:project_final/screens/moreScreen.dart';
import 'package:project_final/screens/myOrderScreen.dart';
import 'package:project_final/utils/helper.dart';
import 'package:project_final/widgets/customNavBar.dart';
import 'package:provider/provider.dart';

import '../model/order_model.dart';
import '../providers/auth_provider.dart';

class ListOrderScreen extends StatefulWidget {
  static const routeName = "/ListOrderScreen";

  @override
  State<ListOrderScreen> createState() => _ListOrderScreen();
}

class _ListOrderScreen extends State<ListOrderScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child:Container(
              height: Helper.getScreenHeight(context),
              padding: const EdgeInsets.symmetric(vertical: 20),
              child:SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacementNamed(MoreScreen.routeName);
                            },
                            child: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            "Danh sách đơn hàng",
                            style: Helper.getTheme(context).headline5,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: ListOrder(),
                    ),
                    SizedBox(
                      height: 180,
                    ),
                  ],
                ),
              ),
            )
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
    );
  }
}

class ListOrder extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        left: 20,
      ),
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false).userModel;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Orders')

          .where('userId', isEqualTo: ap.uid)
          // // .orderBy('id')
          // .orderBy('id', descending: true)
          .snapshots(),

      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data?.docs ?? []);
      }, ); }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(
          //   height: 10,
          // ),
          SingleChildScrollView(
            // padding: EdgeInsets.all(12),
            child: Column(
              children:  snapshot.map((data) =>
                  _buildListItem(context, data)).toList(),
            ),
          ),
          SizedBox(
            height: 370,
          ),
        ]
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {

    final currencyFormatter = NumberFormat('#,###', );
    return Container(
      child: Card(
        margin: const EdgeInsets.only(bottom: 20, right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Image(
                width: 80,
                height: 80,
                image: NetworkImage(data['listCart'][0]['image']),
                fit:BoxFit.cover,
              ),
              title: Text("Đơn hàng "+ data['id'], style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColor.orange),),
              subtitle: Text('Tổng tiền: ${currencyFormatter.format(data['totalPrice']).toString()}đ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColor.primary),),
              onTap: () {
               OrderModel item = OrderModel(id: data['id'], userId: data['userId'], address:data['address'] , totalPrice:data['totalPrice'] , listCart: data['listCart'], payment:data['payment'],discount: data['discount'], ship: data['ship'] );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyOrderScreen(item: item),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

