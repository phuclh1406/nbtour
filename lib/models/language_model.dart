List<Language> languagesFromJson(dynamic str) =>
    List<Language>.from((str).map((x) => Language.fromJson(x)));

class Language {
  Language({
    required this.languageId,
    required this.language,
    required this.status,
  });
  late String? languageId;
  late String? language;
  late String? status;

  Language.fromJson(Map<String, dynamic> json) {
    languageId = json['languageId'];
    language = json['language'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['languageId'] = languageId;
    _data['language'] = language;
    _data['status'] = status;

    return _data;
  }
}
