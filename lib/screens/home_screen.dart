import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:phone_login_app/models/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // doc ID
  List<String> docIDs = [];

  // get docIDs
  Future getDocIDs() async {
    await FirebaseFirestore.instance.collection('users').get().then(
          (snapshot) => snapshot.docs.forEach(
            (element) {
              print(element.reference);
              docIDs.add(element.reference.id);
            },
          ),
        );
  }

  @override
  void initState() {
    getDocIDs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text('hello'),
            Expanded(
              child: FutureBuilder(
                future: getDocIDs(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemCount: docIDs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: GetUserName(documentId: docIDs[index]),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
