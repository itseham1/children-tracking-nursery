import 'package:app/screens/chat_list_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  String adminId = '';
  String adminName = '';

  @override
  void initState() {
    super.initState();
    getAdmin();
  }

  Future<void> getAdmin() async {
    await FirebaseFirestore.instance
        .collection('Admin')
        .doc('Admin1U')
        .get()
        .then((value) {
      final data = value.data();
      if (data != null) {
        setState(() {
          adminId = data['Admin ID'] ?? '';
          adminName = data['Name'] ?? '';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        leading: GestureDetector(
          child: const Icon(Icons.arrow_back, color: Colors.black),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 150),
                adminId.isEmpty
                    ? const CircularProgressIndicator()
                    : Text(
                        'Admin ID : $adminId',
                        style: GoogleFonts.robotoCondensed(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                const SizedBox(height: 55.0),
                adminName.isEmpty
                    ? const SizedBox()
                    : Text(
                        'Admin Name : $adminName',
                        style: GoogleFonts.robotoCondensed(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                const SizedBox(height: 250.0),

                // Parents Profiles Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed('ParentsProfiles');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffa7dae1),
                    foregroundColor: Colors.black87,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.people, size: 24.0),
                      const SizedBox(width: 5),
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
                const SizedBox(height: 30),

                // Chatting Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatListScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffa7dae1),
                    foregroundColor: Colors.black87,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.chat, size: 24.0),
                      const SizedBox(width: 5),
                      Text(
                        'Chatting',
                        style: GoogleFonts.robotoCondensed(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
