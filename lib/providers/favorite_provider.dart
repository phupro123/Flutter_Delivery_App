import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_final/model/favorite_model.dart';
import 'package:project_final/model/product_model.dart';
import 'package:toastification/toastification.dart';

import '../utils/utils.dart';

class FavoriteProvider extends ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  void addFavorite({
    required BuildContext context,
    required String? userId,
    required FavoriteModel favoriteModel,
  }) async {

    try {
      await checkExistingFavorite(userId, favoriteModel).then(
            (value) async {
          print(value);
          if (value == 2) {
            return;
          }
          if (value == 0) {
            await _firebaseFirestore
                .collection("favorites")
                .doc(userId.toString())
                .set({'arrayFavorite': FieldValue.arrayUnion([favoriteModel.toMap()])}).then((value) {
              notifyListeners();
            });
            return;
          }
          await _firebaseFirestore
              .collection("favorites")
              .doc(userId.toString())
              .update({'arrayFavorite': FieldValue.arrayUnion([favoriteModel.toMap()])});
          }
      );

      toastification.show(
        context: context,
        title: 'Đã thêm ${favoriteModel.productModel.name} vào mục yêu thích!',
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

  void removeToCart({
  required BuildContext context,
    required String? userId,
    required ProductModel productModel,
  }) async {
    try {
        // Get Array
        DocumentSnapshot snapshot =
        await _firebaseFirestore.collection("favorites").doc(userId).get();
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

       var result = data['arrayFavorite'].firstWhere((item)=> productModel.id == item['productModel']['id'],
           orElse: () => null);

        await _firebaseFirestore.collection("favorites").doc(userId).update({
          "arrayFavorite": FieldValue.arrayRemove([result]),
        });

        toastification.show(
          context: context,
          title: 'Đã xóa ${productModel.name} khỏi mục yêu thích!',
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

  Future checkExistingFavorite(String? userId, FavoriteModel favoriteModel) async {
    DocumentSnapshot snapshot =
    await _firebaseFirestore.collection("favorites").doc(userId.toString()).get();

    if (snapshot.data() == null)
      return 0;

    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    var result ;
    if(data['arrayFavorite'] == null)
      return 0;
    result = data['arrayFavorite'].firstWhere((item)=> favoriteModel.productModel?.id == item['productModel']['id'],orElse: () => null);
    if(result== null)
      return 1;
    return 2;
  }
}
