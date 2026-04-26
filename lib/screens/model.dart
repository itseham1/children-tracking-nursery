import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';







String emptyData='Empty Data';
String emailInvalid='The email is invalid , you need @ and .com';
String passwordlInvalid='The Password is invalid';
String? valuedEmile(value) {
  if (value.trim().isEmpty) {
    return emptyData;
  }

  if (EmailValidator.validate(value.trim()) == false) {
    return emailInvalid;
  }
  return null;
}

///////////////////////////////////////////////////////////////////////
String? valuedPass(value) {
  // String pattern =
  //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[-_!%*&^$#?@]).{0,}$';
  // RegExp regExp = RegExp(pattern);
  if (value.trim().isEmpty) {
    return emptyData;
  }
  // if (regExp.hasMatch(value) == false) {
  //   return passwordlInvalid;
  // }

  if (value.length < 8) {
    return "At least 8 digit";
  }

  return null;
}

/////////////////////////////////////////////////////
String? valuedPhone(value) {
  if (value.trim().isEmpty) {
    return emptyData;
  }
  if (!(value.startsWith('05'))) {
    return "Must start with 05";
  }
  if (value.length != 10) {
    return "Must be 10 digits";
  }
  return null;
}

///////////////////////////////////////////////////////////
String? valuedId(value) {
  if (value.trim().isEmpty) {
    return emptyData;
  }

  if (value.length != 10) {
    return "Must be 10 digits";
  }
  return null;
}


Widget textField(context, icons, String key, bool hintPass,
      TextEditingController myController, myValued,
      {Widget? suffixIcon,
      fillColor,
      void Function()? onTap,
      List<TextInputFormatter>? inputFormatters,
      TextInputType? keyboardType,
      hintText,}) {
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
        color: Colors.grey[700]!,
        fontSize: 15.sp,
      ),
      decoration: InputDecoration(
          isDense: true,
          filled: true,
          suffixIcon: suffixIcon,
          hintStyle: TextStyle(
            color: Colors.grey[700]!,
            fontSize: 15.sp,
          ),
          fillColor: fillColor ?? Colors.grey[100],
          labelStyle: TextStyle(
            color: Colors.grey[700]!,
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
          prefixIcon: Icon(icons, color: Colors.black, size: 25.sp),
          labelText: key,
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
      hint: text(context, inisValue, fontSize, Colors.grey[700]!),
      items: item
          .map((type) => DropdownMenuItem(
                alignment: Alignment.centerLeft,
                value: type,
                child: text(context, type, fontSize, Colors.grey[700]!),
              ))
          .toList(),
      decoration: InputDecoration(
          isDense: false,
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
      dropdownMaxHeight: 140.h,
      dropdownWidth: 250.w,
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
      double vertical = 0.0,
      double height = 55,
      double width = double.infinity,
      fontWeight = FontWeight.normal,
      double evaluation = 0.0}) {
    return SizedBox(
      height: height.h,
      width: width,
      child: TextButton(
        onPressed: onPressed,
        child: text(context, key, 15.sp, textColor, fontWeight: fontWeight),
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
        fontFamily: family,
        decoration: decoration,
        fontSize: fontSize.sp,
        letterSpacing: space.sp,
        fontWeight: fontWeight,
      ),
    );
  }

//==================================================================
  String? manditary(value) {
    if (value.isEmpty) {
      return "You need to complete this field";
    }
    return null;
  }

  String? notManditary(value) {
    return null;
  }