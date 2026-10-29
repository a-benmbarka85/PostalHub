import 'package:flutter/material.dart';

import 'screens/search_screen.dart';
import 'styles/app_styles.dart';

void main() {
  runApp(const PostalHubApp());
}

class PostalHubApp extends StatelessWidget {
  const PostalHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PostalHub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppStyles.primary,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppStyles.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppStyles.primary,
          foregroundColor: Colors.white,
        ),
      ),
      home: const SearchScreen(),
    );
  }
}