import 'package:cafeteria/screens/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:cafeteria/screens/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cafeteria',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.from(colorScheme: ColorScheme.light()),
      darkTheme: ThemeData.from(colorScheme: ColorScheme.dark()),
      home: SplashScreen(),
      //home: Home(),
    );
  }
}
