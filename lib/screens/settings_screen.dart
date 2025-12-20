import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/study_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudyProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Text(
            'Daily Goal',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Target Hours',
                      style: GoogleFonts.poppins(color: Colors.grey),
                    ),
                    Text(
                      '${provider.targetHours.toStringAsFixed(1)}h',
                      style: GoogleFonts.poppins(
                        color: Colors.deepPurpleAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: provider.targetHours,
                  min: 1.0,
                  max: 12.0,
                  divisions: 22,
                  activeColor: Colors.deepPurpleAccent,
                  inactiveColor: Colors.grey[800],
                  onChanged: (value) {
                    provider.setTargetHours(value);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Data Management',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
              title: Text(
                'Clear All Data',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              subtitle: Text(
                'Reset sessions, modules, and settings',
                style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
              ),
              onTap: () => _showClearDataDialog(context, provider),
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: Text(
              'StudyTimeOptimizer v1.0.0',
              style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context, StudyProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Text(
          'Clear Data?',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        content: Text(
          'This action cannot be undone. All your study sessions and modules will be permanently deleted.',
          style: GoogleFonts.poppins(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: GoogleFonts.poppins(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              provider.clearData();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'All data cleared',
                    style: GoogleFonts.poppins(),
                  ),
                  backgroundColor: Colors.redAccent,
                ),
              );
            },
            child: Text(
              'Clear',
              style: GoogleFonts.poppins(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}
