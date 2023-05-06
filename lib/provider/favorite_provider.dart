import 'package:flutter/cupertino.dart';
import 'package:restaurant_app/data/api/api_local_service.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/utils/state_enum.dart';

class FavoriteProvider extends ChangeNotifier {
  final ApiLocalService apiLocalService;

  FavoriteProvider({required this.apiLocalService}) {
    fetchFavoriteRestaurant();
  }

  late List<Restaurant> _listRestaurant;
  late ResultState _state;
  String _message = '';

  String get message => _message;

  List<Restaurant> get result => _listRestaurant;

  ResultState get state => _state;

  Future<dynamic> fetchFavoriteRestaurant() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final list = await apiLocalService.getListFavoriteRestaurant();
      if (list.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'You have no favorite restaurant';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _listRestaurant = list;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = '$e';
    }
  }
}
