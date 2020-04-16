import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  final String name = 'Jason';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(name),
        ),
        body: Stack(
          children: <Widget>[
            StreamBuilder(
                stream: Firestore.instance.collection('scenarios').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Text('loading');
                  return Padding(
                    padding: EdgeInsets.only(left: 12, right: 12, top: 25),
                    child: ListView(
                      children: <Widget>[
                        Card(
                            elevation: 10,
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'Role : ' +
                                    snapshot.data.documents[0]['roles'][0],
                                textScaleFactor: 2,
                              ),
                            )),
                        Container(
                          height: 16,
                        ),
                        Card(
                            elevation: 10,
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'Setting : ' +
                                    snapshot.data.documents[0]['setting'],
                                textScaleFactor: 2,
                              ),
                            )),
                      ],
                    ),
                  );
                }),
            StreamBuilder(
                stream: Firestore.instance.collection('nextGame').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Text('loading');
                  if (snapshot.data.documents[0]['amount'] == 6) {
                    Firestore.instance.runTransaction((transaction) async {
                      await transaction.update(
                          snapshot.data.documents[0].reference, {'amount': 0});
                      await transaction.update(snapshot.data.documents[], data)
                    });
                  }
                  if (!snapshot.data.documents[0][name])
                    return Positioned(
                      bottom: 10.0,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 70,
                            child: RaisedButton(
                              color: Colors.red,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              onPressed: () {
                                Firestore.instance
                                    .runTransaction((transaction) async {
                                  DocumentSnapshot freshSnap =
                                      await transaction.get(
                                          snapshot.data.documents[0].reference);
                                  await transaction.update(
                                      freshSnap.reference, {
                                    'amount': freshSnap['amount'] + 1,
                                    'Jason': true
                                  });
                                });
                              },
                              child: Text(
                                'New Game ' +
                                    snapshot.data.documents[0]['amount']
                                        .toString() +
                                    '/6',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ),
                            )),
                      ),
                    );
                  return Positioned(
                    bottom: 10.0,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 70,
                          child: RaisedButton(
                            color: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            onPressed: () {
                              Firestore.instance
                                  .runTransaction((transaction) async {
                                DocumentSnapshot freshSnap = await transaction
                                    .get(snapshot.data.documents[0].reference);
                                await transaction.update(freshSnap.reference, {
                                  'amount': freshSnap['amount'] - 1,
                                  'Jason': false
                                });
                              });
                            },
                            child: Text(
                              'Cancel ' +
                                  snapshot.data.documents[0]['amount']
                                      .toString() +
                                  '/6',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                            ),
                          )),
                    ),
                  );
                }),
          ],
        ));
  }
}
