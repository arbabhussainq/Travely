import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/search_provider.dart';
import '../providers/favorites_provider.dart';
import '../services/auth_service.dart';
import '../ui/pages/splash_page.dart';
import 'theme.dart';

class TravelyApp extends StatelessWidget {
  const TravelyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Travely',
        theme: TravelyTheme.light,
        home: const SplashPage(),
      ),
    );
  }
}
