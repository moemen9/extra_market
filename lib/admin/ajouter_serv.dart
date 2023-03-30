import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ajout_serv extends StatefulWidget {



  @override
  State<ajout_serv> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ajout_serv> {


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    TextEditingController nom = TextEditingController();
    TextEditingController prix = TextEditingController();
    TextEditingController stock = TextEditingController();


    return Scaffold(
      appBar: AppBar(

      ),
      body:
      SingleChildScrollView(
        child: Column(
          children: [


            Padding(
              padding: const EdgeInsets.all(30.0),
              child: TextFormField(
                controller: nom,
                textInputAction:TextInputAction.next,
                decoration:InputDecoration(
                    label: Text(" nom "),

                    border: OutlineInputBorder(),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 5))
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(30.0),
              child: TextFormField(
                keyboardType:TextInputType.number,
                textInputAction:TextInputAction.next,
                controller: prix,
                decoration:InputDecoration(
                    label: Text(" prix "),
                    counterStyle: TextStyle(height: double.minPositive),
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue,width: 2)),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 5))
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                textInputAction:TextInputAction.done,
                controller: stock,
                decoration:InputDecoration(
                    label: Text(" Stock "),
                    counterStyle: TextStyle(height: double.minPositive),
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue,width: 2)),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 5))
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(50.0),
              child: ElevatedButton(
                  onPressed: (){},
                  child:Container(
                      margin: EdgeInsets.only(left: 10,right: 10),
                      width: double.infinity,
                      child:
                      MaterialButton(onPressed: () async{


                        FirebaseFirestore.instance.collection('detaille').add(
                            {
                              "nom":"${nom.text}",
                              "prix":num.parse(prix.text),
                              "stock":num.parse(stock.text),
                              "count":0,
                              "total":0,
                              "desc":"detaille",
                            }
                        );
                        setState(() {
                          nom.text="";
                          prix.text="";
                          stock.text="";

                        });

                        Fluttertoast.showToast(
                            msg: "L'ARTICLE Ajouter Avec Succeés",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.deepPurpleAccent,
                            textColor: Colors.white,
                            fontSize: 22.0
                        );
                      },

                          child: Text("Ajouter",textAlign: TextAlign.center,)))
              ),
            )
          ],
        ),
      ),

    );
  }
}
