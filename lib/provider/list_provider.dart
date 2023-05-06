import 'package:flutter/cupertino.dart';
import 'package:restaurant_app/data/api/api_remote_service.dart';
import 'package:restaurant_app/data/model/list_restaurant.dart';
import 'package:restaurant_app/utils/state_enum.dart';

class ListProvider extends ChangeNotifier {
  final ApiRemoteService apiRemoteService;

  ListProvider({required this.apiRemoteService}) {
    fetchListRestaurant();
  }

  late ListRestaurant _listRestaurant;
  late ResultState _state;
  String _message = '';

  String get message => _message;

  ListRestaurant get result => _listRestaurant;

  ResultState get state => _state;

  Future<dynamic> fetchListRestaurant() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      await apiRemoteService.checkConnection();
      final list = await apiRemoteService.getListRestaurant();
      if (list.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'No Data';
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
