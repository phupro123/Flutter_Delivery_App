import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_final/model/favorite_model.dart';
import 'package:project_final/model/product_model.dart';
import 'package:project_final/providers/auth_provider.dart';
import 'package:project_final/providers/favorite_provider.dart';
import 'package:project_final/screens/Menu/menuScreen.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class Favorite extends StatefulWidget {
  const Favorite({Key? key, required this.product})
      : super(key: key);

  final ProductModel product;

  @override
  State<Favorite> createState() => _Favorite();
}

class _Favorite extends State<Favorite> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider
        .of<AuthProvider>(context, listen: false)
        .userModel;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('favorites')
          .doc(ap.uid)
          .snapshots(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Text('Awaiting result...');
          default:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            else {
              var array;
              if (snapshot.data?.data() == null) {
                array = [];
              }
              else {
                array = snapshot.data!['arrayFavorite'];
              }
              var result = array.firstWhere((item)=> widget.product.id == item['productModel']['id'],orElse: () => false);
              if (result == false) {
                return Container(
                    child: IconButton(
                      onPressed: () {
                        addProductToFavorite();
                      },
                      icon: Icon(
                        Icons.favorite_border,
                        color: Colors.red,
                        size: 40,
                      ),
                    )
                );
              }
              return Container(
                  child: IconButton(
                    onPressed: () {
                      removeProductFromFavorite(widget.product);
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 40,
                    ),
                  )
              );
            }
        }
      },
    );
  }

  void addProductToFavorite() async {
    final fp = Provider.of<FavoriteProvider>(context, listen: false);
    final ap = Provider.of<AuthProvider>(context, listen: false).userModel;

    FavoriteModel favoriteModel = FavoriteModel(
      id: const Uuid().v4(),
      productModel: widget.product,
    );
    fp.addFavorite(context: context, userId: ap.uid, favoriteModel: favoriteModel);
  }

  void removeProductFromFavorite(ProductModel productModel) async {
    final fp = Provider.of<FavoriteProvider>(context, listen: false);
    final ap = Provider.of<AuthProvider>(context, listen: false).userModel;

    fp.removeToCart(context: context, userId: ap.uid, productModel: productModel);
  }
}