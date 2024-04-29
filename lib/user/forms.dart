import 'dart:ui';
import 'package:extra_market/admin/link_admin.dart';
import 'package:extra_market/user/fade_animation.dart';
import 'package:extra_market/user/link.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';



class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();

}

class _LoginFormState extends State<LoginForm> {
  GlobalKey <ScaffoldState> scaffoldkey=new GlobalKey <ScaffoldState>();
  bool _passwordVisible=true;

  List l=[] ;
  late bool check;
  num varia=0;
  TextEditingController email=  TextEditingController();
  TextEditingController pass=  TextEditingController();


  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

  }
  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    email.dispose();
    pass.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {


    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(top: 80),
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                child:Column(
                  children: <Widget>[
                    Image.asset('images/TT.png',width:180,),
                  ],)
            ),
            Container(
              child: const Text(
                "Bienvenue",
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Milonga'

                ),
              ),
            ),

            FadeAnimation(
              2,
              Container(
                  width: double.infinity,
                  height: 70,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 20),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.blueAccent, width: 1),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.blueAccent,
                            blurRadius: 10,
                            offset: Offset(1, 1)),
                      ],
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(
                          Radius.circular(20))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.mail,color:Colors.blueAccent ,),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: TextFormField(

                            controller: email,
                            textInputAction:TextInputAction.next,

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }else if (value.length < 8 || value.isEmpty) {
                                return 'invalid format number';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              hintText: "votre Mail",
                              counterStyle: TextStyle(height: double.minPositive),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),

            FadeAnimation(
              2,
              Container(
                  width: double.infinity,
                  height: 70,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 20),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.blueAccent, width: 1),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.blueAccent,
                            blurRadius: 10,
                            offset: Offset(1, 1)),
                      ],
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(
                          Radius.circular(20))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.lock_open_sharp,color:Colors.blueAccent ,),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: TextFormField(
                            controller: pass,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.done,
                            obscureText: _passwordVisible,
                            enableSuggestions: false,
                            autocorrect: false,
                            maxLines: 1,

                            decoration:  InputDecoration(
                              //---------------------------------
                              suffixIcon: IconButton(
                                  icon: Icon(
                                      _passwordVisible ? Icons.visibility : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  }),
                              //-----------------------------------------
                              hintText: "Mot de passe",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),

            const SizedBox(
              height: 20,
            ),

            FadeAnimation(
              2,
              ElevatedButton(
                onPressed: () async{

                  try {

                    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: "${email.text}",
                        password: "${pass.text}"
                    );
                    if(userCredential !=null && FirebaseAuth.instance.currentUser?.uid!="uCI2AA1JaJfJFPMt2gSIuYbN3hb2"){

                      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>link()));
                      Fluttertoast.showToast(
                          msg: "مرحبا بييك",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.indigoAccent,
                          textColor: Colors.white,
                          fontSize: 22.0
                      );
                    } else{
                      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>admin()));
                      Fluttertoast.showToast(
                          msg: "مرحبا بييك",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.indigoAccent,
                          textColor: Colors.white,
                          fontSize: 22.0
                      );
                    }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {

                      Fluttertoast.showToast(
                          msg: "ثبت في email لي كتبته",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.indigoAccent,
                          textColor: Colors.white,
                          fontSize: 22.0
                      );
                    } else if (e.code == 'wrong-password') {
                      Fluttertoast.showToast(
                          msg: " mot de pass غالط يهديك",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.indigoAccent,
                          textColor: Colors.white,
                          fontSize: 22.0
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                    onPrimary: Colors.purpleAccent,
                    shadowColor: Colors.purpleAccent,
                    elevation: 18,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                child: Ink(
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [
                        Colors.deepOrange,
                        Colors.lightBlue
                      ]),
                      borderRadius: BorderRadius.circular(20)),
                  child: Container(
                    width: 200,
                    height: 50,
                    alignment: Alignment.center,
                    child: const Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontFamily: 'Milonga'
                      ),
                    ),
                  ),
                ),
              ),
            ),


          ],



        ),
      ),
    );
  }

}