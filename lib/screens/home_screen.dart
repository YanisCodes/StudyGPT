import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/study_provider.dart';
import '../widgets/dashboard_widgets.dart';
import 'modules_screen.dart';
import 'session_setup_screen.dart';
import 'stats_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardView(),
    const ModulesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: const Color(0xFF0A0A0A),
        selectedItemColor: Colors.deepPurpleAccent,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded),
            label: 'Modules',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SessionSetupScreen()),
          );
        },
        backgroundColor: Colors.deepPurpleAccent,
        child: const Icon(Icons.play_arrow_rounded, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudyProvider>(context);
    final hoursStudied = provider.hoursStudiedToday;
    final weeklyProgress = provider.last7DaysHours;
    final targetHours = provider.targetHours;
    final focusScore = provider.focusScore;
    
    // Create spots for the chart
    final List<FlSpot> spots = [];
    for (int i = 0; i < weeklyProgress.length; i++) {
      spots.add(FlSpot(i.toDouble(), weeklyProgress[i]));
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome back,",
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Ready to study?",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const CircleAvatar(
                  backgroundColor: Colors.deepPurpleAccent,
                  child: Text("S", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
                children: [
                  StatCard(
                    title: "Hours Studied",
                    value: "${hoursStudied.toStringAsFixed(1)}h",
                    percentage: "Today",
                    graphColor: Colors.orange,
                    spots: spots,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StatsDetailScreen(
                            title: "Hours Studied",
                            value: "${hoursStudied.toStringAsFixed(1)}h",
                            graphColor: Colors.orange,
                            spots: spots,
                          ),
                        ),
                      );
                    },
                  ),
                  StatCard(
                    title: "Target Hours",
                    value: "${targetHours.toStringAsFixed(1)}h",
                    percentage: "${(hoursStudied / targetHours * 100).clamp(0, 100).toStringAsFixed(0)}%",
                    graphColor: Colors.deepPurpleAccent,
                    spots: const [
                      FlSpot(0, 2),
                      FlSpot(1, 2),
                      FlSpot(2, 2),
                      FlSpot(3, 2),
                      FlSpot(4, 2),
                      FlSpot(5, 2),
                      FlSpot(6, 2),
                    ],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StatsDetailScreen(
                            title: "Target Hours",
                            value: "${targetHours.toStringAsFixed(1)}h",
                            graphColor: Colors.deepPurpleAccent,
                            spots: const [
                              FlSpot(0, 2),
                              FlSpot(1, 2),
                              FlSpot(2, 2),
                              FlSpot(3, 2),
                              FlSpot(4, 2),
                              FlSpot(5, 2),
                              FlSpot(6, 2),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  StatCard(
                    title: "Focus Score",
                    value: "$focusScore%",
                    percentage: "0%",
                    graphColor: Colors.green,
                    spots: const [
                      FlSpot(0, 60),
                      FlSpot(1, 65),
                      FlSpot(2, 70),
                      FlSpot(3, 75),
                      FlSpot(4, 72),
                      FlSpot(5, 80),
                      FlSpot(6, 85),
                    ],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StatsDetailScreen(
                            title: "Focus Score",
                            value: "$focusScore%",
                            graphColor: Colors.green,
                            spots: const [
                              FlSpot(0, 60),
                              FlSpot(1, 65),
                              FlSpot(2, 70),
                              FlSpot(3, 75),
                              FlSpot(4, 72),
                              FlSpot(5, 80),
                              FlSpot(6, 85),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  StatCard(
                    title: "Weekly Progress",
                    value: "72%",
                    percentage: "10%",
                    graphColor: Colors.blue,
                    spots: const [
                      FlSpot(0, 20),
                      FlSpot(1, 30),
                      FlSpot(2, 40),
                      FlSpot(3, 50),
                      FlSpot(4, 55),
                      FlSpot(5, 65),
                      FlSpot(6, 72),
                    ],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const StatsDetailScreen(
                            title: "Weekly Progress",
                            value: "72%",
                            graphColor: Colors.blue,
                            spots: [
                              FlSpot(0, 20),
                              FlSpot(1, 30),
                              FlSpot(2, 40),
                              FlSpot(3, 50),
                              FlSpot(4, 55),
                              FlSpot(5, 65),
                              FlSpot(6, 72),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
