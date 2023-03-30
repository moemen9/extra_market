import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class desc extends StatefulWidget {
  int index;
  desc ({required this.index});


  @override
  State<desc> createState() => _MyHomePageState(index);
}

class _MyHomePageState extends State<desc> {
  int index;
  _MyHomePageState(this.index);


  @override
  void initState() {
    super.initState();
    print(index);
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:AppBar (

      ),

      body:
      Container(
        child: StreamBuilder<QuerySnapshot>(

            stream:   FirebaseFirestore.instance.collection('historique').doc('${index+1}').collection("${index+1}").snapshots(),
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

                  itemCount: snapshot.data!.docs.length,

                  itemBuilder: (context, index) {
                    DocumentSnapshot hist = snapshot.data!.docs[index];

                    return Padding(
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

                              title: Row(
                                children: [
                                  Text('${hist['nom']} : '),
                                  Text('${hist['desc']}'),
                                ],

                              ),
                              subtitle:

                              Text("Quantite : ${hist['count']}",style: TextStyle(color: Colors.black,fontSize: 15,),),



                              trailing:Text("total : ${hist['total'].toStringAsFixed(3)} dt",style: TextStyle(color: Colors.black,fontSize: 15,),),


                            ),
                          ),
                        ],
                      ),
                    );
                  });
            }
        ),
      ),
    );
  }
}
