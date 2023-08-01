import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_final/model/order_model.dart';
import 'package:toastification/toastification.dart';

import '../utils/utils.dart';

class OrderProvider extends ChangeNotifier {


  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  void addOrder({
    required BuildContext context,
    required OrderModel orderModel,
  }) async {
    try {

            // Add new
            await _firebaseFirestore
                .collection("Orders")
                .add(orderModel.toMap());

      toastification.show(
        context: context,
        title: 'Đăt hàng thành công!',
        backgroundColor: Colors.green,
        icon: Icon(
          Icons.check_circle_sharp,
          color: Colors.white,
        ),
        autoCloseDuration: const Duration(seconds: 2),
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());

      notifyListeners();
    }
  }
}
