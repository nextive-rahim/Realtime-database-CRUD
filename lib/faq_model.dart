import 'dart:convert';

List<Faq> productResponseModelFromJson(String str) =>
    List<Faq>.from(json.decode(str).map((x) => Faq.fromJson(x)));

String productResponseModelToJson(List<Faq> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Faq {
  String? answer;
  String? question;
  int? id;

  Faq({
    this.answer,
    this.question,
    this.id,
  });

  factory Faq.fromJson(Map<String, dynamic> json) => Faq(
        answer: json["Answer"],
        question: json["Question"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "Answer": answer,
        "Question": question,
        "id": id,
      };

  List<Faq> convertList(List<Map<Object, Object>> list) {
    return list
        .map((map) => Faq.fromJson(map.cast<String, dynamic>()))
        .toList();
  }
}
