import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zubimovie/screens/splash_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData baseDark = ThemeData.dark();

    return MaterialApp(
      title: 'ZubiMovie',
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      theme: baseDark.copyWith(
        textTheme: GoogleFonts.ptSansTextTheme(baseDark.textTheme).copyWith(
          bodyLarge: const TextStyle(color: Colors.white, fontSize: 24),
          bodyMedium: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)
            .copyWith(surface: Colors.black),
      ),
      home: SplashScreen(),
    );
  }
}
