import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

  void initState() {
    super.initState();
    getCurrentUser();
  }

  //using this function you can use the credentials of the user
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedinUser = user;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  child: Image.asset('assets/logo.png', scale: 1.0),
                ),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    ),
                    onPressed: () {},
                    child: const Text("Subscribe", style: TextStyle(fontSize: 25,)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, 'qr_screen');
                    },
                    child: const Text("QR Scan", style: TextStyle(fontSize: 25,)),
                  ),
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
                onPressed: () {
                  //valueText
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }
}
