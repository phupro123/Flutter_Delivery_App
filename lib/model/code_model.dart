class CodeModel{
  late final String? id;
  final String? code;
  final int price;
  final String?  info;
  final String? condition;
  final String? img;

  CodeModel(
  {
    required this.id,
    required this.code,
    required this.price,
    required this.info,
    required this.condition,
    required this.img,

  }
  );
  CodeModel.fromMap(Map<dynamic,dynamic> res)
  : id = res['id'],
  code = res['code'],
  price = res['price'],
  info = res['info'],
  condition = res['condition'],
  img = res['img'];

  Map<String,Object?> toMap(){
    return{
      'id':id,
      'code':code,
      'price':price,
      'info':info,
      'condition':condition,
      'img':img,
    };
  }
}
