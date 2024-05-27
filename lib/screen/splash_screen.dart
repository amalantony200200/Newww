import 'dart:async';
import 'package:flutter/material.dart';
import 'package:malabar_mess_app/repo/get_database_data.dart';
import 'package:malabar_mess_app/screen/home_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late BuildContext ctx;
  @override
  initState(){
    super.initState();
    GetDatabaseData obj = GetDatabaseData();
    obj.getAllMembersDocs();
    Timer(const Duration(seconds: 3), () async {
      await obj.getAllMembersDocs();
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  HomeScreen()));
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