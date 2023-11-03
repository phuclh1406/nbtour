import 'package:nbtour/services/models/file_sound_model.dart';
import 'package:nbtour/services/models/image_model.dart';

List<PointOfInterest> pointOfInterestFromJson(dynamic str) =>
    List<PointOfInterest>.from((str).map((x) => PointOfInterest.fromJson(x)));

class PointOfInterest {
  PointOfInterest({
    required this.poiId,
    required this.poiName,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.poiImage,
    required this.poiSound,
  });
  late String? poiId;
  late String? poiName;
  late String? description;
  late String? address;
  late String? latitude;
  late String? longitude;
  late String? status;
  late List<ImageModel>? poiImage;
  late List<FileSound>? poiSound;

  PointOfInterest.fromJson(Map<String, dynamic> json) {
    poiId = json['poiId'];
    poiName = json['poiName'];
    description = json['description'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    status = json['status'];

    if (json['poi_image'] != null && json['poi_image'] is List) {
      poiImage = List<ImageModel>.from(
        json['poi_image'].map((x) => ImageModel.fromJson(x)),
      );
    }

    if (json['poi_sound'] != null && json['poi_sound'] is List) {
      poiSound = List<FileSound>.from(
        json['poi_sound'].map((x) => FileSound.fromJson(x)),
      );
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['poiId'] = poiId;
    data['poiName'] = poiName;
    data['description'] = description;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['status'] = status;

    if (poiImage != null && poiImage!.isNotEmpty) {
      data['poi_image'] = poiImage!.map((poiImage) {
        return {
          'imageId': poiImage.imageId,
          'image': poiImage.image,
        };
      }).toList();
    }

    if (poiSound != null && poiSound!.isNotEmpty) {
      data['poi_sound'] = poiSound!.map((poiSound) {
        return {
          'soundId': poiSound.soundId,
          'file': poiSound.file,
          'sound_language': poiSound.soundLanguage,
        };
      }).toList();
    }

    return data;
  }
}
