import 'package:flutter/cupertino.dart';
import 'package:restaurant_app/data/api/api_remote_service.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/utils/state_enum.dart';

class SearchProvider extends ChangeNotifier {
  final ApiRemoteService apiRemoteService;

  SearchProvider({required this.apiRemoteService});

  List<Restaurant> _searchRestaurant = [];
  ResultState _state = ResultState.noData;
  String _message = '';

  String get message => _message;

  List<Restaurant> get result => _searchRestaurant;

  ResultState get state => _state;

  Future<dynamic> fetchSearchRestaurant(String query) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      await apiRemoteService.checkConnection();
      final list = await apiRemoteService.searchRestaurant(query);
      if (list.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'No Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _searchRestaurant = list.restaurants;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = '$e';
    }
  }
}
