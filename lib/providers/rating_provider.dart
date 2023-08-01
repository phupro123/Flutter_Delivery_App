import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_final/model/rating_model.dart';
import 'package:toastification/toastification.dart';

import '../utils/utils.dart';

class RatingProvider extends ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  void addRating({
    required BuildContext context,
    required int? productId,
    required RatingModel ratingModel,
  }) async {

    try {
      // await _firebaseFirestore
      //     .collection("ratings")
      //     .doc(productId.toString())
      //     .set({'arrayRating': FieldValue.arrayUnion([])});
      //
      // await _firebaseFirestore
      //     .collection("ratings")
      //     .doc(productId.toString())
      //     .update({'arrayRating': FieldValue.arrayUnion([ratingModel.toMap()])});

      await checkExistingRating(productId, ratingModel).then(
            (value) async {

          if (value == 0) {
            await _firebaseFirestore
                .collection("ratings")
                .doc(productId.toString())
                .set({'arrayRating': FieldValue.arrayUnion([ratingModel.toMap()])}).then((value) {
              notifyListeners();
            });
            return;
          }

          await _firebaseFirestore
              .collection("ratings")
              .doc(productId.toString())
              .update({'arrayRating': FieldValue.arrayUnion([ratingModel.toMap()])});
            },
      );

      toastification.show(
        context: context,
        title: 'Thêm đánh giá thành công!',
        backgroundColor: Colors.green,
        icon: Icon(
          Icons.check_circle_sharp,
          color: Colors.white,
        ),
        autoCloseDuration: const Duration(seconds: 3),
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());

      notifyListeners();
    }
  }

  Future checkExistingRating(int? productId, RatingModel ratingModel) async {
    DocumentSnapshot snapshot =
    await _firebaseFirestore.collection("ratings").doc(productId.toString()).get();
    if (snapshot.data() == null)
      return 0;

    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    var result ;
    result = data['arrayRating'].firstWhere((item)=> ratingModel.userId == item['userId'],orElse: () => null);
    if(result== null)
      return 0;
    else
      return result['star'];
  }
}
