import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/utils/state_enum.dart';
import 'package:restaurant_app/common/styles.dart';
import 'package:restaurant_app/provider/search_provider.dart';
import 'package:restaurant_app/widgets/card_restaurant.dart';

class SearchPage extends StatelessWidget {
  static const routeName = '/search';

  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) {
                Provider.of<SearchProvider>(context, listen: false)
                    .fetchSearchRestaurant(query);
              },
              decoration: const InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                ),
              ),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),
            const Text(
              'Search Result',
            ),
            Consumer<SearchProvider>(
              builder: (context, data, _) {
                if (data.state == ResultState.loading) {
                  return const Expanded(
                      child: Center(
                    child: CircularProgressIndicator(),
                  ));
                } else if (data.state == ResultState.hasData) {
                  final result = data.result;
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        final restaurant = data.result[index];
                        return CardRestaurant(
                            restaurant: restaurant,
                            color: Colors.white,
                            textColor: Colors.black);
                      },
                      itemCount: result.length,
                    ),
                  );
                } else if (data.state == ResultState.error) {
                  return Expanded(
                      child: Center(
                    child: Text(
                      data.message,
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                            color: Colors.black,
                          ),
                    ),
                  ));
                } else {
                  return Expanded(
                      child: Center(
                    child: Text(
                      data.message,
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                            color: Colors.black,
                          ),
                    ),
                  ));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
