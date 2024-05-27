import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

PreferredSize appBar() {
  return PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF3366FF), // Start color
                Color(0xFF00CCFF), // End color
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            title: Text('Malabar Mess', style: GoogleFonts.poppins()),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      );
}
