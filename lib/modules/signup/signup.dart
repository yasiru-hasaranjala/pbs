import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pbs/shared/components/components.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final ref = FirebaseDatabase.instance.ref('Users');

  final name = TextEditingController();

  final email = TextEditingController();

  final pass = TextEditingController();
  String password = '';
  bool isPasswordVisible = true;

  var formKey = GlobalKey<FormState>();
  String errorText = 'Can\'ot be empty';

  @override
  void initState() {
    super.initState();

    name.addListener(() => setState(() {}));
    email.addListener(() => setState(() {}));
  }
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'PBS',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              ' ',
              style: TextStyle(
                fontSize:27.0,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Sri Lanka',
              style: TextStyle(
                color: Colors.black45,
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          top: 50,
          bottom: 10,
          right: 20,
          left: 20,
        ),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const Text(
                'Sign up',
                style: TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              /*name*/ textField(
                controller: name,
                hinttext: 'Name',
                keyboardType: TextInputType.name,
                suffixIcon: name.text.isEmpty
                    ? Container(width: 0)
                    : IconButton(
                        icon: const Icon(Icons.close, size: 20.0, color: Colors.black),
                        onPressed: () => name.clear(),
                      ),
              ),
              const SizedBox(height: 15),
              /*email*/ textField(
                controller: email,
                hinttext: 'Email',
                keyboardType: TextInputType.emailAddress,
                suffixIcon: email.text.isEmpty
                    ? Container(width: 0)
                    : IconButton(
                        icon: const Icon(Icons.close, size: 20.0, color: Colors.black),
                        onPressed: () => email.clear(),
                      ),
              ),
              const SizedBox(height: 15),
              /*password*/ textField(
                keyboardType: TextInputType.emailAddress,
                controller: pass,
                hinttext: 'Password',
                isPassword: true,
                suffixIcon: pass.text.isEmpty
                    ? Container(width: 0)
                    : IconButton(
                        icon: isPasswordVisible
                            ? const Icon(Icons.visibility_off, size: 20.0, color: Colors.black)
                            : const Icon(Icons.visibility, size: 20.0, color: Colors.black),
                        onPressed: () => setState(
                          () => isPasswordVisible = !isPasswordVisible,
                        ),
                      ),
                onChange: (value) => setState(() => password = value),
                isPasswordVisible: isPasswordVisible,
              ),
              const SizedBox(height: 25),
              /*sign up*/ commonButton(
                text: 'Create',
                function: () async {
                  if (formKey.currentState!.validate()) {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final newUser = await _auth.createUserWithEmailAndPassword(
                          email: email.text, password: password);
                      if (newUser != null) {
                        final uid = newUser.user?.uid.toString();
                        await ref.set({
                          "$uid": {
                            "Name": name.text,
                            "Subscription": 0,
                            "Review": "",
                          }
                        });
                        Navigator.pushNamed(context, 'menu_screen');
                      }
                    } catch (e) {
                      if (kDebugMode) {
                        print(e);
                      }
                    }
                    setState(() {
                      showSpinner = false;
                    });
                  }
                },
                fontsize: 25.0,
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  const Text('Or create an account using social media'),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      iconSocialmedia(
                        url:
                            'https://www.freepnglogos.com/uploads/google-plus-png-logo/plus-original-google-solid-google-world-brand-png-logo-21.png',
                      ),
                      iconSocialmedia(
                        url:
                            'https://icon-library.com/images/facebook-icon-black/facebook-icon-black-12.jpg',
                      ),
                      iconSocialmedia(
                        size: 30.0,
                        url: 'https://cdn-icons-png.flaticon.com/512/6422/6422210.png',
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
