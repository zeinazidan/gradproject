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
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage('assets/profile.jpg'),
                      radius: 20,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Welcome, $userName",
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const Text("HR Manager", style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(child: _buildStatBox("28", "Active Jobs", Colors.blue.withOpacity(0.1), Colors.blue)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildStatBox("156", "Applications", Colors.green.withOpacity(0.1), Colors.green)),
                  ],
                ),
                const SizedBox(height: 32),
                LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = constraints.maxWidth > 800 ? 4 : 2;
                      return GridView.count(
                        crossAxisCount: crossAxisCount,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.2,
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
                      );
                    }
                ),
                const SizedBox(height: 32),
                const Text(
                  'Recent Activities',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Card(
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      activityItem(
                        icon: Icons.check_circle,
                        color: Colors.green,
                        title: "Attendance marked for today",
                        time: "9:00 AM",
                      ),
                      const Divider(height: 1),
                      activityItem(
                        icon: Icons.check_box,
                        color: Colors.blue,
                        title: "Leave request approved",
                        time: "Yesterday",
                      ),
                      const Divider(height: 1),
                      activityItem(
                        icon: Icons.event_available,
                        color: Colors.purple,
                        title: "Team meeting scheduled",
                        time: "Yesterday",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openChatbot,
        child: const Icon(Icons.chat),
      ),
    );
  }

  Widget _buildStatBox(String number, String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(number,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              )
          ),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                color: textColor.withOpacity(0.8),
                fontSize: 14,
              )
          ),
        ],
      ),
    );
  }

  Widget activityItem({
    required IconData icon,
    required Color color,
    required String title,
    required String time,
  }) {
    return ListTile(
      leading: Icon(icon, color: color, size: 20),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      trailing: Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      dense: true,
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
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.blue, size: 28),
              const SizedBox(height: 8),
              Text(title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              Text(subtitle,
                style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
