import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/pages/endbuypage.dart';
import 'pages/indexpage.dart';
import 'pages/loginpage.dart';
import 'pages/registerpage.dart';
import 'pages/homepage.dart';
import 'secure_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      initialRoute: '/',
      routes: {
        '/': (context) => FutureBuilder(
              future: _checkLoginStatus(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return snapshot.data == true ? HomePage() : IndexPage();
                } else {
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: bgColor,
                  );
                }
              },
            ),
        '/index': (context) => const IndexPage(),
        '/login': (context) => const LoginPage(),
        '/cadastro': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/endbuy': (context) => const EndBuyPage(),
      },
    );
  }

  Future<bool> _checkLoginStatus() async {
    String? token = await SecureStorage().readSecureData('authToken');
    // ignore: unnecessary_null_comparison
    return token != null;
  }
}
