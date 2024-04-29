import 'dart:async';
import 'package:extra_market/admin/link_admin.dart';
import 'package:extra_market/user/link.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login.dart';

late bool islogin;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var user=FirebaseAuth.instance.currentUser;

  if(user == null){
    islogin=false;
  }else{
  islogin=true;
  }
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: new MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var mail=FirebaseAuth.instance.currentUser?.uid=="uCI2AA1JaJfJFPMt2gSIuYbN3hb2";
  @override
  void initState() {
    super.initState();
    islogin ==true?
        mail==true?
        new Future.delayed(
            const Duration(seconds: 0),
                () =>
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>admin()))

        ):
        new Future.delayed(
            const Duration(seconds: 0),
                () =>
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>link()))

        )

    :
    new Future.delayed(
        const Duration(seconds: 4),
            () =>
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>login())
        ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: new Column(children: <Widget>[
          SizedBox(height: 200,),
          new Image.asset(
            'images/tt.gif',
            fit: BoxFit.cover,
            repeat: ImageRepeat.noRepeat,
            width: double.infinity,

          ),

        ]),
      ),
    );
  }
}