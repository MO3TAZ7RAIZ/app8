import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'home_screen.dart';
// import 'splash_screen.dart';
import 'profile_edit_screen.dart';  // Add this import

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,  // Add this line
      title: 'Flutter Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(authService: authService),
        '/signup': (context) => SignupScreen(authService: authService),
        
        '/home': (context) {
          final username = ModalRoute.of(context)!.settings.arguments as String;
          return HomeScreen(
            authService: authService,
            username: username,
          );
        },
        '/edit-profile': (context) {
          final username = ModalRoute.of(context)!.settings.arguments as String;
          return ProfileEditScreen(
            authService: authService,
            username: username,
          );
        },
      },
    );
  }
}