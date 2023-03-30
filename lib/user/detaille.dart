import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';



class detaille extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<detaille> {

  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;
  final Stream<QuerySnapshot> serv = FirebaseFirestore.instance.collection('detaille').snapshots();
  CollectionReference detaille=FirebaseFirestore.instance.collection('detaille');
  double total=0;

  bool active=false;
  Future<bool> button()async{
    var responce=await detaille.where('count',isGreaterThan: 0).get();
    if(responce.docs.isEmpty){
      setState(() {
        active=false;
      });
    }else{
      setState(() {
        active=true;
      });
    }
    return active;
  }



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

      body:
      Container(
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
                        stream:  serv,
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

                              controller: controller,
                              physics: BouncingScrollPhysics(),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                int ind=index;
                                double scale = 1.0;
                                if (topContainer > 0.5) {
                                  scale = index + 0.5 - topContainer;
                                  if (scale < 0) {
                                    scale = 0;
                                  } else if (scale > 1) {
                                    scale = 1;
                                  }
                                }
                                DocumentSnapshot service = snapshot.data!.docs[index];



                                return Opacity(
                                  opacity: scale,
                                  child: Transform(
                                    transform:  Matrix4.identity()..scale(scale,scale),
                                    alignment: Alignment.topCenter,
                                    child: Align(
                                      heightFactor: 0.7,
                                      alignment: Alignment.topCenter,
                                      child:
                                      Container(
                                        height: 100,
                                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0)), color: Colors.greenAccent, boxShadow: [
                                          BoxShadow(color: Colors.black.withAlpha(1000), blurRadius: 10.0),
                                        ]),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[

                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      service["nom"],
                                                      style: const TextStyle(fontSize: 20, color: Colors.black87,fontWeight: FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      " ${service['prix'].toStringAsFixed(3)} \Dt",
                                                      style: const TextStyle(fontSize: 17, color: Colors.purple, fontWeight: FontWeight.bold),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                    margin: EdgeInsets.only(
                                                        left: 60,top: 15),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(color: Colors.blue),
                                                        borderRadius: BorderRadius.circular(
                                                            20)),
                                                    child:
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        GestureDetector(
                                                          child: Container(alignment: Alignment.center,
                                                              height: 35,
                                                              width: 35,
                                                              decoration: BoxDecoration(

                                                                  borderRadius: BorderRadius
                                                                      .circular(30)),
                                                              child: IconButton(
                                                                  onPressed: (){
                                                                    button();
                                                                    setState(() {
                                                                      if(service['count']>0){
                                                                        FirebaseFirestore.instance.collection("detaille").doc(service.id).update(
                                                                            {
                                                                              "count":service['count']-1,
                                                                              "total":(service['count']-1)*(service['prix']),
                                                                              "stock":service['stock']+1,
                                                                            }
                                                                        );

                                                                      }

                                                                    });

                                                                  },
                                                                  icon: Icon(Icons.remove,
                                                                      color: Colors.blue))),
                                                        ),
                                                        Text("${service['count']}"),
                                                        GestureDetector(

                                                          child: Container(alignment: Alignment.center,
                                                              height: 35,
                                                              width: 35,
                                                              decoration: BoxDecoration(

                                                                  borderRadius: BorderRadius
                                                                      .circular(30)),
                                                              child: IconButton(

                                                                  onPressed: service['stock']>0 ?
                                                                      (){
                                                                    button();
                                                                    setState(() {
                                                                      FirebaseFirestore.instance.collection("detaille").doc(service.id).update(
                                                                          {
                                                                            "count":service['count']+1,
                                                                            "total":(service['count']+1)*(service['prix']),
                                                                            "stock":service['stock']-1,
                                                                          }
                                                                      );

                                                                    });
                                                                  }
                                                                      :(){
                                                                    Fluttertoast.showToast(
                                                                        msg: "معادش ثما في stock",
                                                                        toastLength: Toast.LENGTH_LONG,
                                                                        gravity: ToastGravity.BOTTOM,
                                                                        timeInSecForIosWeb: 1,
                                                                        backgroundColor: Colors.redAccent,
                                                                        textColor: Colors.white,
                                                                        fontSize: 22.0
                                                                    );
                                                                  },
                                                                  icon: Icon(Icons.add,
                                                                      color: Colors.blue))),
                                                        ),
                                                      ],)
                                                ),
                                              )
                                            ],
                                          ),
                                        ),

                                      ),
                                    ),
                                  ),
                                );
                              });
                        }
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,

                      children: [
                        ElevatedButton(
                          onPressed: active==true ?
                              () async{
                            setState(() {
                              active=false;
                            });
                            var get=await detaille.where('count',isGreaterThan: 0).get();
                            get.docs.forEach((element) {
                              print(element.data());
                              FirebaseFirestore.instance.collection('facture').add(
                                  {
                                    'nom':(element.data() as dynamic)['nom'],
                                    'count':(element.data() as dynamic)['count'],
                                    'total':(element.data() as dynamic)['total'],
                                    'desc':(element.data() as dynamic)['desc'],
                                  }
                              );
                            });


                            var responce=await detaille.get();
                            responce.docs.forEach((element) {
                              setState(() {
                                num tot =(element.data() as dynamic)['total'];
                                total=total+tot;
                              });
                              print(total);
                            });


                            responce.docs.forEach((element) {

                              FirebaseFirestore.instance.collection('detaille').doc(element.id).update(
                                  {
                                    'count':0,
                                    'total':0,

                                  }
                              );
                            });

                          }
                              :null,
                          child: Text("confirmer"),
                        ),
                        MaterialButton(
                          color: Colors.red,
                          textColor: Colors.white,
                          onPressed:() async{
                            FirebaseFirestore.instance.collection('detaille').where('count' ,isGreaterThan: 0).get().then((value) {
                              value.docs.forEach((element) {
                                FirebaseFirestore.instance.collection('detaille').doc(element.id).update({
                                  "stock":(element.data() as dynamic)['stock']+(element.data() as dynamic)['count'],
                                  "count":0

                                });
                              });
                            });


                            var sup = await FirebaseFirestore.instance.collection('facture').where('desc',isEqualTo: "detaille").get();
                            sup.docs.forEach((element) {

                              FirebaseFirestore.instance.collection('facture').doc(element.id).delete();
                            });

                            setState(() {
                              active=false;
                            });

                          },
                          child: Text('Annuler'),
                        )

                      ],
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
              stream:  FirebaseFirestore.instance.collection('detaille').where('nom',isEqualTo:query ).snapshots(),
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
