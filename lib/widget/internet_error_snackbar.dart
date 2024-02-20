
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:malabar_mess_app/screen/home_screen.dart';


class InternetConnectionCheck {
  static Future<void> internetCheck(BuildContext context) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    } on SocketException catch (_) {
        showInternetErrorSnackBar(context);
    }
  }
}
void showInternetErrorSnackBar(BuildContext context) {
    String message = "Internet connection required";
    final snackBar = SnackBar(
      content: Text(message,style: const TextStyle(color: Colors.black)),
      backgroundColor: Colors.white,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 300),
      action: SnackBarAction(
        label: "Retry",
        onPressed: (){
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          InternetConnectionCheck.internetCheck(context);
        }
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }