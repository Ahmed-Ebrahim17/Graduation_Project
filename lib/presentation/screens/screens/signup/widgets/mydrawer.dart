import 'package:flutter/material.dart';

import '../../login/login.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    super.key,
  });
  void logOut() async {}

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                child: Center(
                  child: Icon(
                    Icons.message,
                    size: 60,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: ListTile(
                  title: const Text('HOME'),
                  leading: const Icon(
                    Icons.home,
                  ),
                  onTap: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: ListTile(
                  title: const Text('SETTINGS'),
                  leading: const Icon(
                    Icons.settings,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 20),
            child: ListTile(
              title: const Text('LOGOUT'),
              leading: const Icon(
                Icons.home,
              ),
              onTap: logOut,
            ),
          ),
        ],
      ),
    );
  }
}
