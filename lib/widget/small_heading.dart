import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget smallHeading({required String str}){
   return Text(
    str,
    textAlign: TextAlign.start,
    style: GoogleFonts.sofiaSansCondensed(
       color: Colors.black,
       fontSize: 25,
       fontWeight: FontWeight.bold,
    ),
  );
}