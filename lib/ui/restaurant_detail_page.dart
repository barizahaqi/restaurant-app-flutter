import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/favorite_provider.dart';
import 'package:restaurant_app/utils/state_enum.dart';
import 'package:restaurant_app/data/model/detail_restaurant.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/provider/detail_provider.dart';
import 'package:restaurant_app/widgets/platform_widget.dart';

class RestaurantDetailPage extends StatefulWidget {
  const RestaurantDetailPage({super.key, required this.restaurant});

  static const routeName = '/restaurant_detail';

  final Restaurant restaurant;

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<DetailProvider>(context, listen: false)
          .fetchDetailRestaurant(widget.restaurant.id);
      Provider.of<DetailProvider>(context, listen: false)
          .loadFavoriteStatus(widget.restaurant.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurant.name),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.restaurant.name),
        transitionBetweenRoutes: false,
      ),
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Consumer<DetailProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.state == ResultState.hasData) {
          final dataRestaurant = state.result;
          return DetailContent(
              restaurant: widget.restaurant,
              dataRestaurant: dataRestaurant,
              isAddedFavorite: state.isAddedtoFavorite);
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
}

class DetailContent extends StatelessWidget {
  final Restaurant restaurant;
  final DetailRestaurant dataRestaurant;
  final bool isAddedFavorite;

  const DetailContent({
    super.key,
    required this.restaurant,
    required this.dataRestaurant,
    required this.isAddedFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Column(children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            Hero(
                tag: dataRestaurant.restaurant.pictureId,
                child: Image.network(
                    'https://restaurant-api.dicoding.dev/images/medium/${dataRestaurant.restaurant.pictureId}')),
            Padding(
              padding: const EdgeInsets.all(10),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: Icon(
                    isAddedFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  onPressed: () async {
                    if (!isAddedFavorite) {
                      await Provider.of<DetailProvider>(context, listen: false)
                          .addFavoriteRestaurant(restaurant);
                    } else {
                      await Provider.of<DetailProvider>(context, listen: false)
                          .removeFavoriteRestaurant(restaurant);
                    }
                    // ignore: use_build_context_synchronously
                    await Provider.of<FavoriteProvider>(context, listen: false)
                        .fetchFavoriteRestaurant();
                    final message =
                        // ignore: use_build_context_synchronously
                        Provider.of<DetailProvider>(context, listen: false)
                            .favoriteMessage;
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(message)));
                  },
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dataRestaurant.restaurant.name,
                style: Theme.of(context).textTheme.headline4!.copyWith(
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Icon(
                    Icons.location_on,
                    color: Colors.red,
                  ),
                  Text(dataRestaurant.restaurant.city,
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Colors.grey,
                          )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Icon(
                    Icons.star,
                    color: Colors.yellow,
                  ),
                  Text(dataRestaurant.restaurant.rating.toString(),
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Colors.grey,
                          )),
                ],
              ),
              const Divider(color: Colors.grey),
              Text('Description',
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Colors.white,
                      )),
              const SizedBox(height: 10),
              Text(
                dataRestaurant.restaurant.description,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: Colors.white,
                    ),
              ),
              const Divider(color: Colors.grey),
              Text('Menus',
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Colors.white,
                      )),
              const SizedBox(height: 10),
              Text('Foods: ',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Colors.white,
                      )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (screenWidth <= 480) ...[
                    for (var i = 0;
                        i < dataRestaurant.restaurant.menus.foods.length;
                        i++)
                      Row(
                        children: [
                          _menuItem(context,
                              dataRestaurant.restaurant.menus.foods[i].name),
                        ],
                      ),
                  ] else ...[
                    for (var i = 0;
                        i < dataRestaurant.restaurant.menus.foods.length;
                        i += 2)
                      Row(children: [
                        _menuItem(context,
                            dataRestaurant.restaurant.menus.foods[i].name),
                        if (i + 1 <
                            dataRestaurant.restaurant.menus.foods.length)
                          _menuItem(
                              context,
                              dataRestaurant
                                  .restaurant.menus.foods[i + 1].name),
                      ]),
                  ],
                ],
              ),
              const SizedBox(height: 10),
              Text('Drinks: ',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Colors.white,
                      )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (screenWidth <= 480) ...[
                    for (var i = 0;
                        i < dataRestaurant.restaurant.menus.drinks.length;
                        i += 2)
                      Row(children: [
                        _menuItem(context,
                            dataRestaurant.restaurant.menus.drinks[i].name),
                        if (i + 1 <
                            dataRestaurant.restaurant.menus.drinks.length)
                          _menuItem(
                              context,
                              dataRestaurant
                                  .restaurant.menus.drinks[i + 1].name),
                      ]),
                  ] else ...[
                    for (var i = 0;
                        i < dataRestaurant.restaurant.menus.drinks.length;
                        i += 3)
                      Row(
                        children: [
                          _menuItem(context,
                              dataRestaurant.restaurant.menus.drinks[i].name),
                          if (i + 1 <
                              dataRestaurant.restaurant.menus.drinks.length)
                            _menuItem(
                                context,
                                dataRestaurant
                                    .restaurant.menus.drinks[i + 1].name),
                          if (i + 2 <
                              dataRestaurant.restaurant.menus.drinks.length)
                            _menuItem(
                                context,
                                dataRestaurant
                                    .restaurant.menus.drinks[i + 2].name),
                        ],
                      ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _menuItem(BuildContext context, String item) {
    return Container(
      margin: const EdgeInsets.only(left: 10, top: 2),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        item,
        style: Theme.of(context).textTheme.bodyText2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
