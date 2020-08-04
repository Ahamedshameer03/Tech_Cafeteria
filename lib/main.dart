import 'package:cafeteria/components/loading.dart';
import 'package:cafeteria/screens/Admin_side/admin_home.dart';
import 'package:cafeteria/screens/home_page.dart';
import 'package:cafeteria/screens/menu_frame.dart';
import 'package:cafeteria/screens/splash_page.dart';
import 'package:cafeteria/services/Provider/app_provider.dart';
import 'package:cafeteria/services/Provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: UserProvider.initialize()),
        ChangeNotifierProvider.value(value: AppProvider())
      ],
      child: MaterialApp(
        title: 'Cafeteria',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.from(colorScheme: ColorScheme.light()),
        //darkTheme: ThemeData.from(colorScheme: ColorScheme.dark()),
        home: SplashScreen(),
        //home: Home(),
      ),
    );
  }
}

class ScreensController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    switch (user.status) {
      case Status.Admin:
        return AdminHome();
      case Status.Uninitialized:
      //return SplashScreen();
      case Status.Unauthenticated:
        return MenuFrame();
      case Status.Authenticating:
        return Loading();
      case Status.Authenticated:
        return Home();
      default:
        return MenuFrame();
    }
  }
}
