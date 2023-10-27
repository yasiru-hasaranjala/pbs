import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'dart:developer';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final TextEditingController _textFieldController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref();
  late User loggedinUser;
  late String uid;
  Map<String, dynamic>? paymentIntent;


  void initState() {
    super.initState();
    getCurrentUser();
  }

  //using this function you can use the credentials of the user
  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedinUser = user;
        uid = loggedinUser.uid.toString();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {return false;},
      child: Scaffold(
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
                  'PBS Sri Lanka',
                  style: TextStyle(
                    fontSize: 33.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Image.asset('assets/logo.png', scale: 1.1),
                ),
                Center(
                  child: StreamBuilder(
                      stream: ref.child('Users').onValue,
                      builder: (context, snap) {
                        if (snap.hasError) {
                          return const Text('Something went wrong');
                        }
                        if (snap.connectionState == ConnectionState.waiting) {
                          return const Text("Loading");
                        }
                        String subs = snap.data!.snapshot.child("$uid").child("Subscription").value.toString();
                      return subs == "1"
                          ? const Column(
                            children: [
                              Text("You have",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                )
                              ),
                              Text("Already Subscribed",
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                )
                              ),
                            ],
                          )
                          : Column(
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.red,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                                  ),
                                  onPressed: () async {
                                    await makePayment();
                                  },
                                  child: const Text("Subscribe", style: TextStyle(fontSize: 25,)),
                              ),
                              const Text("To enable below features",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold,
                                  )
                              ),
                            ],
                          );
                    }
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                StreamBuilder(
                  stream: ref.child("Users").onValue,
                  builder: (context, snap) {
                    if (snap.hasError) {
                    return const Text('Something went wrong');
                    }
                    if (snap.connectionState == ConnectionState.waiting) {
                    return const Text("Loading");
                    }

                    String subs = snap.data!.snapshot.child("$uid").child("Subscription").value.toString();
                    return Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: subs=="0" ? Colors.black54 : Colors.blue,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        ),
                        onPressed: () {
                          if(subs == "1") {
                            Navigator.pushNamed(context, 'qr_screen');
                          }
                        },
                        child: const Text("QR Scan", style: TextStyle(fontSize: 25,)),
                      ),
                    );
                  }
                ),
                const SizedBox(
                  height: 20,
                ),
                StreamBuilder(
                  stream: ref.child('Location').onValue,
                  builder: (context, snap) {
                    if (snap.hasError) {
                      return const Text('Something went wrong');
                    }
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Text("Loading");
                    }

                    String lock = snap.data!.snapshot.child("lock").value.toString();

                    return Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: lock!="0" ? Colors.black54 : Colors.green,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        ),
                        onPressed: () {
                          if(lock == "0") {
                            Navigator.pushNamed(context, 'map_screen');
                          }
                        },
                        child: const Text("Live Location", style: TextStyle(fontSize: 25,)),
                      ),
                    );
                  }
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.amber,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        ),
                        onPressed: () {
                          _displayTextInputDialog(context);
                        },
                        child: const Text("Review", style: TextStyle(fontSize: 25,)),
                      ),
                    ),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.indigo,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        ),
                        onPressed: () {
                          _auth.signOut();
                          Navigator.pop(context);
                        },
                        child: const Text("Log out", style: TextStyle(fontSize: 25,)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    String? valueText;
    return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Enter your review'),
        content: TextField(
          onChanged: (value) {
            setState(() {
              valueText = value;
            });
          },
          controller: _textFieldController,
          decoration:
          const InputDecoration(hintText: "Text"),
        ),
        actions: <Widget>[
          MaterialButton(
            color: Colors.red,
            textColor: Colors.white,
            child: const Text('Cancel'),
            onPressed: () {
              setState(() {
                Navigator.pop(context);
              });
            },
          ),
          MaterialButton(
            color: Colors.green,
            textColor: Colors.white,
            child: const Text('Submit'),
            onPressed: () async {
              final uid = loggedinUser.uid.toString();
              await ref.child("Users/$uid/Review").set("$valueText");
              setState(() {
                Navigator.pop(context);
              });
            },
          ),
        ],
      );
    });
  }

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent('1', 'USD');

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent![
              'client_secret'], //Gotten from payment intent
              style: ThemeMode.dark,
              merchantDisplayName: 'Ikay'))
          .then((value) {});

      //STEP 3: Display Payment sheet
      await ref.child("Users/$uid/Subscription").set(1);
      displayPaymentSheet();
    } catch (err) {
      throw Exception(err);
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        showDialog(
            context: context,
            builder: (_) => const AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 100.0,
                  ),
                  SizedBox(height: 10.0),
                  Text("Subscribe Successful!"),
                ],
              ),
            ));

        paymentIntent = null;
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                Text("Payment Failed"),
              ],
            ),
          ],
        ),
      );
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }
}
