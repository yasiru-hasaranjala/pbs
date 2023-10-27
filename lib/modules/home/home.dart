import 'package:flutter/material.dart';
import 'package:pbs/modules/login/login.dart';
import 'package:pbs/modules/signup/Signup.dart';
import 'package:pbs/shared/components/components.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(
                height: 60,
              ),
              const Text(
                'Welcome to the,',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Text(
                'PBS Sri Lanka',
                style: TextStyle(
                  fontSize: 33.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Image.asset('assets/logo.png', scale: 1.0),
              Container(
                alignment: Alignment.center,
                child: const Text(
                  'It\'s Time to Ride with PBS',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              commonButton(
                text: 'Log In',
                function: () {
                  Navigator.pushNamed(context, 'login_screen');
                },
                color: Colors.white,
                textcolor: Colors.black,
                fontsize: 40.0,
                border: 3.0,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(
                height: 20,
              ),
              commonButton(
                text: 'Sign Up',
                function: () {
                  Navigator.pushNamed(context, 'registration_screen');
                },
                fontsize: 40.0,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
