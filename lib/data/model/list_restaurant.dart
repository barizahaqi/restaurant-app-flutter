import 'package:equatable/equatable.dart';
import 'package:restaurant_app/data/model/restaurant.dart';

// ignore: must_be_immutable
class ListRestaurant extends Equatable {
  ListRestaurant({
    required this.error,
    required this.message,
    required this.count,
    required this.restaurants,
  });

  bool error;
  String message;
  int count;
  List<Restaurant> restaurants;

  factory ListRestaurant.fromJson(Map<String, dynamic> json) => ListRestaurant(
        error: json["error"],
        message: json["message"],
        count: json["count"],
        restaurants: List<Restaurant>.from(
            json["restaurants"].map((x) => Restaurant.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "count": count,
        "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => [error, message, count, restaurants];
}
