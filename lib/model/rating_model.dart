class RatingModel {
  late final String? id;
  final String? userId;
  final String? name;
  final String profilePic;
  final int? star;
  final String? content;

  RatingModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.profilePic,
    required this.star,
    required this.content,
  });

  // from map
  RatingModel.fromMap(Map<dynamic,dynamic> res)
      : id = res['id'],
        userId = res['userId'],
        name = res['name'],
        profilePic = res['profilePic'],
        star = res['star'],
        content = res['content'];

  // to map
  Map<String, Object?> toMap() {
    return {
      "id": id,
      "userId": userId,
      "name": name,
      "profilePic": profilePic,
      "star": star,
      "content": content,
    };
  }
}
