import 'dart:async';
import 'package:flutter/material.dart';
import 'package:malabar_mess_app/widget/internet_error_snackbar.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();

  
}

class _SplashScreenState extends State<SplashScreen> {
  late BuildContext ctx;
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () async {
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  LockApp()));
      await InternetConnectionCheck.internetCheck(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: const Color.fromARGB(31, 134, 128, 128),
      body: Container(
        alignment: Alignment.center,
        child: Image.asset("assets/malabarmess_logo.png"),
      ),
    );
  }
}