import 'package:flutter/material.dart';

Widget textFormField(TextEditingController textController,String label,TextInputType keyboard, String? Function(dynamic value) param3){
  return TextFormField(
    
    //initialValue: "hhfg",
    controller: textController,
    validator: (value) =>(value == null || value.isEmpty) ? "Enter $label" : null,
    keyboardType: keyboard,
    cursorColor: Colors.black,
    style: const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Colors.black,
      ),
      fillColor: Colors.white,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: const BorderSide(
          color: Colors.black,
          width: 2.0
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: const BorderSide(
          color: Colors.black,
          width: 2.0,
        ),
      ),
    ),
  );
}