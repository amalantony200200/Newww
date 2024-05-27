import 'package:flutter/material.dart';
import 'package:malabar_mess_app/constant.dart';

Widget elevatedButton(Function fun,String message,Widget icon){
  return ElevatedButton.icon(
    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(BUTTON_COLOR)),
    onPressed: ()async{
     await fun();
    },
    label: Text(message, style: const TextStyle(color: Colors.white),),
    icon: icon,
  );
}