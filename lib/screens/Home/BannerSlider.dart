import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_final/const/colors.dart';
import 'package:project_final/utils/helper.dart';

class RecordBanner {
  final int id;
  final String image;
  final DocumentReference reference;
  RecordBanner.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(
    snapshot.data() as Map<dynamic, dynamic>,
    reference: snapshot.reference,
  );
  RecordBanner.fromMap(
      Map<dynamic, dynamic> map, {
        required this.reference,
      }) :
        assert(map['id'] != null),
        assert(map['image'] != null),
        id = map['id'],
        image = map['image'];
  @override
  String toString() => "RecordBanner<$id:$image>";
}
class BannerSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Container(
      width: double.infinity,
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('carousel_sliders').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        List<QueryDocumentSnapshot<Object?>> imgList = snapshot.data?.docs ?? [];
        final List<Widget> img = imgList.map((item) => Container(
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Image.network(
                    RecordBanner.fromSnapshot(item).image,
                    fit: BoxFit.cover, width: 1000.0
                ),
            ),
          ),
        )).toList();
        return CarouselSlider(
          options: CarouselOptions(
            aspectRatio: 2.0,
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            initialPage: 2,
            autoPlay: true,
          ),
          items: img,
        );
      },
    );
  }
}
