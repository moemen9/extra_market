import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';



class facture extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<facture> {


    CollectionReference facture=FirebaseFirestore.instance.collection('facture');
    double total=0;
    double t=0;
    int i=0;

    CollectionReference variable = FirebaseFirestore.instance.collection('variable');
    bool active=false;
    var allData ;

    @override
    void dispose() {
      super.dispose();
    }

   Future<bool> button()async{
      var responce=await facture.get();
      if(responce.docs.isEmpty){
        active=false;
      }else{
        active=true;
      }
      return active;
    }
    get_total()async{
      var responce=await facture.get();
      responce.docs.forEach((element) {
        setState(() {
          num tot =(element.data() as dynamic)['total'];
          total=total+tot;
        });

      });

    }

    void _createPdf() async {
      var responce=await facture.get();
      responce.docs.forEach((element) {
        setState(() {
          num tot =(element.data() as dynamic)['total'];
          t=t+tot;
        });

      });

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('facture').get();
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
                           pw.Expanded(child: pw.Text('${allData[i]['nom']}  ',style: pw.TextStyle(font:font ,),textAlign: pw.TextAlign.center,textDirection: pw.TextDirection.rtl,),),
                           pw.Expanded(child: pw.Text('${allData[i]['desc']}')),
                           pw.Expanded(child: pw.Text("Quantite : ${allData[i]['count']}")),
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
                      pw.Text("Total : ",style: pw.TextStyle(color: PdfColors.white),),
                      pw.Text("${t.toStringAsFixed(3)} DT",style: pw.TextStyle(color: PdfColors.white))
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
    //
    @override
    void initState() {
      super.initState();
      get_total();
      button();
    }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(

        body:

        Container(

          child:
          Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream:   FirebaseFirestore.instance.collection('facture').snapshots(),
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

              Container(
                height: 50,
                margin: EdgeInsets.only(bottom: 30,left: 80,right: 80),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius
                      .circular(30)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Total : ",style: TextStyle(color: Colors.white),),
                    Text("${total.toStringAsFixed(3)} DT",style: TextStyle(color: Colors.white))
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,

                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        onSurface: Colors.blue,
                      ),
                      onPressed: active== true ?
                          ()async
                      {
                        _createPdf();
                        var responce=await variable.get();
                        responce.docs.forEach((element) {
                          setState(() {
                            i=(element.data() as dynamic)['i'];
                          });
                        });

                        var get=await facture.get();
                        get.docs.forEach((element)  {
                          FirebaseFirestore.instance.collection('historique').doc('$i').collection('$i').add(
                              {
                                'nom':(element.data() as dynamic)['nom'],
                                'count':(element.data() as dynamic)['count'],
                                'total':(element.data() as dynamic)['total'],
                                'desc':(element.data() as dynamic)['desc'],
                              }
                          );


                        });
                        FirebaseFirestore.instance.collection('historique').doc('$i').set(
                            {
                              'total':total,
                              'date':DateTime.now()
                            }
                        );
                        FirebaseFirestore.instance.collection("variable").doc('variable').update(
                            {
                              "i":i+1,
                            }
                        );
                        setState(() {
                          total=0;

                          FirebaseFirestore.instance.collection('facture').get().then((value) {
                            value.docs.forEach((element) {
                              FirebaseFirestore.instance.collection('facture').doc(element.id).delete();
                            });
                          });
                        });
                        setState(() {
                          active=false;
                        });

                      }
                      :null,
                      child: Text("imprimer"),
                    ),
                    MaterialButton(
                      color: Colors.red,
                      textColor: Colors.white,
                      onPressed: (){
                          setState(() {
                            total=0;
                            active=false;
                            FirebaseFirestore.instance.collection('facture').get().then((value) {
                             value.docs.forEach((element) {
                               if("${(element.data() as dynamic)['desc']}"=="gros"){
                               FirebaseFirestore.instance.collection('gros').get().then((value) {
                                 value.docs.forEach((e) {
                                 if("${(e.data() as dynamic)['nom']}"=="${(element.data() as dynamic)['nom']}"){
                                 print((element.data() as dynamic)['count']);
                                   FirebaseFirestore.instance.collection('gros').doc(e.id).update(
                                       {
                                         'stock':(e.data() as dynamic)['stock']+(element.data() as dynamic)['count']
                                       });
                                 }
                                 });
                               });
                               }else{
                                 FirebaseFirestore.instance.collection('detaille').get().then((value) {
                                   value.docs.forEach((e) {
                                     if("${(e.data() as dynamic)['nom']}"=="${(element.data() as dynamic)['nom']}"){
                                       print((element.data() as dynamic)['count']);
                                       FirebaseFirestore.instance.collection('detaille').doc(e.id).update(
                                           {
                                             'stock':(e.data() as dynamic)['stock']+(element.data() as dynamic)['count']
                                           });
                                     }
                                   });
                                 });
                               }

                             });
                             });
                        });

                          FirebaseFirestore.instance.collection('facture').get().then((value) {
                            value.docs.forEach((element) {
                              FirebaseFirestore.instance.collection('facture').doc(element.id).delete();
                            });
                          });
                      },
                      child: Text('Annuler'),
                    )

                  ],
                ),
              ),
            ],
          ),
        ),

      );

  }



}
