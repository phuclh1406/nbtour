// user_id, user_name, email, password, birthday, avatar, address, phone, accessChangePassword, refresh_token, role_id, status

List<ImageModel> imagesFromJson(dynamic str) =>
    List<ImageModel>.from((str).map((x) => ImageModel.fromJson(x)));

class ImageModel {
  late String? imageId;
  late String? image;

  ImageModel({
    this.imageId,
    this.image,
  });

  ImageModel.fromJson(Map<String, dynamic> json) {
    imageId = json['image_id'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image_id'] = imageId;
    data['image'] = image;

    return data;
  }
}
