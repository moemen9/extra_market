import 'package:extra_market/user/Background.dart';
import 'package:extra_market/user/forms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class login extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return logint();
  }

}

class logint extends State<login>{
  @override
  Future<bool> Exit() async {
    return await showDialog( //show confirm dialogue
      //the return value will be from "Yes" or "No" options
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit App'),
        content: Text('Do you want to exit  ?'),
        actions:[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            //return false when click on "NO"
            child:Text('No'),
          ),

          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            //return true when click on "Yes"
            child:Text('Yes'),
          ),

        ],
      ),
    )??false; //if showDialouge had returned null, then return false
  }
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Exit,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BAYADHI STE',
        home: Scaffold(

          backgroundColor: Colors.deepOrange
          ,
          body: Stack(
            children: [

              Background(),
              const LoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}
