import 'dart:io';

import 'package:provider/provider.dart';
import 'package:restaurant_app/common/navigation.dart';
import 'package:restaurant_app/widgets/platform_widget.dart';
import 'package:restaurant_app/provider/scheduling_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool switchSchedule = false;

  void saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('switchSchedule', switchSchedule);
  }

  void loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      switchSchedule = prefs.getBool('switchSchedule') ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: _buildList(context),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Settings'),
      ),
      backgroundColor: Colors.white,
      child: _buildList(context),
    );
  }

  Widget _buildList(BuildContext context) {
    return ListView(
      children: [
        Material(
          child: ListTile(
            title: const Text('Scheduling Restaurant'),
            trailing: Consumer<SchedulingProvider>(
              builder: (context, scheduled, _) {
                return Switch.adaptive(
                  value: switchSchedule,
                  onChanged: (value) async {
                    setState(() {
                      switchSchedule = value;
                      saveSettings();
                    });
                    if (Platform.isIOS) {
                      showCupertinoDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            title: const Text('Coming Soon!'),
                            content:
                                const Text('This feature will be coming soon!'),
                            actions: [
                              CupertinoDialogAction(
                                child: const Text('Ok'),
                                onPressed: () {
                                  Navigation.back();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      scheduled.scheduledRestaurant(value);
                    }
                  },
                );
              },
            ),
          ),
        ),
      ],
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
