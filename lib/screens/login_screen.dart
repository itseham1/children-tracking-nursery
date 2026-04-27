import 'package:app/screens/admin_screen.dart';
import 'package:app/screens/forgot_pass_screen.dart';
import 'package:app/screens/parent_screen.dart';
import 'package:app/screens/signup1_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _fromKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty || !value.contains('@')) {
          return "Please Enter Your Email!";
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+[a-z]").hasMatch(value)) {
          return "Please Enter a valid Email";
        }
        return null;
      },
      onSaved: (value) => emailController.text.trim(),
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email_outlined),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        labelText: 'Email',
        labelStyle: GoogleFonts.robotoCondensed(fontSize: 20),
        hintText: "Enter your Email",
        hintStyle: GoogleFonts.robotoCondensed(fontSize: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty) return "Password is required for login!";
        if (value.length < 6) return "Please Enter Valid Password (Min. 6 Characters)";
        return null;
      },
      onSaved: (value) => passwordController.text.trim(),
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        labelText: 'Password',
        labelStyle: GoogleFonts.robotoCondensed(fontSize: 20),
        hintText: "Enter your Password",
        hintStyle: GoogleFonts.robotoCondensed(fontSize: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    final loginButton = Material(
      borderRadius: BorderRadius.circular(12),
      color: const Color(0xffa7dae1),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: _isLoading ? null : () => signIn(emailController.text, passwordController.text),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.black)
            : Text(
                "LOG IN",
                style: GoogleFonts.robotoCondensed(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        leading: TextButton.icon(
          onPressed: () => SystemNavigator.pop(),
          icon: const Icon(Icons.cancel_presentation_sharp, color: Colors.black),
          label: const Text(""),
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _fromKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 230,
                      child: Image.asset("images/nurse.jpg", fit: BoxFit.contain),
                    ),
                    const SizedBox(height: 25),
                    emailField,
                    const SizedBox(height: 15),
                    passwordField,
                    const SizedBox(height: 25),
                    loginButton,
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: GoogleFonts.robotoCondensed(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 3),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SingUp1()),
                          ),
                          child: Text(
                            "SignUp",
                            style: GoogleFonts.robotoCondensed(
                              fontSize: 19,
                              color: Colors.blue[200],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgetPasswordPage()),
                      ),
                      child: Text(
                        "Forgot Password",
                        style: GoogleFonts.robotoCondensed(
                          fontSize: 19,
                          color: Colors.blue[200],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  void signIn(String email, String password) async {
    if (_fromKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        // تسجيل الدخول عبر Firebase Auth
        await _auth.signInWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );

        // التحقق إذا كان أدمن — نقارن الإيميل بحقل email فقط
        final adminDoc = await _firestore
            .collection('Admin')
            .doc('Admin1U')
            .get();

        if (adminDoc.exists && adminDoc.data()?['email'] == email.trim()) {
          // هو أدمن
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => AdminScreen()),
            );
          }
        } else {
          // تحقق إنه موجود في Users
          final userSnapshot = await _firestore
              .collection('Users')
              .where('email', isEqualTo: email.trim())
              .get();

          if (userSnapshot.docs.isNotEmpty) {
            // هو أحد الأهل
            if (mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => ParentPage()),
              );
            }
          } else {
            _showError('No account found for this email.');
          }
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          _showError('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          _showError('Wrong password. Please try again.');
        } else {
          _showError('Login failed. Please try again.');
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Login Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
