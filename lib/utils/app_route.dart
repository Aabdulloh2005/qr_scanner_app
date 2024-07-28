import 'package:flutter/cupertino.dart';
import 'package:qr_scanner/views/screens/generate/generate_screen.dart';
import 'package:qr_scanner/views/screens/generate/result_screen.dart';
import 'package:qr_scanner/views/screens/history/history_screen.dart';
import 'package:qr_scanner/views/screens/homepage.dart';
import 'package:qr_scanner/views/screens/splash/onboarding_screen.dart';
import 'package:qr_scanner/views/screens/splash/splash_screen.dart';

class AppRoute {
  static const String splashScreen = '/splashScreen';
  static const String onboardingScreen = '/onboardingScreen';
  static const String homeScreen = '/homeScreen';
  static const String generateScreen = '/generateScreen';
  static const String historyScreen = '/historyScreen';
  static const String resultScreen = '/resultScreen';

  static PageRoute _buildPageRoute(Widget widget) =>
      CupertinoPageRoute(builder: (context) => widget);

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoute.splashScreen:
        return _buildPageRoute(const SplashScreen());
      case AppRoute.onboardingScreen:
        return _buildPageRoute(const OnboardingScreen());
      case AppRoute.homeScreen:
        return _buildPageRoute(const Homepage());
      case AppRoute.generateScreen:
        final data = settings.arguments as Map<String, dynamic>;
        return _buildPageRoute(
          GenerateScreen(
            icon: data['icon'],
            label: data['label'],
            baseUrl: data['baseUrl'],
          ),
        );
      case AppRoute.historyScreen:
        return _buildPageRoute(const HistoryScreen());
      case AppRoute.resultScreen:
        final url = settings.arguments as String;
        return _buildPageRoute(ResultScreen(
          result: url,
        ));
      default:
        return _buildPageRoute(const Homepage());
    }
  }
}
