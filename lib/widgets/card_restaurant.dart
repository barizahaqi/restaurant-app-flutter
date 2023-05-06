import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/ui/restaurant_detail_page.dart';

class CardRestaurant extends StatelessWidget {
  final Restaurant restaurant;
  final Color color;
  final Color textColor;

  const CardRestaurant(
      {super.key,
      required this.restaurant,
      required this.color,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Material(
        color: color,
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 8.0),
          leading: Hero(
            tag: restaurant.pictureId,
            child: Image.network(
              'https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}',
              width: 100,
            ),
          ),
          title: Text(
            restaurant.name,
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  color: textColor,
                ),
          ),
          subtitle: Container(
            margin: const EdgeInsets.only(
              top: 5.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const Icon(
                      Icons.location_on,
                      color: Colors.red,
                    ),
                    Text(restaurant.city,
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: Colors.grey,
                            )),
                  ],
                ),
                const SizedBox(height: 5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    Text(restaurant.rating.toString(),
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: Colors.grey,
                            )),
                  ],
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.pushNamed(context, RestaurantDetailPage.routeName,
                arguments: restaurant);
          },
        ));
  }
}
