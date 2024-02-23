import 'package:flutter/material.dart';
import 'package:malabar_mess_app/widget/app_bar.dart';

class CountScreen extends StatelessWidget {
  const CountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(),
        body: Column(
          children: [
            MaterialButton( onPressed:  () => print("dsaf"),child: Text("count Button")),
          ],
        ),
    );
  }
}