class OrderModel{
   String? id;
   String? userId;
  String address;
  double  totalPrice;
   List<dynamic>?  listCart;
   String? payment;
   String discount;
   String? ship;

  OrderModel(
  {
    required this.id,
    required this.userId,
    required this.address,
    required this.totalPrice,
    required this.listCart,
    required this.payment,
    required this.discount,
    required this.ship,

  }
  );
  OrderModel.fromMap(Map<dynamic,dynamic> res)
  : id = res['id'],
  userId = res['userId'],
  address = res['address'], 
  totalPrice = res['totalPrice'],
  listCart = res['listCart'],
  payment = res['payment'],
  discount = res['discount'],
  ship = res['ship'];


  Map<String,Object?> toMap(){
    return{
      'id':id,
      'userId':userId,
      'address':address,
      'totalPrice':totalPrice,
      'listCart':listCart,
      'payment':payment,
      'discount':discount,
      'ship':ship,
    };
  }
}
