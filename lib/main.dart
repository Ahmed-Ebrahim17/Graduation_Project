import 'package:easy_summary/presentation/screens/screens/homePage/home_page.dart';
import 'package:easy_summary/presentation/screens/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'presentation/screens/screens/onBoarding/onboarding_screen.dart';
import 'utils/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('auth_token');
  bool isFirstLaunch = prefs.getBool('first_launch') ?? true;

  runApp(App(
    isLoggedIn: token != null && token.isNotEmpty,
    isFirstLaunch: isFirstLaunch,
  ));
}

class App extends StatelessWidget {
  final bool isLoggedIn;
  final bool isFirstLaunch;

  const App({
    super.key,
    required this.isLoggedIn,
    required this.isFirstLaunch,
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      home: _getInitialScreen(),
    );
  }

  Widget _getInitialScreen() {
    if (isFirstLaunch) {
      // Set first_launch to false for next time
      SharedPreferences.getInstance().then(
        (prefs) => prefs.setBool('first_launch', false),
      );
      return const OnboardingScreen();
    }

    if (isLoggedIn) {
      return const HomePage();
    }

    return const LoginScreen();
  }
}

// Optional: Method to reset onboarding (useful for testing)
Future<void> resetOnboarding() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('first_launch', true);
}
