import 'package:nbtour/services/models/language_model.dart';

List<FileSound> fileSoundsFromJson(dynamic str) =>
    List<FileSound>.from((str).map((x) => FileSound.fromJson(x)));

class FileSound {
  FileSound({
    required this.soundId,
    required this.file,
    required this.status,
    required this.soundLanguage,
  });
  late String? soundId;
  late String? file;
  late String? status;
  late List<Language>? soundLanguage;

  FileSound.fromJson(Map<String, dynamic> json) {
    soundId = json['soundId'];
    file = json['file'];
    status = json['status'];

    if (json['sound_language'] != null && json['sound_language'] is List) {
      soundLanguage = List<Language>.from(
        json['sound_language'].map((x) => Language.fromJson(x)),
      );
    } else {
      soundLanguage = [];
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['soundId'] = soundId;
    data['file'] = file;
    data['status'] = status;

    if (soundLanguage != null) {
      data['sound_language'] = soundLanguage?.map((x) => x.toJson()).toList();
    }

    return data;
  }
}
