class CartModel{
  late final String? id;
  final String? productId;
  final String productName;
  final int?  productPrice;
  final int?  quantity;
  final String? image;

  CartModel(
  {
    required this.id,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.quantity,
    required this.image,
  }
  );
  CartModel.fromMap(Map<dynamic,dynamic> res)
  : id = res['id'],
  productId = res['productId'],
  productName = res['productName'],
  productPrice = res['productPrice'],
  quantity = res['quantity'],
  image = res['image'];

  Map<String,Object?> toMap(){
    return{
      'id':id,
      'productId':productId,
      'productName':productName,
      'productPrice':productPrice,
      'quantity':quantity,
      'image':image,
    };
  }
}
