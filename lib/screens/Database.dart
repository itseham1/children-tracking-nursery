import 'package:cloud_firestore/cloud_firestore.dart';


class Databese {
  static Future<String> singUpPerent({
    required String parentId,
    required String email,
    required String phone,
    required String password,
    required String childId,
    required String childName,
    required String image,
    required String date,
    required String gender,
    required String age,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('Users').add({
        'parentId': parentId,
        'email': email,
        'phone': phone,
        'password': password,
        'childId': childId,
        'childName': childName,
        'image': image,
        'gender': gender,
        'age': age,
      });
      return 'done';
    } on FirebaseException catch (e) {
      if (e.code == 'weak-password') {
        return 'weak-password';
      }
      if (e.code == 'email-already-in-use') {
        return 'email-already-in-use';
      }
    } catch (e) {
      return e.toString();
    }
    return 'error';
  }
}