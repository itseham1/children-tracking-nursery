import 'package:app/screens/model.dart';
import 'package:app/screens/signup2_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';






class SingUp1 extends StatefulWidget {
  const SingUp1({super.key});

  @override
  State<SingUp1> createState() => _SingUp1State();
}

class _SingUp1State extends State<SingUp1> {
  TextEditingController parintIdController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController confPaswoordController = TextEditingController();
  GlobalKey<FormState> addKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey[300],
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () =>
                  Navigator.of(context).pushReplacementNamed('loginScreen'),
            ),
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
//==============================Parent ID textField===============================================================
                      Text(
                        'SING UP',
                        style: TextStyle(
                            fontSize: 25.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      textField(context, Icons.fingerprint, "Parent ID", false,
                          parintIdController, valuedId,
                          hintText: 'Enter Parent ID',
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ]),
                      SizedBox(
                        height: 10.h,
                      ),
//============================== Email Address textField===============================================================
                      textField(context, Icons.email, "Email Address", false,
                          emailController, valuedEmile,
                          keyboardType: TextInputType.emailAddress,
                          hintText: 'Enter Email Address',
                          inputFormatters: []),
                      SizedBox(
                        height: 10.h,
                      ),
//============================== phone textField===============================================================
                      textField(context, Icons.phone, "Phone Number", false,
                          phoneController, valuedPhone,
                          hintText: 'Enter Phone Number',
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ]),
                      SizedBox(
                        height: 10.h,
                      ),
//==============================create textField===============================================================
                      textField(
                        context,
                        Icons.lock,
                        "Create Password",
                        false,
                        confPaswoordController,
                        valuedPass,
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),

//==============================password===============================================================
                      textField(
                        context,
                        Icons.lock,
                        "Confirm Password",
                        false,
                        passwordController,
                        (v) {
                          if (v.toString() != confPaswoordController.text) {
                            return 'Password not match';
                          } else {}
                        },
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),

//==============================add ===============================================================

                      bottom(
                        context,
                        "Next",
                        Colors.black,
                        () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (addKey.currentState?.validate() == true) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => page_SignUp2(
                                          emailController: emailController.text,
                                          parintIdController:
                                              parintIdController.text,
                                          passwordController:
                                              passwordController.text,
                                          phoneController: phoneController.text,
                                        )));
                          }
                        },
                        backgroundColor: const Color(0xffa7dae1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}