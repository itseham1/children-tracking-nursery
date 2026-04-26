import 'package:app/screens/admin_screen.dart';
import 'package:app/screens/forgot_pass_screen.dart';
import 'package:app/screens/parent_screen.dart';
import 'package:app/screens/signup1_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';




class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /////////form key//////////
  final _fromKey = GlobalKey<FormState>();
  final _firestor = FirebaseFirestore.instance;
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  //////////firebase/////////
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    ////////// email feild //////////
    final emailField = TextFormField(
        autofocus: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          //|| !value.contains('.com'))
          if (value!.isEmpty || !value.contains('@')) {
            return ("Please Enter Your Email!");
          }
          ////////// reg expression for Email validator /////////
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid Email");
          }
          return null;
        },
        onSaved: (value) {
          emailController.text.trim();
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.email_outlined),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          labelText: 'Email',
          labelStyle: GoogleFonts.robotoCondensed(fontSize: 20),
          hintText: "Enter your Email",
          hintStyle: GoogleFonts.robotoCondensed(fontSize: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

//////////password feild/////////
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      validator: (value) {
        RegExp regx = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for login!");
        }
        if (!regx.hasMatch(value)) {
          return ("Please Enter Valid Password(Min.8 Character");
        }
      },
      onSaved: (value) {
        passwordController.text.trim();
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        labelText: 'Password',
        labelStyle: GoogleFonts.robotoCondensed(fontSize: 20),
        hintText: "Enter your Password",
        hintStyle: GoogleFonts.robotoCondensed(fontSize: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    //////////login button//////////

    final loginButton = Material(
      borderRadius: BorderRadius.circular(12),
      color: Color(0xffa7dae1),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signIn(emailController.text, passwordController.text);
        },
        child: Text(
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
          onPressed: () {
            SystemNavigator.pop();
          },
          icon: Icon(
            Icons.cancel_presentation_sharp,
            color: Colors.black,
          ),
          label: Text(""),
        ),
      ),
      //bottomNavigationBar: ,
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
                  children: <Widget>[
                    SizedBox(
                      height: 230,
                      child: Image.asset(
                        "images/nurse.jpg",
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 25),
                    emailField,
                    SizedBox(height: 15),
                    passwordField,
                    SizedBox(height: 25),
                    loginButton,
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don’t hava an account?",
                          style: GoogleFonts.robotoCondensed(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 3),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SingUp1()));
                          },
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
                    SizedBox(height: 15),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ForgetPasswordPage();
                            },
                          ),
                        );
                      },
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

  void signIn(String _email, String _password) async {
    if (_fromKey.currentState!.validate()) {
      try {
        var _user = await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);

       if (_user != null) {
          var query = await _firestor
              .collection('Admin')
              .doc("Admin1U")
              .get()
              .then((value) async {
            var _userData = value.data();

           for (var element in _userData!.values) {
              if (element == _email) {
                //Fluttertoast.showToast(msg: "Login Successful");
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => AdminScreen(
                        )));
                break;
              } else {
                //Fluttertoast.showToast(msg: "Login Successful");
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => ParentPage()));
              }
            }
          });
        } 
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("user-not-found"),
                  content: Text("'No user found for that email.'"),
                );
              });
        }
      }
    }
  }
}