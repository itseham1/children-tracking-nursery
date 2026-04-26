import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final _firestore = FirebaseFirestore.instance;
//late String name = "";
late String adminId = "";

class AdminScreen extends StatefulWidget {
  AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  void getAdmin() async {
    final _firestore = FirebaseFirestore.instance;
    var query = await _firestore
        .collection('Admin')
        .doc("Admin1U")
        .get()
        .then((value) async {
      var _userData = value.data();

      //name = _userData!["Name"];
      adminId = _userData!["Admin ID"];
      //print(" Admin Name" + name);
    });
  }

  @override
  Widget build(BuildContext context) {
    getAdmin();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.of(context).pushReplacementNamed('loginScreen');
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 3.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(
                height: 150,
              ),
              Text(
                'Admin ID : ' + adminId,
                style: GoogleFonts.robotoCondensed(
                    fontSize: 15, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 55.0,
              ),
              Text(
                "Admin Name : forexample",
                style: GoogleFonts.robotoCondensed(
                    fontSize: 15, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 250.0,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('ParentsProfiles');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffa7dae1),
                  foregroundColor: Colors.black87,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.people,
                      size: 24.0,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Parents Profiles',
                      style: GoogleFonts.robotoCondensed(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffa7dae1),
                  foregroundColor: Colors.black87,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.chat,
                      size: 24.0,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text('Chatting',
                        style: GoogleFonts.robotoCondensed(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        )),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}


