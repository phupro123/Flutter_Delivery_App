class CategoryModel{
  late final String id;
  final String  name;
  final String imageHome;
  final String image;
  final String  imageSelected;

  CategoryModel(
  {
    required this.id,
    required this.name,
    required this.imageHome,
    required this.image,
    required this.imageSelected,
  }
  );
  CategoryModel.fromMap(Map<String,dynamic> res)
  : id = res['id'],
        name = res['name'],
        imageHome = res['imageHome'],
        image = res['image'],
        imageSelected = res['imageSelected'];

  Map<String,Object?> toMap(){
    return{
      'id':id,
      'name':name,
      'imageHome':imageHome,
      'image':image,
      'imageSelected':imageSelected,
    };
  }
}
