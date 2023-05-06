import 'package:flutter/cupertino.dart';
import 'package:restaurant_app/data/api/api_remote_service.dart';
import 'package:restaurant_app/data/api/api_local_service.dart';
import 'package:restaurant_app/data/model/detail_restaurant.dart';
import 'package:restaurant_app/utils/state_enum.dart';
import 'package:restaurant_app/data/model/restaurant.dart';

class DetailProvider extends ChangeNotifier {
  final ApiRemoteService apiRemoteService;
  final ApiLocalService apiLocalService;

  DetailProvider(
      {required this.apiRemoteService, required this.apiLocalService});

  late DetailRestaurant _detailRestaurant;
  ResultState _state = ResultState.noData;
  String _message = '';

  String get message => _message;

  bool _isAddedtoFavorite = false;
  bool get isAddedtoFavorite => _isAddedtoFavorite;

  String _favoriteMessage = '';
  String get favoriteMessage => _favoriteMessage;

  DetailRestaurant get result => _detailRestaurant;

  ResultState get state => _state;

  Future<dynamic> fetchDetailRestaurant(String id) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      await apiRemoteService.checkConnection();
      final detail = await apiRemoteService.getDetailRestaurant(id);
      // ignore: unnecessary_null_comparison
      if (detail.restaurant == null) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'No Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _detailRestaurant = detail;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = '$e';
    }
  }

  Future<dynamic> addFavoriteRestaurant(Restaurant restaurant) async {
    final result = await apiLocalService.insertRestaurant(restaurant);
    if (result) {
      _favoriteMessage = 'Added to Favorite';
    } else {
      _favoriteMessage = 'Failed to add to Favorite';
    }

    await loadFavoriteStatus(restaurant.id);
  }

  Future<dynamic> removeFavoriteRestaurant(Restaurant restaurant) async {
    final result = await apiLocalService.removeRestaurant(restaurant);
    if (result) {
      _favoriteMessage = 'Removed from Favorite';
    } else {
      _favoriteMessage = 'Failed to remove from Favorite';
    }

    await loadFavoriteStatus(restaurant.id);
  }

  Future<void> loadFavoriteStatus(String id) async {
    final result = await apiLocalService.isFavorite(id);
    _isAddedtoFavorite = result;
    notifyListeners();
  }
}
