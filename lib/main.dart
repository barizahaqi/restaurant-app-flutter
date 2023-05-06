import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/navigation.dart';
import 'package:restaurant_app/common/styles.dart';
import 'package:restaurant_app/data/api/api_local_service.dart';
import 'package:restaurant_app/data/api/api_remote_service.dart';
import 'package:restaurant_app/data/db/database_helper.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/provider/detail_provider.dart';
import 'package:restaurant_app/provider/favorite_provider.dart';
import 'package:restaurant_app/provider/list_provider.dart';
import 'package:restaurant_app/provider/scheduling_provider.dart';
import 'package:restaurant_app/provider/search_provider.dart';
import 'package:restaurant_app/ui/home_page.dart';
import 'package:restaurant_app/ui/restaurant_detail_page.dart';
import 'package:restaurant_app/ui/search_page.dart';
import 'package:restaurant_app/ui/splash_screen.dart';
import 'package:restaurant_app/utils/background_service.dart';
import 'package:restaurant_app/utils/notification_helper.dart';
import 'package:http/http.dart' as http;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper notificationHelper = NotificationHelper();
  final BackgroundService service = BackgroundService();

  service.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }

  await notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (_) => ListProvider(
                  apiRemoteService: ApiRemoteService(client: http.Client()))),
          ChangeNotifierProvider(
              create: (_) => FavoriteProvider(
                  apiLocalService:
                      ApiLocalService(databaseHelper: DatabaseHelper()))),
          ChangeNotifierProvider(
              create: (_) => SearchProvider(
                  apiRemoteService: ApiRemoteService(client: http.Client()))),
          ChangeNotifierProvider(
              create: (_) => DetailProvider(
                  apiRemoteService: ApiRemoteService(client: http.Client()),
                  apiLocalService:
                      ApiLocalService(databaseHelper: DatabaseHelper()))),
          ChangeNotifierProvider<SchedulingProvider>(
            create: (_) => SchedulingProvider(),
          ),
        ],
        child: MaterialApp(
          title: 'Restaurant App',
          theme: ThemeData(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: primaryColor,
                  onPrimary: Colors.white,
                  secondary: secondaryColor,
                ),
            scaffoldBackgroundColor: Colors.black,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textTheme: myTextTheme,
            cupertinoOverrideTheme: const CupertinoThemeData(
              brightness: Brightness.dark,
            ),
            appBarTheme: const AppBarTheme(elevation: 0),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColor,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(0),
                  ),
                ),
              ),
            ),
          ),
          navigatorKey: navigatorKey,
          initialRoute: SplashScreen.routeName,
          routes: {
            SplashScreen.routeName: (context) => const SplashScreen(),
            HomePage.routeName: (context) => const HomePage(),
            RestaurantDetailPage.routeName: (context) => RestaurantDetailPage(
                  restaurant:
                      ModalRoute.of(context)?.settings.arguments as Restaurant,
                ),
            SearchPage.routeName: (context) => const SearchPage(),
          },
        ));
  }
}
