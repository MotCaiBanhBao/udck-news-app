import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Text"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => FirebaseFirestore.instance
              .collection("testing")
              .add({"Timestamp": Timestamp.fromDate(DateTime.now())}),
          child: const Icon(Icons.add),
        ),
      
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("testing").snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return const SizedBox.shrink();
            return ListView.builder(
              itemBuilder: (context, index) {
                final docData = snapshot.data!.docs[index].data();
                final dateTime = ((docData as Map<String, dynamic>)['Timestamp']
                        as Timestamp)
                    .toDate();
                return ListTile(
                  title: Text(dateTime.toString()),
                );
              },
              itemCount: snapshot.data?.docs.length,
            );
          },
        ),
      ),
    );
  }
}
