import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

AppBar appBar() {
  return AppBar(
    backgroundColor: Colors.black,
    title: Text(
      "Malabar Mess",
      style: GoogleFonts.sofiaSansCondensed(
          color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),
    ),
    centerTitle: true,
  );
}
