import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class ParentsProfiles extends StatefulWidget {
  const ParentsProfiles({super.key});

  @override
  State<ParentsProfiles> createState() => _ParentsProfilesState();
}

class _ParentsProfilesState extends State<ParentsProfiles> {
  final _firestore = FirebaseFirestore.instance;

  // =====================================================
  // حذف حساب الأهل
  // =====================================================
  Future<void> _deleteProfile(String docId, String childName) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Profile'),
        content: Text('Are you sure you want to delete $childName\'s profile?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _firestore.collection('Users').doc(docId).delete();
      await _firestore.collection('FaceData').doc(docId).delete();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  // =====================================================
  // عرض بيانات الأهل كاملة
  // =====================================================
  void _showProfile(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          data['childName'] ?? 'Profile',
          style: GoogleFonts.robotoCondensed(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (data['image'] != null)
              Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(data['image']),
                ),
              ),
            const SizedBox(height: 12),
            _profileRow('Child Name', data['childName']),
            _profileRow('Child ID', data['childId']),
            _profileRow('Gender', data['gender']),
            _profileRow('Age', data['age']),
            _profileRow('Birthdate', data['date']),
            _profileRow('Parent ID', data['parentId']),
            _profileRow('Email', data['email']),
            _profileRow('Phone', data['phone']),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _profileRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: GoogleFonts.robotoCondensed(fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Text(
              value ?? '-',
              style: GoogleFonts.robotoCondensed(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () =>
              Navigator.of(context).pushReplacementNamed('AdminScreen'),
        ),
        title: Text(
          'Parents Profiles',
          style: GoogleFonts.robotoCondensed(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('Users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No profiles found',
                style: GoogleFonts.robotoCondensed(fontSize: 16),
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final docId = docs[index].id;

              return Card(
                color: const Color(0xffa7dae1),
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: data['image'] != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(data['image']),
                        )
                      : const CircleAvatar(child: Icon(Icons.child_care)),
                  title: Text(
                    data['childName'] ?? '-',
                    style: GoogleFonts.robotoCondensed(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'ID: ${data['childId'] ?? '-'}',
                    style: GoogleFonts.robotoCondensed(),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // زر عرض البيانات
                      IconButton(
                        icon: const Icon(Icons.visibility, color: Colors.black),
                        onPressed: () => _showProfile(data),
                        tooltip: 'Show Profile',
                      ),
                      // زر الحذف
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>
                            _deleteProfile(docId, data['childName'] ?? ''),
                        tooltip: 'Delete Profile',
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
