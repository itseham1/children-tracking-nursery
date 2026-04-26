import 'package:app/screens/Read_Data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ParentsProfiles extends StatefulWidget {
  const ParentsProfiles({super.key});

  @override
  State<ParentsProfiles> createState() => _ParentsProfilesState();
}

class _ParentsProfilesState extends State<ParentsProfiles> {
  final user = FirebaseAuth.instance.currentUser!;
///////// Document IDs //////////
  List<String> docIDs = [];

////////// getdocIDs //////////

var auth = FirebaseAuth.instance.currentUser;
 Future getparentID() async {
    await FirebaseFirestore.instance.collection('Users')
    .get()
    .then(
          (snapshot) => snapshot.docs.forEach(
            (element) {
              print(element.reference);
              docIDs.add(element.reference.id);
            },
          ),
        );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            backgroundColor: Colors.grey[300],
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () =>
                  Navigator.of(context).pushReplacementNamed('AdminScreen'),
            ),
          ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 60,),
            Expanded(
              child: FutureBuilder(
                future: getparentID(),
                builder: (context, snapshot) {
                return ListView.builder(
                itemCount: docIDs.length,
                itemBuilder: ((context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: GetUserName(documentId: docIDs[index]),
                    tileColor: Color(0xffa7dae1),
                  ),
                );
              }
              ),
              );
              },),
            ),
          ],
        ),
      ),
    );
  }
}
