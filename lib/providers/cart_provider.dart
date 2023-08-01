import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:project_final/model/cart_model.dart';
import 'package:toastification/toastification.dart';

import '../utils/utils.dart';

class CartProvider extends ChangeNotifier {

  List<CartModel> temp= [];
  dynamic _totalPrice = 0.0;
  dynamic _discount = 0.0;
  // addToCart(CartModel cartModel){
  //   temp.add(cartModel);
  //   _totalPrice += cartModel.productPrice;
  //   notifyListeners();
  // }


  // void remove(CartModel cartModel) {
  //   _totalPrice -= cartModel.productPrice;
  //   temp.remove(cartModel);
  //   notifyListeners();
  // }
  dynamic get totalPrice {
    return _totalPrice;
  }
  dynamic get discount {
    return _discount;
  }

  List<CartModel> get cartItems {
    return temp;
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;



  void addToCart({
    required BuildContext context,
    required String? uid,
    required CartModel cartModel,
  }) async {
    try {

      await checkExistingProduct(uid, cartModel).then(
            (value) async {

          if (value == 0) {
            await _firebaseFirestore
                .collection("carts")
                .doc(uid)
                .update({'arrayCart': FieldValue.arrayUnion([cartModel.toMap()])})
                .then((value) {


              notifyListeners();
            });

          }
          else{

            // Get Array
            DocumentSnapshot snapshot =
            await _firebaseFirestore.collection("carts").doc(uid).get();
            Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

            var temp= cartModel.toMap() ;

            var quantity = 0;
            var item;
            // Change quantity
            print(data['arrayCart']);
            var list= data['arrayCart'].map((e){
              if(e['productId']==cartModel.productId) {
                item = e;

                quantity= e['quantity'] +cartModel.quantity;

              }
              return e;
            }
            ).toList();


            print(item);
            await _firebaseFirestore.collection("carts").doc(uid).update({
              "arrayCart": FieldValue.arrayRemove([
                item
              ]),
            });
            temp['quantity'] = quantity;
            await _firebaseFirestore
                .collection("carts")
                .doc(uid)
                .update({'arrayCart': FieldValue.arrayUnion([temp])})
                .then((value) {
              notifyListeners();
            });

          }
        },
      );

      toastification.show(
        context: context,
        title: 'Thêm vào giỏ hàng thành công!',
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

  void editCart({
    required BuildContext context,
    required String? uid,
    required CartModel cartModel,
    required bool add,
    required int number,
  }) async {
    try {
            // Get Array
            DocumentSnapshot snapshot =
            await _firebaseFirestore.collection("carts").doc(uid).get();
            Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

            var temp= cartModel.toMap() ;
              temp['quantity'] = number ;

            await _firebaseFirestore.collection("carts").doc(uid).update({
              "arrayCart": FieldValue.arrayRemove([
                cartModel.toMap()
              ]),
            });
            await _firebaseFirestore
                .collection("carts")
                .doc(uid)
                .update({'arrayCart': FieldValue.arrayUnion([temp])})
                .then((value) {
              notifyListeners();
            });

    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());

      notifyListeners();
    }
  }

  void removeToCart({
    required BuildContext context,
    required String? uid,
    required CartModel cartModel,
    required bool all
  }) async {
    try {
      DocumentSnapshot snapshot =
      await _firebaseFirestore.collection("carts").doc(uid).get();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      if(all== true){
        // Delete cart
        final updates = <String, dynamic>{
          "arrayCart": [],
        };
        await _firebaseFirestore
            .collection("carts")
            .doc(uid)
            .update(updates);
      }
      else{
        // Get Array
        DocumentSnapshot snapshot =
        await _firebaseFirestore.collection("carts").doc(uid).get();
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        await _firebaseFirestore.collection("carts").doc(uid).update({
          "arrayCart": FieldValue.arrayRemove([
              cartModel.toMap()
          ]),
        });
        toastification.show(
          context: context,
          title: 'Xóa sản phẩm khỏi giỏ hàng thành công!',
          backgroundColor: Colors.green,
          icon: Icon(
            Icons.check_circle_sharp,
            color: Colors.white,
          ),
          autoCloseDuration: const Duration(seconds: 2),
        );
      }


    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());

      notifyListeners();
    }
  }

  Future checkExistingProduct(String? uid, CartModel cartModel) async {
    DocumentSnapshot snapshot =
    await _firebaseFirestore.collection("carts").doc(uid).get();

    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    var result ;
     result = data['arrayCart'].firstWhere((item)=> cartModel.productId== item['productId'],orElse: () => null);

    if(result== null)
       return 0;
     else
     return result['quantity'];
  }
}
