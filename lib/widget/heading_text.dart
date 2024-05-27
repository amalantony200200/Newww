import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:malabar_mess_app/constant.dart';

Widget headingText(String str){
  return Text(
    str,
    textAlign: TextAlign.start,
    style: GoogleFonts.sofiaSansCondensed(
       color: HEADING_TEXT_COLOR,
       fontSize: HEADING_TEXT_FONT_SIZE,
       fontWeight: FontWeight.bold,
    ),
  );
}
Widget extendsPageText(String str){
  return Text(
    str,
    textAlign: TextAlign.start,
    style: GoogleFonts.sofiaSansCondensed(
       color: HEADING_TEXT_COLOR,
       fontSize: 25,
       fontWeight: FontWeight.normal,
    ),
  );
}