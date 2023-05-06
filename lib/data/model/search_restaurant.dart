import 'package:equatable/equatable.dart';
import 'package:restaurant_app/data/model/restaurant.dart';

// ignore: must_be_immutable
class SearchRestaurant extends Equatable {
  SearchRestaurant({
    required this.error,
    required this.founded,
    required this.restaurants,
  });

  bool error;
  int founded;
  List<Restaurant> restaurants;

  factory SearchRestaurant.fromJson(Map<String, dynamic> json) =>
      SearchRestaurant(
        error: json["error"],
        founded: json["founded"],
        restaurants: List<Restaurant>.from(
            json["restaurants"].map((x) => Restaurant.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "founded": founded,
        "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => [error, founded, restaurants];
}
