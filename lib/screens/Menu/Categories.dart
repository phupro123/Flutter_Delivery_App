import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_final/const/colors.dart';
import 'package:project_final/utils/helper.dart';

class RecordCategories {
  final int id;
  final String name;
  final String image;
  final String imageNotSelect;
  final DocumentReference reference;
  RecordCategories.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(
    snapshot.data() as Map<dynamic, dynamic>,
    reference: snapshot.reference,
  );
  RecordCategories.fromMap(
      Map<dynamic, dynamic> map, {
        required this.reference,
      }) :
        assert(map['id'] != null),
        assert(map['name'] != null),
        assert(map['image'] != null),
        assert(map['imageNotSelect'] != null),
        id = map['id'],
        name = map['name'],
        image = map['image'],
        imageNotSelect = map['imageNotSelect'];
  @override
  String toString() => "RecordCategories<$id:$name:$image>";
}

class Categories extends StatelessWidget {
  int categoryId;
  Function handleChangeCategory;

  Categories({Key? key, required this.categoryId, required this.handleChangeCategory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: double.infinity,
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('categories').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data?.docs ?? []);
      }, ); }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return Container(
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: snapshot.map((data) =>
            _buildListItem(context, data)).toList(),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = RecordCategories.fromSnapshot(data);
    return Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: GestureDetector(
          onTap: () {
            handleChangeCategory(record.id, record.name);
          },
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 60,
                  height: 60,
                  child: Image.network(
                    categoryId == record.id ? record.image :  record.imageNotSelect,
                    fit: BoxFit.cover,
                  )
                ),
              ),
              SizedBox(height: 5,),
              Text(
                record.name,
                style: Helper.getTheme(context).headline4?.copyWith(color: AppColor.primary, fontSize: 8),
              ),
            ],
          ),
        ),
    );
  }
}
