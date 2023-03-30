import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extra_market/admin/des_article.dart';
import 'package:extra_market/user/fade_animation.dart';
import 'package:jiffy/jiffy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';


class home extends StatefulWidget{
  @override

  State<StatefulWidget> createState() {
    return testhome();
  }

}

class testhome extends State<home> {
  bool showPassword = false;
  bool enable = false;
  CollectionReference historique=FirebaseFirestore.instance.collection('historique');
  double recette=0;
  double r=0;
  int variable=0;
  var allData ;

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed

    super.dispose();
  }
  get_recett()async{
    var responce=await historique.get();
    responce.docs.forEach((element) {
      setState(() {
        num tot =(element.data() as dynamic)['total'];
        recette=recette+tot;
      });

    });

  }

  void _createPdf() async {

    var responce=await historique.get();
    responce.docs.forEach((element) {
      setState(() {
        num tot =(element.data() as dynamic)['total'];
        r=r+tot;
      });

    });
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('historique').get();
    allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    var font = await PdfGoogleFonts.cairoBlack();
    final doc = pw.Document();
    final image = await imageFromAssetBundle('images/TT.png');
    doc.addPage(

        pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context){
              return pw.Column(
                  children:[
                    pw.Expanded(
                        flex: 1,
                        child: pw.Center(
                          child: pw.Image(image),
                        )),
                    pw.Expanded(
                        flex: 3,
                        child: pw.ListView.builder(
                            itemCount: allData.length,
                            itemBuilder:    (context ,i){
                              return
                                pw.Padding(
                                  padding: pw.EdgeInsets.all(10),
                                  child:pw.Row(
                                    children: [
                                      pw.Expanded(child: pw.Text('Facture N° ${i+1}  ',style: pw.TextStyle(font:font ,),textAlign: pw.TextAlign.center,textDirection: pw.TextDirection.rtl,),),
                                      pw.Expanded(child: pw.Text("${Jiffy(DateTime.parse(allData[i]['date'].toDate().toString())).format("d/M/y   HH:mm")}")),
                                      pw.Expanded(child: pw.Expanded(child:pw.Text('Total : ${allData[i]['total'].toStringAsFixed(3)} Dt '))),
                                    ],
                                  ),
                                );
                            }
                        )),
                    pw.Container(
                      height: 50,
                      decoration: pw.BoxDecoration(
                          color: PdfColors.blue,
                          borderRadius: pw.BorderRadius
                              .circular(30)
                      ),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                        children: [
                          pw.Text("Recette : ",style: pw.TextStyle(color: PdfColors.white),),
                          pw.Text("${r.toStringAsFixed(3)} DT",style: pw.TextStyle(color: PdfColors.white))
                        ],
                      ),
                    ),
                  ]
              );
            }
        )
    );


    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => doc.save());
  }
  @override
  void initState() {
    super.initState();
    get_recett();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      resizeToAvoidBottomInset: true,

      body:


      Column(
        children: [

          Expanded(
            child: Container(

              margin: EdgeInsets.only(left: 20, right: 20, bottom: 30),

              child: Stack(

                  children: [

                    Container(
                      height: 60,
                      margin: EdgeInsets.only(top: 30,bottom: 30,left: 80,right: 80),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius
                              .circular(30)
                      ),
                      child: Column(

                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("Recette  : ",style: TextStyle(color: Colors.white),),
                                Text("${recette.toStringAsFixed(3)} DT",style: TextStyle(color: Colors.white))
                              ],
                            ),
                          ),
                          Expanded(
                            child: ElevatedButton(

                              style: ElevatedButton.styleFrom(shape: StadiumBorder(),backgroundColor: Colors.red,elevation: 25),
                              onPressed: () async{

                                var get=await FirebaseFirestore.instance.collection('variable').get();
                                get.docs.forEach((element) {
                                  setState(() {
                                    variable=(element.data() as dynamic)['i'];
                                  });
                                });
                                for(int i=1;i<=variable;i++){
                                  var responce =await FirebaseFirestore.instance.collection('historique').doc('$i').collection('$i').get();
                                  responce.docs.forEach((element) {
                                    FirebaseFirestore.instance.collection('historique').doc('$i').delete();
                                    FirebaseFirestore.instance.collection('historique').doc('$i').collection('$i').doc(element.id).delete();
                                  });
                                }
                                setState(() {
                                  recette=0;
                                  FirebaseFirestore.instance.collection("variable").doc('variable').update(
                                      {
                                        "i":1,
                                      }
                                  );
                                });
                              },
                              child: Text('Cloture'),
                            ),
                          ),
                        ],
                      ),
                    ),


                    Container(

                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                          top: 160),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 2),
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child:
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('historique').snapshots(),
                          builder:
                              (context, snapshot) {
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
                                  DocumentSnapshot hist = snapshot.data!
                                      .docs[index];

                                  return Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              border: Border.all(
                                                  color: Colors.grey)),
                                          child: GestureDetector(
                                            onTap: (){
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>desc(index:index )));
                                            },
                                            child: ListTile(
                                              title: Text('facture : ${index+1}'),
                                              subtitle: Column(
                                                children: [
                                                  SizedBox(height: 5),
                                                  Container(alignment: Alignment
                                                      .topLeft,
                                                      child: Text(
                                                        "Prix : ${hist['total']
                                                            .toStringAsFixed(
                                                            3)} dt",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15,),)),

                                                ],
                                              ),

                                              trailing:  Container(child: Text("${Jiffy(
                                                  DateTime.parse(hist['date']
                                                      .toDate()
                                                      .toString())).format(
                                                  "d/M/y   HH:mm")}")),


                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          }
                      ),
                    ),


                    Positioned(
                        left: 50,
                        top: 150,
                        child:
                        Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            color: Colors.white,
                            child:
                            Text("HISTORIQUE", style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),)
                        )
                    ),
                    Positioned(
                        right: 15,
                        bottom: 15,
                        child:
                        IconButton(
                          onPressed: () {
                            _createPdf();
                            setState(() {
                              r=0;
                            });                          },
                          icon:Icon(Icons.print,size: 50,color: Colors.blue,),)
                    )

                  ]),
            ),
          ),

        ],
      ),


    );
  }
}