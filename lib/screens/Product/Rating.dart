import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:project_final/const/colors.dart';
import 'package:project_final/model/rating_model.dart';
import 'package:project_final/providers/auth_provider.dart';
import 'package:project_final/providers/rating_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class Rating extends StatefulWidget {
  const Rating({Key? key, required this.id, required this.name, required this.image, required this.arrayLength})
      : super(key: key);

  final int id;
  final String name;
  final String image;
  final int arrayLength;

  @override
  State<Rating> createState() => _Rating();
}

class _Rating extends State<Rating> {
  int _rating = 0;
  String _content = '';

  void addRating(int rating) {
    setState(() { _rating = rating; });
  }

  void handleChangeContent(String content) {
    setState(() { _content = content; });
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.only(
        left: 20,
      ),
      child: TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.network(
                          widget.image,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            widget.name,
                            style: TextStyle(fontSize: 15),
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.fade, //new
                          ),
                        ),
                      ],
                    ),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RatingBar.builder(
                          initialRating: 0,
                          minRating: 1,
                          direction: Axis.horizontal,
                          itemCount: 5,
                          itemSize: 30,
                          itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: AppColor.orange,
                          ),
                          onRatingUpdate: (rating) {
                            addRating(rating.toInt());
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    color:Colors.greenAccent,
                                  )
                              ),
                              hintText: 'Mời bạn chia sẻ cảm nhận sản phẩm'
                          ),
                          onChanged: (text) {
                            handleChangeContent(text);
                          },
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            storeData(_rating, _content);
                          },
                          child: Text('OK', style: TextStyle(fontSize: 20),)
                      ),
                      TextButton(
                          onPressed: () { Navigator.pop(context);},
                          child: Text('Cancel', style: TextStyle(fontSize: 20),)
                      )
                    ],
                  ),
                );
              },
              child: Text(
                '(Thêm đánh giá)',
                style: TextStyle(fontSize: 17),
              )
          )
    );
  }

  void storeData(int rating, String content) async {
    final rp = Provider.of<RatingProvider>(context, listen: false);
    final ap = Provider.of<AuthProvider>(context, listen: false).userModel;

    RatingModel ratingModel = RatingModel(
      id: const Uuid().v4(),
      userId: ap.uid.toString(),
      name: ap.name,
      profilePic: ap.profilePic,
      star: rating,
      content: content,
    );
    rp.addRating(context: context, productId: widget.id, ratingModel: ratingModel);
  }
}