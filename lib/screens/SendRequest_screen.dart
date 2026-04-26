
import 'package:app/home_page.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class SendRequest extends StatefulWidget {
  const SendRequest({Key? key}) : super(key: key);

  @override
  State<SendRequest> createState() => _SendRequest();
}

class _SendRequest extends State<SendRequest> {
  TextEditingController idController = TextEditingController();
  GlobalKey<FormState> addKey = GlobalKey();
  List<String> TimePeriod = ["5 Min", "10 Min", "15 Min"];
  String? type;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
  } 

  String? valuedId(value) {
  if (value.trim().isEmpty) {
    return 'please fill this feild';
  }

  if (value.length != 10) {
    return "Must be 10 digits";
  }
  return null;
}

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
            Navigator.of(context).pushReplacementNamed('ParentPage');
          },
          )
          ),
          body: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.0.w, vertical: 0.h),
              child: SingleChildScrollView(
                child: Form(
                  key: addKey,
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 240.h,
                      ),

//============================== ID textField===============================================================
                      textField(context, Icons.numbers, "Child ID", false,
                          idController, valuedId,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ]),
                      SizedBox(
                        height: 20.h,
                      ),
//==============================department textField===============================================================
                      menu(context, "Choose time period", Icons.timer, 16,
                          TimePeriod, (v) {
                        setState(() {
                          type = v;
                        });
                      }, (v) {
                        if (v == null) {
                          return "Yon need to choose one";
                        } else {
                          return null;
                        }
                      }),
                      SizedBox(
                        height: 60.h,
                      ),
//==============================add ===============================================================

                      bottom(
                        context,
                        "Send Request",
                        Colors.black,
                        () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (addKey.currentState?.validate() == true) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()));
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

//Drow Textfield===============================================================
  Widget textField(context, icons, String key, bool hintPass,
      TextEditingController myController, myValued,
      {Widget? suffixIcon,
      fillColor,
      void Function()? onTap,
      List<TextInputFormatter>? inputFormatters,
      TextInputType? keyboardType,
      hintText}) {
    return TextFormField(
      obscureText: hintPass,
      validator: myValued,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onTap: onTap,
      autofocus: false,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      controller: myController,
      style: TextStyle(
        color: Colors.black,
        fontSize: 15.sp,
      ),
      decoration: InputDecoration(
          isDense: true,
          filled: true,
          suffixIcon: suffixIcon,
          hintStyle: TextStyle(
            color: Colors.black,
            fontSize: 15.sp,
          ),
          fillColor: fillColor ?? Colors.grey[100],
          labelStyle: TextStyle(
            color: Colors.black,
            fontSize: 15.sp,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.r),
            borderSide: BorderSide(
              color: Colors.grey[100]!,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.r),
            borderSide: BorderSide(
              color: Colors.grey[100]!,
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.r),
            borderSide: BorderSide(
              color: Colors.grey[100]!,
              width: 1.0,
            ),
          ),
          prefixIcon: Icon(icons, color: Colors.black, size: 15.sp),
          labelText: key,
          hintText: hintText,
          errorStyle: TextStyle(color: Colors.red, fontSize: 13.0.sp),
          contentPadding: EdgeInsets.all(10.h)),
    );
  }

//Drow menu===============================================================
  Widget menu(
      context,
      String inisValue,
      IconData prefixIcon,
      double fontSize,
      List<String> item,
      void Function(String?)? onChanged,
      String? Function(String?)? validator,
      {double width = double.infinity}) {
    return DropdownButtonFormField2<String>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      hint: text(context, inisValue, fontSize, Colors.black),
      items: item
          .map((type) => DropdownMenuItem(
                alignment: Alignment.centerLeft,
                value: type,
                child: text(context, type, fontSize, Colors.black),
              ))
          .toList(),
      decoration: InputDecoration(
          isDense: true,
          filled: true,
          prefixIcon: Icon(
            prefixIcon,
            color: Colors.black,
          ),
          fillColor: Colors.grey[100]!,
          alignLabelWithHint: true,
          errorStyle: TextStyle(color: Colors.red, fontSize: 14.0.sp),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.r),
            borderSide: BorderSide(
              color: Colors.grey[100]!,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.r),
            borderSide: BorderSide(
              color: Colors.grey[100]!,
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.r),
            borderSide: BorderSide(
              color: Colors.grey[100]!,
              width: 1.0,
            ),
          ),
          contentPadding: EdgeInsets.all(10.h)),
      onChanged: onChanged,
      dropdownMaxHeight: 120.h,
      dropdownWidth: 230.w,
      dropdownDecoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(4.r))),
      iconDisabledColor: Colors.black,
      iconEnabledColor: Colors.black,
      scrollbarAlwaysShow: true,
    );
  }

//========================================================================
  Widget bottom(context, String key, Color textColor, onPressed,
      {Color backgroundColor = Colors.transparent,
      double horizontal = 0.0,
      double vertical = 2.0,
      double height = 55,
      double width = double.infinity,
      fontWeight = FontWeight.normal,
      double evaluation = 0.0}) {
    return SizedBox(
      height: height.h,
      width: width,
      child: TextButton(
        onPressed: onPressed,
        child: text(context, key, 13.sp, textColor, fontWeight: FontWeight.bold),
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(evaluation),
          backgroundColor: MaterialStateProperty.all(backgroundColor),
          foregroundColor: MaterialStateProperty.all(textColor),
          padding: MaterialStateProperty.all(EdgeInsets.symmetric(
              horizontal: horizontal.w, vertical: vertical.h)),
        ),
      ),
    );
  }

//=============================================================
  Widget text(context, String key, double fontSize, Color color,
      {String? family,
      align = TextAlign.right,
      double space = 0,
      FontWeight fontWeight = FontWeight.normal,
      decoration = TextDecoration.none}) {
    return Text(
      key,
      textAlign: align,
      //softWrap: false,
      style: TextStyle(
        color: color,
        //overflow: TextOverflow.ellipsis,
        fontStyle: FontStyle.normal,
        decoration : decoration,
        fontSize: 15.sp,
        letterSpacing: space.sp,
        fontWeight: fontWeight,
        
      ),
    );
  }

//==================================================================
  String? manditary(value) {
    if (value.isEmpty) {
      return "youn need to choose one";
    }
    return null;
  }

  String? notManditary(value) {
    return null;
  }
}

//======================================
