import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/data/model/detail_restaurant.dart';
import 'package:restaurant_app/data/model/list_restaurant.dart';

import 'package:restaurant_app/data/model/search_restaurant.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ApiRemoteService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';

  final http.Client client;

  ApiRemoteService({required this.client});

  Future<void> checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
    } else {
      throw Exception('No Internet Connection');
    }
  }

  Future<ListRestaurant> getListRestaurant() async {
    final response = await client.get(Uri.parse('$_baseUrl/list'));
    if (response.statusCode == 200) {
      return ListRestaurant.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load List Restaurant');
    }
  }

  Future<DetailRestaurant> getDetailRestaurant(String id) async {
    final response = await client.get(Uri.parse('$_baseUrl/detail/$id'));
    if (response.statusCode == 200) {
      return DetailRestaurant.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Detail Restaurant');
    }
  }

  Future<SearchRestaurant> searchRestaurant(String query) async {
    final response = await client.get(Uri.parse('$_baseUrl/search?q=$query'));
    if (response.statusCode == 200) {
      return SearchRestaurant.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Search Restaurant');
    }
  }
}
