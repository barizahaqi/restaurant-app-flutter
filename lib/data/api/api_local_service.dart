import 'package:restaurant_app/data/db/database_helper.dart';
import 'package:restaurant_app/data/model/restaurant.dart';

class ApiLocalService {
  final DatabaseHelper databaseHelper;

  ApiLocalService({required this.databaseHelper});

  Future<bool> insertRestaurant(Restaurant restaurant) async {
    try {
      await databaseHelper.insertRestaurant(restaurant);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeRestaurant(Restaurant restaurant) async {
    try {
      await databaseHelper.removeRestaurant(restaurant);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Restaurant>> getListFavoriteRestaurant() async {
    final result = await databaseHelper.getListRestaurant();
    return result.map((data) => Restaurant.fromMap(data)).toList();
  }

  Future<bool> isFavorite(String id) async {
    final result = await databaseHelper.getRestaurantById(id);
    return result != null;
  }
}
