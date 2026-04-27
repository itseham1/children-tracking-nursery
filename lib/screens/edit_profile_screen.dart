import 'package:app/screens/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  TextEditingController phoneController = TextEditingController();

  String childName = '';
  String childId = '';
  String gender = '';
  String age = '';

  String? docId;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    final snapshot = await _firestore
        .collection('Users')
        .where('email', isEqualTo: currentUser.email)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data();
      docId = snapshot.docs.first.id;
      setState(() {
        phoneController.text = data['phone'] ?? '';
        childName = data['childName'] ?? '-';
        childId = data['childId'] ?? '-';
        gender = data['gender'] ?? '-';
        age = data['age'] ?? '-';
        _isLoading = false;
      });
    }
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState?.validate() != true) return;
    if (docId == null) return;

    setState(() => _isSaving = true);

    await _firestore.collection('Users').doc(docId).update({
      'phone': phoneController.text.trim(),
    });

    setState(() => _isSaving = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: GoogleFonts.robotoCondensed(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.robotoCondensed(
              fontSize: 15,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[300],
          elevation: 0,
          leading: GestureDetector(
            child: const Icon(Icons.arrow_back, color: Colors.black),
            onTap: () => Navigator.pop(context),
          ),
          title: Text(
            'Edit Profile',
            style: GoogleFonts.robotoCondensed(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 15.w, vertical: 20.h),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20.h),
                          Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: 25.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 25.h),

                          // بيانات ثابتة للعرض فقط
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(12.h),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Child Information',
                                  style: GoogleFonts.robotoCondensed(
                                    fontSize: 13,
                                    color: Colors.grey[500],
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                _infoRow('Child Name', childName),
                                _infoRow('Child ID', childId),
                                _infoRow('Gender', gender),
                                _infoRow('Age', age),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.h),

                          // الحقل القابل للتعديل
                          textField(
                            context,
                            Icons.phone,
                            "Phone Number",
                            false,
                            phoneController,
                            valuedPhone,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                          SizedBox(height: 40.h),

                          bottom(
                            context,
                            _isSaving ? "Saving..." : "Save Changes",
                            Colors.black,
                            _isSaving ? null : _saveChanges,
                            backgroundColor: const Color(0xffa7dae1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
