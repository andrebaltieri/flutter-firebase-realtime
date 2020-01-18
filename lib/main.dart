import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eu Comida',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final bool _anchorToBottom = false;
  final FirebaseDatabase _database = new FirebaseDatabase();

  addOrder() async {
    var uuid = new Uuid();
    var ordersRef = _database.reference().child('orders');
    ordersRef.child(uuid.v1()).set({
      'number': uuid.v1(),
      'user': 'andrebaltieri',
      "status": "waiting_payment",
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedidos em Andamento"),
      ),
      body: new FirebaseAnimatedList(
        padding: EdgeInsets.all(40),
        key: new ValueKey<bool>(_anchorToBottom),
        query: _database.reference().child('orders'),
        reverse: _anchorToBottom,
        sort: _anchorToBottom
            ? (DataSnapshot a, DataSnapshot b) => b.key.compareTo(a.key)
            : null,
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          dynamic order = snapshot.value;
          return new SizeTransition(
            sizeFactor: animation,
            child: ListTile(
              title: Text(order["user"].toString()),
              subtitle: Text(order["number"].toString()),
              dense: true,
              trailing: order["status"] == "done"
                  ? Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    )
                  : CircularProgressIndicator(
                      strokeWidth: 1,
                    ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          addOrder();
        },
      ),
    );
  }
}
