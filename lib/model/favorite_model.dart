import 'package:project_final/model/product_model.dart';

class FavoriteModel {
  late final String id;
  late final ProductModel productModel;

  FavoriteModel({
    required this.id,
    required this.productModel,
  });

  // from map
  FavoriteModel.fromMap(Map<dynamic,dynamic> res) {
    id = res['id'];
    productModel = ProductModel.fromMap(res["productModel"]);
  }

  // to map
  Map<String, Object?> toMap() {
    return {
      "id": id,
      "productModel": productModel.toMap(),
    };
  }
}
