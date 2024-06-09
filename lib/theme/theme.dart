import 'package:generation_quiz_app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData appTheme = ThemeData(
  primarySwatch: Colors.indigo,
  hintColor: Colors.orangeAccent,
  textTheme: GoogleFonts.latoTextTheme(),
  cardTheme: CardTheme(
    margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    elevation: 5.0,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFBBADA0),
      //   onPrimary: Colors.white

      textStyle: const TextStyle(fontSize: 16),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: primaryColor,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
);

const BoxDecoration backgroundDecoration = BoxDecoration(color: backgroundColor
    // gradient: LinearGradient(
    //   colors: [Colors.indigo.shade200, Colors.indigo.shade800],
    //   begin: Alignment.topCenter,
    //   end: Alignment.bottomCenter,
    // ),
    );
