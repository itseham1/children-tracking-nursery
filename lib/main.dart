import 'package:app/auth.dart';
import 'package:app/screens/SendRequest_screen.dart';
import 'package:app/screens/admin_screen.dart';
import 'package:app/screens/login_screen.dart';
import 'package:app/screens/parent_screen.dart';
import 'package:app/screens/parentsProfile_screen.dart';
import 'package:app/screens/signup1_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(413, 763),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          builder: (context, widget) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: widget!,
            );
          },
          routes: {
            '/': (context) => const Auth(),
            'loginScreen': (context) => const LoginScreen(),
            'signupScreen': (context) => const SingUp1(),
            'AdminScreen': (context) => AdminScreen(),
            'ParentsProfiles': (context) => const ParentsProfiles(),
            'ParentPage': (context) => ParentPage(),
            'SendRequest': (context) => const SendRequest(),
          },
        );
      },
    );
  }
}
