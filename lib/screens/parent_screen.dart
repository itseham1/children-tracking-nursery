import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class ParentPage extends StatefulWidget {
  ParentPage({super.key});

  @override
  State<ParentPage> createState() => _ParentPageState();
}

class _ParentPageState extends State<ParentPage> {
  @override
  Widget build(BuildContext context) {


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
                'Child ID : forexample' ,
                style: GoogleFonts.robotoCondensed(
                    fontSize: 15, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 55.0,
              ),
              Text(
                "Child Name : forexample" ,
                style: GoogleFonts.robotoCondensed(
                    fontSize: 15, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 250.0,
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
                      Icons.person,
                      size: 24.0,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text('Profile',
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
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('SendRequest');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffa7dae1),
                  foregroundColor: Colors.black87,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.video_call,
                      size: 24.0,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text('Request Monitor',
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
