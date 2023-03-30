import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class modif_s extends StatefulWidget {
  DocumentSnapshot service;
  modif_s ({required this.service});


  @override
  State<modif_s> createState() => _MyHomePageState(service);
}

class _MyHomePageState extends State<modif_s> {
  DocumentSnapshot service;
  _MyHomePageState(this.service);



  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    final nom = TextEditingController(text: "${service['nom']}");
    final prix = TextEditingController(text: "${service['prix']}");
    final stock = TextEditingController(text: "${service['stock']}");
    CollectionReference serv=FirebaseFirestore.instance.collection('detaille');
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
                decoration:InputDecoration(
                    label: Text(" name "),
                    counterStyle: TextStyle(height: double.minPositive),
                    border: OutlineInputBorder(),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 5))
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(30.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
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
                controller: stock,
                decoration:InputDecoration(
                    label: Text(" stock "),
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
                      MaterialButton(onPressed: () {


                        serv.doc(service.id).update(
                            {
                              "prix": num.parse(prix.text),
                              "stock": num.parse(stock.text),
                              "nom":  nom.text,
                            }
                        );

                        Fluttertoast.showToast(
                            msg: "La modification effectué Avec Succeés",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.deepPurpleAccent,
                            textColor: Colors.white,
                            fontSize: 22.0
                        );
                      },
                          child: Text("Modifier",textAlign: TextAlign.center,)))
              ),
            )
          ],
        ),
      ),

    );
  }
}
