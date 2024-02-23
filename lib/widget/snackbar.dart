import 'package:flutter/material.dart';

class ShowSnackBar {
  final BuildContext context;
  final String message;
  ShowSnackBar({required this.context,required this.message}) {
    final snackBar = SnackBar(
      content: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(13),
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Text(message, style: const TextStyle(color: Colors.white)),
      ),
      backgroundColor: Colors.white,
      behavior: SnackBarBehavior.fixed,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
