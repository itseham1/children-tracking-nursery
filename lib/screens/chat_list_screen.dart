import 'package:app/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        leading: GestureDetector(
          child: const Icon(Icons.arrow_back, color: Colors.black),
          onTap: () => Navigator.pop(context),
        ),
        title: Text(
          'Chats',
          style: GoogleFonts.robotoCondensed(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No parents registered yet.',
                style: GoogleFonts.robotoCondensed(
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),
            );
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final data = users[index].data() as Map<String, dynamic>;
              final parentEmail = data['email'] ?? '';
              final childName = data['childName'] ?? '-';
              final chatId = 'admin_${parentEmail.replaceAll('.', '_').replaceAll('@', '_')}';

              return Card(
                color: const Color(0xffa7dae1),
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF085041),
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(
                    childName,
                    style: GoogleFonts.robotoCondensed(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF085041),
                    ),
                  ),
                  subtitle: Text(
                    parentEmail,
                    style: GoogleFonts.robotoCondensed(
                      color: const Color(0xFF0F6E56),
                      fontSize: 12,
                    ),
                  ),
                  trailing: const Icon(Icons.chat, color: Color(0xFF085041)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          chatId: chatId,
                          otherUserName: childName,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
