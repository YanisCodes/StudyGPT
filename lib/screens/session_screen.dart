import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/study_provider.dart';

class SessionScreen extends StatefulWidget {
  const SessionScreen({super.key});

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  @override
  void initState() {
    super.initState();
    // Start the session when the screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StudyProvider>(context, listen: false).startSession();
    });
  }

  String _formatTime(int seconds) {
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return "${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudyProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            provider.stopTimer();
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              provider.isBreak ? "PAUSE" : "FOCUS",
              style: GoogleFonts.poppins(
                color: provider.isBreak ? Colors.greenAccent : Colors.deepPurpleAccent,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              provider.selectedModule ?? "Session",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 50),
            
            CircularPercentIndicator(
              radius: 140.0,
              lineWidth: 15.0,
              percent: provider.progress,
              center: Text(
                _formatTime(provider.secondsRemaining),
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              progressColor: provider.isBreak ? Colors.greenAccent : Colors.deepPurpleAccent,
              backgroundColor: Colors.white10,
              circularStrokeCap: CircularStrokeCap.round,
              animation: true,
              animateFromLastPercent: true,
            ),

            const SizedBox(height: 60),

            // Controls
            if (provider.secondsRemaining == 0) ...[
               ElevatedButton(
                onPressed: () {
                  if (provider.isBreak) {
                    provider.startSession();
                  } else {
                    provider.startBreak();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Text(
                  provider.isBreak ? "Reprendre le travail" : "Prendre une pause",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
              ),
            ] else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 60,
                    icon: Icon(
                      provider.isRunning ? Icons.pause_circle_filled : Icons.play_circle_fill,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (provider.isRunning) {
                        provider.pauseTimer();
                      } else {
                        provider.resumeTimer();
                      }
                    },
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
