import 'dart:io';

import 'package:app/screens/Database.dart';
import 'package:app/screens/face_recognition_service.dart';
import 'package:app/screens/model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:path/path.dart' as path;

class page_SignUp2 extends StatefulWidget {
  final String parintIdController;
  final String phoneController;
  final String passwordController;
  final String emailController;

  const page_SignUp2({
    Key? key,
    required this.parintIdController,
    required this.phoneController,
    required this.passwordController,
    required this.emailController,
  }) : super(key: key);

  @override
  State<page_SignUp2> createState() => _page_SignUp2State();
}

class _page_SignUp2State extends State<page_SignUp2> {
  TextEditingController nameController = TextEditingController();
  TextEditingController pictureController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController idController = TextEditingController();
  GlobalKey<FormState> addKey = GlobalKey();

  String? fileURL;
  Reference? fileRef;
  File? file;

  List<String> gander = ["Male", "Female"];
  List<String> age = ["1-6 month", "6-12 month", "1-2 year", "2-3 year"];
  String ageContriller = '';
  String genderController = '';

  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableLandmarks: true,
      enableContours: true,
      performanceMode: FaceDetectorMode.accurate,
    ),
  );

  @override
  void dispose() {
    _faceDetector.close();
    super.dispose();
  }

  Future<List<double>?> _extractFaceFromImage(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final faces = await _faceDetector.processImage(inputImage);

      if (faces.isEmpty) {
        return null; // ما في وجه في الصورة
      }

      final features =
          FaceRecognitionService.extractFaceFeatures(faces.first);
      return features;
    } catch (e) {
      return null;
    }
  }

  Future SignUp(String email, String pass) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email.trim(),
      password: pass.trim(),
    );
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[300],
          leading: GestureDetector(
            child: const Icon(Icons.arrow_back, color: Colors.black),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('loginScreen');
            },
          ),
          elevation: 0,
        ),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: 15.0.w, vertical: 0.h),
            child: SingleChildScrollView(
              child: Form(
                key: addKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 100.h),
                    Text(
                      'SIGN UP',
                      style: TextStyle(
                          fontSize: 25.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 25.h),

                    // Child Name
                    textField(
                        context,
                        Icons.child_care,
                        "Child Name",
                        false,
                        nameController,
                        manditary,
                        hintText: 'Please Enter English characters only',
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-z]|[A-Z]|[ا-ي]')),
                        ]),
                    SizedBox(height: 10.h),

                    // Child ID
                    textField(
                        context,
                        Icons.numbers,
                        "Child ID",
                        false,
                        idController,
                        valuedId,
                        keyboardType: TextInputType.number,
                        hintText: 'Please Enter numbers only',
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ]),
                    SizedBox(height: 10.h),

                    // Child Picture
                    textField(
                        context,
                        Icons.photo_size_select_actual_rounded,
                        "Child Picture",
                        false,
                        pictureController,
                        manditary, onTap: () {
                      setState(() {
                        selactPicture().whenComplete(() {
                          if (file != null) {
                            pictureController.text =
                                path.basename(file!.path);
                          }
                        });
                      });
                    }),
                    SizedBox(height: 10.h),

                    // Birthdate
                    textField(
                        context,
                        Icons.date_range_rounded,
                        "Child Birthdate",
                        false,
                        birthdayController,
                        manditary,
                        keyboardType: TextInputType.number,
                        onTap: onTapDate),
                    SizedBox(height: 10.h),

                    // Gender
                    menu(context, "Child Gender", Icons.category, 15, gander,
                        (v) {
                      setState(() => genderController = v!);
                    }, (v) {
                      if (v == null) return "please choose one";
                      return null;
                    }),
                    SizedBox(height: 10.h),

                    // Age
                    menu(
                        context,
                        "Child Age",
                        Icons.airline_seat_individual_suite_rounded,
                        14,
                        age, (v) {
                      setState(() => ageContriller = v!);
                    }, (v) {
                      if (v == null) return "please choose one";
                      return null;
                    }),
                    SizedBox(height: 40.h),

                    // Sign Up Button
                    bottom(
                      context,
                      "Sign Up",
                      Colors.white,
                      () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (addKey.currentState?.validate() == true) {
                          showMessaage('', true);

                          List<double>? faceFeatures;
                          if (file != null) {
                            faceFeatures =
                                await _extractFaceFromImage(file!);
                          }

                          if (faceFeatures == null) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    '⚠️ No face detected in the photo. Please choose a clear photo of the child\'s face.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          fileRef = FirebaseStorage.instance
                              .ref('image')
                              .child(pictureController.text);

                          await fileRef?.putFile(file!).then(
                            (getValue) async {
                              fileURL =
                                  await fileRef!.getDownloadURL();

                              await Databese.singUpPerent(
                                parentId: widget.parintIdController,
                                email: widget.emailController,
                                phone: widget.phoneController,
                                password: widget.passwordController,
                                childId: idController.text,
                                childName: nameController.text,
                                image: fileURL!,
                                date: birthdayController.text,
                                gender: genderController,
                                age: ageContriller,
                              );

                              await FaceRecognitionService.saveFaceData(
                                childId: idController.text,
                                childName: nameController.text,
                                faceFeatures: faceFeatures!,
                              );

                              await SignUp(widget.emailController,
                                  widget.passwordController);

                              Navigator.pop(context);
                              showMessaage(
                                  'Your data have been saved successfully',
                                  false);
                            },
                          );
                        }
                      },
                      backgroundColor: const Color.fromARGB(255, 44, 151, 165),
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

  Future selactPicture() async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['png', 'jpg', 'jpeg']);
    if (pickedFile == null) return null;
    setState(() {
      file = File(pickedFile.paths.first!);
    });
  }

  void onTapDate() async {
    FocusScope.of(context).unfocus();
    DateTime? datePicker = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime.now());
    if (datePicker != null) {
      setState(() {
        birthdayController.text =
            '${datePicker.day}-${datePicker.month}-${datePicker.year}';
      });
    }
  }

  showMessaage(String title, bool show) {
    return showDialog(
        context: context,
        builder: (con) {
          return Center(
            child: AlertDialog(
              title: Center(child: text(context, title, 15, Colors.black)),
              content: show
                  ? SizedBox(
                      height: 50.h,
                      width: 50.w,
                      child:
                          const Center(child: CircularProgressIndicator()))
                  : null,
            ),
          );
        });
  }
}
