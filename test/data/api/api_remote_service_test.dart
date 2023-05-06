import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/data/api/api_remote_service.dart';
import 'package:restaurant_app/data/model/list_restaurant.dart';
import 'package:restaurant_app/data/model/detail_restaurant.dart';
import 'package:restaurant_app/data/model/search_restaurant.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../json_reader.dart';
import 'api_remote_service_test.mocks.dart';

@GenerateMocks([
  ApiRemoteService,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {
  late MockHttpClient mockHttpClient;
  late ApiRemoteService apiRemoteService;

  setUp(() {
    mockHttpClient = MockHttpClient();
    apiRemoteService = ApiRemoteService(client: mockHttpClient);
  });

  group('get List Restaurant', () {
    final tListRestaurant = ListRestaurant.fromJson(
        json.decode(readJson('json_data/list_restaurant.json')));

    test('should return ListRestaurant when the call is successful', () async {
      when(mockHttpClient
              .get(Uri.parse('https://restaurant-api.dicoding.dev/list')))
          .thenAnswer((_) async =>
              http.Response(readJson('json_data/list_restaurant.json'), 200));

      final result = await apiRemoteService.getListRestaurant();

      expect(result, tListRestaurant);
    });
  });
  group('get List Restaurant', () {
    final tDetailRestaurant = DetailRestaurant.fromJson(
        json.decode(readJson('json_data/detail_restaurant.json')));

    test('should return DetailRestaurant when the call is successful',
        () async {
      when(mockHttpClient.get(Uri.parse(
              'https://restaurant-api.dicoding.dev/detail/rqdv5juczeskfw1e867')))
          .thenAnswer((_) async =>
              http.Response(readJson('json_data/detail_restaurant.json'), 200));

      final result =
          await apiRemoteService.getDetailRestaurant('rqdv5juczeskfw1e867');

      expect(result, tDetailRestaurant);
    });
  });
  group('get List Restaurant', () {
    final tSearchRestaurant = SearchRestaurant.fromJson(
        json.decode(readJson('json_data/search_restaurant.json')));

    test('should return SearchRestaurant when the call is successful',
        () async {
      when(mockHttpClient.get(Uri.parse(
              'https://restaurant-api.dicoding.dev/search?q=melting')))
          .thenAnswer((_) async =>
              http.Response(readJson('json_data/search_restaurant.json'), 200));

      final result = await apiRemoteService.searchRestaurant('melting');

      expect(result, tSearchRestaurant);
    });
  });
}
