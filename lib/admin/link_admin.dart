import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extra_market/admin/home.dart';
import 'package:extra_market/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';

import 'offres.dart';
import 'services.dart';


class admin extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return admins();
  }

}
class admins extends State<admin>{
  var index_selected=1;
  List<Widget> pages=[
    offres(),
    home(),
    services(),

  ];


  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {


    return Scaffold(

      appBar: AppBar(
        leading:Image.asset("images/TT.png",width:100),
        actions: [
        IconButton(icon: Icon(Icons.exit_to_app_sharp,size: 30,), onPressed: () async{
        await FirebaseAuth.instance.signOut();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>login()));
        },)
        ],


      ),


      bottomNavigationBar: ConvexAppBar(
        initialActiveIndex: 1,

        backgroundColor: Colors.blue,
        onTap: (index){
          setState(() {
            index_selected=index;

          });
        },
        items: [
          TabItem(icon: Icon(Icons.add_shopping_cart) ,title: "GROS"),
          TabItem(icon: Icon(Icons.home_filled) ,title: "HOME"),
          TabItem(icon: Icon(Icons.home_repair_service) ,title: "DETAILLE"),
        ],),
      body:

      pages.elementAt(index_selected),



    );
  }

}
