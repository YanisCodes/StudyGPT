import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/study_provider.dart';
import 'session_screen.dart';

class SessionSetupScreen extends StatefulWidget {
  const SessionSetupScreen({super.key});

  @override
  State<SessionSetupScreen> createState() => _SessionSetupScreenState();
}

class _SessionSetupScreenState extends State<SessionSetupScreen> {
  final TextEditingController _moduleController = TextEditingController();

  @override
  void dispose() {
    _moduleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudyProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Session Setup",
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fatigue Section
            Text(
              "How tired are you?",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "We'll adjust your study intervals based on your energy level.",
              style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Fresh", style: TextStyle(color: Colors.green)),
                Text("${provider.fatigue.round()}%", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const Text("Exhausted", style: TextStyle(color: Colors.red)),
              ],
            ),
            Slider(
              value: provider.fatigue,
              min: 0,
              max: 100,
              activeColor: Colors.deepPurpleAccent,
              inactiveColor: Colors.white10,
              onChanged: (value) {
                provider.setFatigue(value);
              },
            ),

            const SizedBox(height: 30),

            // Modules Section
            Text(
              "What are you studying?",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _moduleController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Enter subject (e.g. Math)",
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFF16161E),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    if (_moduleController.text.isNotEmpty) {
                      provider.addModule(_moduleController.text);
                      _moduleController.clear();
                    }
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: provider.modules.map((module) {
                final isSelected = provider.selectedModule == module;
                return FilterChip(
                  label: Text(module),
                  selected: isSelected,
                  onSelected: (selected) {
                    provider.selectModule(module);
                  },
                  backgroundColor: const Color(0xFF16161E),
                  selectedColor: Colors.deepPurpleAccent.withValues(alpha: 0.3),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.deepPurpleAccent : Colors.white,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected ? Colors.deepPurpleAccent : Colors.white10,
                    ),
                  ),
                  onDeleted: () => provider.removeModule(module),
                  deleteIconColor: Colors.grey,
                );
              }).toList(),
            ),

            const SizedBox(height: 40),

            // AI Recommendation
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF16161E),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.deepPurpleAccent.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.auto_awesome, color: Colors.deepPurpleAccent),
                      const SizedBox(width: 10),
                      Text(
                        "AI Recommendation",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildTimeRow("Study Duration", "${provider.calculatedStudyMinutes} min"),
                  const SizedBox(height: 10),
                  _buildTimeRow("Break Duration", "${provider.calculatedBreakMinutes} min"),
                ],
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: provider.modules.isEmpty
                    ? null
                    : () {
                        if (provider.selectedModule == null) {
                          // Auto select first if none selected
                          provider.selectModule(provider.modules.first);
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SessionScreen()),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  disabledBackgroundColor: Colors.grey.withValues(alpha: 0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  "Start Session",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRow(String label, String time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(color: Colors.grey),
        ),
        Text(
          time,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
