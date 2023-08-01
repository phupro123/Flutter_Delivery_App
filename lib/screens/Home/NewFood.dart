import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_final/const/colors.dart';
import 'package:project_final/model/product_model.dart';
import 'package:project_final/screens/ItemDetail.dart';
import 'package:project_final/utils/helper.dart';

class NewFood extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Container(
      width: double.infinity,
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('menus').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data?.docs ?? []);
      }, ); }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return Container(
      height: 300,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: snapshot.map((data) =>
            _buildListItem(context, data)).toList(),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = ProductModel.fromMap(data.data() as Map<String, dynamic>);
    return  Padding(
      padding: EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ListDetailPage(product: record),
            ),
          );
        },
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                  width: 100,
                  height: 100,
                  child: Image.network(
                    record.image,
                    fit: BoxFit.cover,
                  )
              ),
            ),
            SizedBox(height: 5,),
            Container(
              width: 100,
              alignment: Alignment.center,
              child: Text(
                overflow: TextOverflow.ellipsis,
                record.name,
                style: Helper.getTheme(context).headline4?.copyWith(color: AppColor.primary, fontSize: 12),
              ),
            )
          ],
        ),
      ),
    );
  }
}
