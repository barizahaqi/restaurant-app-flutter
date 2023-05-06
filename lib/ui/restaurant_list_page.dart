import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:restaurant_app/utils/state_enum.dart';
import 'package:restaurant_app/ui/search_page.dart';
import 'package:restaurant_app/widgets/card_restaurant.dart';
import 'package:restaurant_app/widgets/platform_widget.dart';
import 'package:restaurant_app/provider/list_provider.dart';
import 'package:provider/provider.dart';

class RestaurantListPage extends StatelessWidget {
  const RestaurantListPage({super.key});

  Widget _buildList() {
    return Consumer<ListProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.state == ResultState.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.result.restaurants.length,
            itemBuilder: (context, index) {
              var restaurant = state.result.restaurants[index];
              return CardRestaurant(
                  restaurant: restaurant,
                  color: const Color(0xff1e1e1e),
                  textColor: Colors.white);
            },
          );
        } else if (state.state == ResultState.noData) {
          return Center(
            child: Text(
              state.message,
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: Colors.white,
                  ),
            ),
          );
        } else if (state.state == ResultState.error) {
          return Center(
            child: Text(
              state.message,
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: Colors.white,
                  ),
            ),
          );
        } else {
          return const Center(
            child: Material(
              child: Text(''),
            ),
          );
        }
      },
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant App'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchPage.routeName);
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: _buildList(),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
          middle: const Text('Restaurant App'),
          transitionBetweenRoutes: false,
          trailing: CupertinoButton(
            child: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, SearchPage.routeName);
            },
          )),
      child: _buildList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
