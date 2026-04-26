import 'dart:io';

import 'package:app/screens/Database.dart';
import 'package:app/screens/model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;






class page_SignUp2 extends StatefulWidget {
  final String parintIdController;
  final String phoneController;
  final String passwordController;
  final String emailController;

  const page_SignUp2(
      {Key? key,
      required this.parintIdController,
      required this.phoneController,
      required this.passwordController,
      required this.emailController})
      : super(key: key);

  @override
  State<page_SignUp2> createState() => _page_SignUp2State();
}

class _page_SignUp2State extends State<page_SignUp2> {
  TextEditingController nameController = TextEditingController();
  TextEditingController pictureController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController idController = TextEditingController();
  GlobalKey<FormState> addKey = GlobalKey();
  String? fileURL;
  Reference? fileRef;
  File? file;
  List<String> gander = ["Male", "Female"];
  List<String> age = ["1-6 month", "6-12 month", "1-2 year", "2-3 year"];
  String? type;
  String passowrd = '';
  String ageContriller = '';
  String genderController = '';

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
  }

  final _passwordController = TextEditingController();

  Future SignUp(String _email, String _pass) async {
    print("Sing Up");
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _email.trim(),
      password: _pass.trim(),
    );
    Navigator.of(context).pushReplacementNamed('/');
  }

 // Future Sign() async {
   // await FirebaseAuth.instance.signInWithEmailAndPassword(
     //   email: emailController.text, password: _passwordController.text);
  //}

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey[300],
            leading: GestureDetector(
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
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
              padding: EdgeInsets.symmetric(horizontal: 15.0.w, vertical: 0.h),
              child: SingleChildScrollView(
                child: Form(
                  key: addKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 100.h,
                      ),
//==============================name textField===============================================================
                      Text(
                        'SING UP',
                        style: TextStyle(
                            fontSize: 25.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      textField(context, Icons.child_care, "Child Name", false,
                          nameController, manditary,
                          hintText: 'Please Enter Engilsh characters only',
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-z]|[A-Z]|[ا-ي]')),
                          ]),
                      SizedBox(
                        height: 10.h,
                      ),
//============================== ID textField===============================================================
                      textField(context, Icons.numbers, "Child ID", false,
                          idController, valuedId,
                          keyboardType: TextInputType.number,
                          hintText: 'Please Enter numbers only',
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ]),
                      SizedBox(
                        height: 10.h,
                      ),
//============================== Picture textField===============================================================
                      textField(
                          context,
                          Icons.photo_size_select_actual_rounded,
                          "Child Picture",
                          false,
                          pictureController,
                          manditary, onTap: () {
                        setState(() {
                          selactPicture().whenComplete(() {
                            pictureController.text = path.basename(file!.path);
                          });
                        });
                      }),
                      SizedBox(
                        height: 10.h,
                      ),
//==============================Birthday===============================================================
                      textField(
                          context,
                          Icons.date_range_rounded,
                          "Child Birthdate",
                          false,
                          birthdayController,
                          manditary,
                          keyboardType: TextInputType.number,
                          onTap: onTapDate),
                      SizedBox(
                        height: 10.h,
                      ),
//==============================Gender textField===============================================================
                      menu(context, "Child Gender", Icons.category, 15, gander,
                          (v) {
                        setState(() {
                          genderController = v!;
                        });
                      }, (v) {
                        if (v == null) {
                          return "please choose one";
                        } else {
                          return null;
                        }
                      
                      }),
                      SizedBox(
                        height: 10.h,
                      ),
//==============================Age textField===============================================================
                      menu(
                          context,
                          "Child Age",
                          Icons.airline_seat_individual_suite_rounded,
                          14,
                          age, (v) {
                        setState(() {
                          ageContriller = v!;
                        });
                      }, (v) {
                        if (v == null) {
                          return "please choose one";
                        } else {
                          return null;
                        }
                      }),
                      SizedBox(
                        height: 40.h,
                      ),
//==============================add ===============================================================

                      bottom(
                        context,
                        "Sign Up",
                        Colors.red,
                        () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (addKey.currentState?.validate() == true) {
                            showMessaage('', true);
                            fileRef = FirebaseStorage.instance
                                .ref('image')
                                .child(pictureController.text);
                            await fileRef
                                ?.putFile(file!)
                                .then((getValue) async {
                              fileURL = await fileRef!.getDownloadURL();
                              Databese.singUpPerent(
                                      parentId: widget.parintIdController,
                                      email: widget.emailController,
                                      phone: widget.phoneController,
                                      password: widget.passwordController,
                                      childId: idController.text,
                                      childName: nameController.text,
                                      image: fileURL!,
                                      date: birthdayController.text,
                                      gender: genderController,
                                      age: ageContriller)
                                  .then((value) {
                                this.SignUp(widget.emailController,
                                    widget.passwordController);
                                Navigator.pop(context);
                                showMessaage(
                                    'Your data have been saved successfully', false);
                                print(value);
                              });
                            });
                          }
                        },
                        backgroundColor: Color.fromARGB(255, 44, 151, 165),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }

//==========================================================
  Future selactPicture() async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['png', 'jpg', 'jpeg']);
    if (pickedFile == null) {
      return null;
    }
    setState(() {
      file = File(pickedFile.paths.first!);
    });
  }

//=show date picker=======================================================
  void onTapDate() async {
    FocusScope.of(context).unfocus();
    DateTime? datePicker = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime.now());
    setState(() {
      if (datePicker != null) {
        birthdayController.text =
            '${datePicker.day}-${datePicker.month}-${datePicker.year}';
      }
    });
  }

  showMessaage(String title, bool show) {
    return showDialog(
        context: context,
        builder: (con) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AlertDialog(
                  title: Center(child: text(context, title, 15, Colors.black)),
                  content: show
                      ? SizedBox(
                          height: 50.h,
                          width: 50.w,
                          child: Center(child: CircularProgressIndicator()))
                      : null,
                ),
              ],
            ),
          );
        });
  }
}