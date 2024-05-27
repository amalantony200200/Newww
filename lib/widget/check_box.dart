import 'package:flutter/material.dart';
import 'package:malabar_mess_app/constant.dart';

Widget checkBox(String label,bool value,Function fun){
  return Row(
    children: [
      Checkbox(
        value: value,
        activeColor: BUTTON_COLOR,
        side: const BorderSide(color: BUTTON_COLOR,width: 2.0),
        onChanged: (changed){
          fun(changed);
        }
      ),
      Text(label,style: const TextStyle(color: BUTTON_COLOR,fontWeight: FontWeight.bold)),
    ],
  );
}