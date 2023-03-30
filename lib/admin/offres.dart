import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extra_market/admin/ajouter_off.dart';
import 'package:extra_market/admin/modif_offres.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jiffy/jiffy.dart';


class offres extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return Offres();
  }

}
class Offres extends State<offres> {








  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;

  final Stream<QuerySnapshot> offr = FirebaseFirestore.instance.collection('offre').snapshots();


  @override
  void initState() {
    super.initState();

    controller.addListener(() {

      double value = controller.offset/119;

      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double categoryHeight = size.height*0.30;
    return Scaffold(
      backgroundColor: Colors.white,
      body:
      Container(
          alignment: Alignment.center,
          child:
          Column(children: [
            SizedBox(height: 15,),
            GestureDetector(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder:((context) => ajout_off() )));
              },
              child: Container(
                margin: EdgeInsets.only(left: 80,right: 80),

                decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    border: Border.all(color: Colors.grey)),
              child: Center(
                child:
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.add,size: 30,color: Colors.white,),
                ),
              ),

              ),
            ),

            Expanded(
                child: SafeArea(
                  child: Scaffold(
                    backgroundColor: Colors.white,
                    body: Container(
                      height: size.height,
                      child: Column(
                        children: <Widget>[

                          const SizedBox(
                            height: 10,
                          ),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: closeTopContainer?0:1,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: size.width,
                              alignment: Alignment.topCenter,

                            ),
                          ),

                          Expanded(
                            child: StreamBuilder<QuerySnapshot>(
                                stream:   FirebaseFirestore.instance.collection('gros').snapshots(),
                                builder:
                                    ( context,  snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Something went wrong');
                                  }

                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(child: CircularProgressIndicator(),);
                                  }

                                  return ListView.builder(
                                      physics:BouncingScrollPhysics(),
                                      itemCount: snapshot.data!.docs.length,

                                      itemBuilder: (context, index) {
                                        DocumentSnapshot offre = snapshot.data!.docs[index];


                                        return GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>modif(offre:offre)));
                                            });
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                                      border: Border.all(color: Colors.grey)),
                                                  child: ListTile(
                                                    title: Text(offre['nom']),
                                                    subtitle: Column(
                                                      children: [
                                                        SizedBox(height: 5),
                                                        Container(alignment: Alignment.topLeft,child: Text("Prix : ${offre['prix'].toStringAsFixed(3)} dt",style: TextStyle(color: Colors.black,fontSize: 15,),)),
                                                        SizedBox(height: 5),
                                                        Container(alignment: Alignment.topLeft,child: Text("Stock : ${offre['stock']}",style: TextStyle(color: Colors.black,fontSize: 15,),)),

                                                      ],
                                                    ),

                                                    trailing:IconButton(
                                                      icon: Icon(Icons.delete),
                                                      onPressed: (){
                                                        showDialog(context: context, builder: (context) {
                                                          return AlertDialog(

                                                            title: Text(" Vous Etés sure de supprimer L'ARTICLE"),
                                                            actions: [
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  FirebaseFirestore.instance.collection('gros').doc(offre.id).delete();
                                                                  Navigator.of(context).pop();
                                                                  Fluttertoast.showToast(
                                                                      msg: "l'article supprimer avec succées",
                                                                      toastLength: Toast.LENGTH_SHORT,
                                                                      gravity: ToastGravity.BOTTOM,
                                                                      timeInSecForIosWeb: 1,
                                                                      backgroundColor: Colors.deepPurpleAccent,
                                                                      textColor: Colors.white,
                                                                      fontSize: 22.0
                                                                  );
                                                                },
                                                                child: Text("confirmer", style: TextStyle(
                                                                    color: Colors.white)),),
                                                              MaterialButton(
                                                                color: Colors.blue,
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                },
                                                                child: Text("cancel", style: TextStyle(
                                                                    color: Colors.white)),),

                                                            ],
                                                          );
                                                        });
                                                      },
                                                    ),


                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                }
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
            ),

          ])
      ),
    );
  }

}


