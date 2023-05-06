import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Restaurant extends Equatable {
  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  String id;
  String name;
  String description;
  String pictureId;
  String city;
  double rating;

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        pictureId: json["pictureId"],
        city: json["city"],
        rating: json["rating"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "pictureId": pictureId,
        "city": city,
        "rating": rating,
      };

  factory Restaurant.fromMap(Map<String, dynamic> map) => Restaurant(
        id: map['id'],
        name: map['name'],
        description: map['description'],
        pictureId: map['pictureId'],
        city: map['city'],
        rating: map['rating']?.toDouble(),
      );

  @override
  List<Object?> get props => [id, name, description, pictureId, city, rating];
}
