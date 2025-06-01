import 'package:flutter/material.dart';
import 'chatbot_hr.dart';
import 'resumescreening.dart';
import 'FeedbackAnalysisPage.dart';
import 'settings_page.dart';
import 'CalendarPage.dart';

class HREmployeePage extends StatefulWidget {
  final String userEmail;

  const HREmployeePage({super.key, required this.userEmail});

  @override
  State<HREmployeePage> createState() => _HREmployeePageState();
}

class _HREmployeePageState extends State<HREmployeePage> {
  int _selectedIndex = 0;

  String getUserName() {
    final namePart = widget.userEmail.split('@').first;
    return namePart[0].toUpperCase() + namePart.substring(1);
  }

  void _onItemTapped(int index) {
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SettingsPage(
            userName: getUserName(),
            userEmail: widget.userEmail,
            userImage: null,
          ),
        ),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _openChatbot() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChatScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userName = getUserName();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.logout, color: Colors.red),
            label: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/profile.jpg'),
                  radius: 24,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Welcome, $userName",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Text("HR Manager", style: TextStyle(color: Colors.grey)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                _buildStatBox("28", "Active Jobs", Colors.blue),
                const SizedBox(width: 12),
                _buildStatBox("156", "Applications", Colors.green),
              ],
            ),
            const SizedBox(height: 24),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                _FeatureTile(
                  icon: Icons.android,
                  title: "AI Chatbot",
                  subtitle: "Quick responses",
                  onTap: _openChatbot,
                ),
                _FeatureTile(
                  icon: Icons.description,
                  title: "Resume Screening",
                  subtitle: "Review CVs",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ResumeScreeningPage()),
                    );
                  },
                ),
                _FeatureTile(
                  icon: Icons.bar_chart,
                  title: "Feedback",
                  subtitle: "Analysis",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FeedbackAnalysisPage()),
                    );
                  },
                ),
                _FeatureTile(
                  icon: Icons.calendar_today,
                  title: "Calendar",
                  subtitle: "Schedule",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CalendarPage()),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text("Upcoming Interviews", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildInterviewTile("John Developer", "Frontend Developer", "2:30 PM", Colors.blue),
            _buildInterviewTile("Alice Designer", "UI/UX Designer", "4:00 PM", Colors.purple),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openChatbot,
        child: const Icon(Icons.chat),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Jobs'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Alerts'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }

  Widget _buildStatBox(String number, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(number, style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildInterviewTile(String name, String role, String time, Color avatarColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: avatarColor.withOpacity(0.2),
            child: Icon(Icons.person, color: avatarColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(role, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Text(time, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.blue, size: 32),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
