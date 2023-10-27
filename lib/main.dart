import 'package:flutter/material.dart';
import 'package:pbs/modules/home/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pbs/modules/login/login.dart';
import 'package:pbs/modules/map/map.dart';
import 'package:pbs/modules/menu/qr.dart';
import 'package:pbs/modules/signup/signup.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'modules/menu/menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey:'AIzaSyBRfDgsmg879j00Y3vdg2opqczEO7TT5K4',
          appId:'1:590647446037:android:13c9a72b1f1b9edff45c1c',
          messagingSenderId:'590647446037',
          projectId:'pbssystem-8e742'
      )
  );

  Stripe.publishableKey = "pk_test_51O5tykFFFOqljVv9BUxhAhv0ch2a4YwR5HtmKeSkoTT8BWzTZ9vblcGAL71TL0yTUbXLGyok3ng5h10QBZdVV82Y00LJisNQdY";
  await dotenv.load(fileName: "assets/.env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter App',
      theme: ThemeData(),
      initialRoute: 'welcome_screen',
      routes: {
        'welcome_screen': (context) => const HomeScreen(),
        'registration_screen': (context) => const SignUpScreen(),
        'login_screen': (context) => const LoginScreen(),
        'map_screen': (context) => const Map(),
        'menu_screen': (context) => const Menu(),
        'qr_screen': (context) => const QRViewExample()
      },
    );
  }
}
