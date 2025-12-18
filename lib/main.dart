import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/study_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const StudyApp());
}

class StudyApp extends StatelessWidget {
  const StudyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StudyProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Study GPT',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF0A0A0A),
          primaryColor: Colors.deepPurpleAccent,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme).apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
          colorScheme: const ColorScheme.dark(
            primary: Colors.deepPurpleAccent,
            secondary: Colors.deepPurpleAccent,
            surface: Color(0xFF1E1E1E),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
