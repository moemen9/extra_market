import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extra_market/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:jiffy/jiffy.dart';
import 'facture.dart';
import 'gros.dart';
import 'detaille.dart';


class link extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return links();
  }

}
class links extends State<link>{
  var index_selected=1;
  List<Widget> pages=[
    gros(),
    facture(),
    detaille(),
  ];
  List cos=[];
getUser(){
  var user = FirebaseAuth.instance.currentUser;
  print(user?.email);
}




  Widget build(BuildContext context) {


    return Scaffold(

      appBar: AppBar(

        leading:Image.asset("images/TT.png",),
        actions: [
          IconButton(icon: Icon(Icons.search,size: 30,), onPressed: () {
            showSearch(context: context, delegate: recherche());
          },),
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
            TabItem(icon: Icon(Icons.add_shopping_cart) ,title: "FACTURE"),
            TabItem(icon: Icon(Icons.home_repair_service) ,title: "DETAILLE"),
          ],
      ),
        body:

        pages.elementAt(index_selected),



      );
  }

}
class NamedIcon extends StatelessWidget {
  final IconData iconData;
  final VoidCallback? onTap;
  final int notificationCount;

  const NamedIcon({
    Key? key,
    this.onTap,
    required this.iconData,
    required this.notificationCount ,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 72,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(iconData,size: 35,),
              ],
            ),
            Positioned(
              top: 8,
              right: 6,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                alignment: Alignment.center,
                child: Text("${notificationCount}"),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class recherche extends SearchDelegate{

  @override
  List<Widget>? buildActions(BuildContext context) {
    return[
      IconButton(icon:Icon(Icons.close), onPressed: () {
        query="";
      },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton( icon: Icon(Icons.arrow_back), onPressed: () {
      close(context, null);
    });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text("");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      child: query==""?
      Container()
          :Container(
          child:
          StreamBuilder<QuerySnapshot>(
              stream:  FirebaseFirestore.instance.collection('gros').where('nom',isEqualTo:query ).snapshots(),
              builder:
                  ( context,  snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Text("Loading");
                }
                return ListView.builder(


                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {

                      DocumentSnapshot service = snapshot.data!.docs[index];


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
                                title: Text(service['nom']),
                                subtitle: Column(
                                  crossAxisAlignment:CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 5),
                                    Container(alignment: Alignment.topLeft,child: Text("Prix : ${service['prix'].toStringAsFixed(3)} dt",style: TextStyle(color: Colors.black,fontSize: 15,),)),

                                  ],
                                ),

                              ),
                            ),
                          ],
                        ),
                      );
                    });
              }
          )
      ),
    );
  }

}