import 'package:flutter/material.dart';
import 'CalendarPage.dart';
import 'FeedbackFormPage.dart';
import 'chatbot_employee.dart';
import 'hrRecords.dart'; // <-- Added import for HR Records page

class EmployeePage extends StatelessWidget {
  final String userEmail; // Add userEmail parameter

  const EmployeePage({Key? key, required this.userEmail}) : super(key: key);

  String get userName {
    // Extract username before @ in email, fallback to full email if @ not found
    if (userEmail.contains('@')) {
      return userEmail.split('@')[0];
    } else {
      return userEmail;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/profile.jpg'),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Welcome, $userName',
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Add logout logic here
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                buildGridItem(context, Icons.chat_bubble_outline, "Chatbot", Colors.blue[100]!, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatScreen()));
                }),
                buildGridItem(context, Icons.folder_open, "HR Records", Colors.purple[100]!, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HRRecordsPage()));
                }),
                buildGridItem(context, Icons.calendar_today, "Calendar", Colors.green[100]!, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CalendarPage()));
                }),
                buildGridItem(context, Icons.feedback_outlined, "Feedback", Colors.orange[100]!, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const FeedbackFormPage()));
                }),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Recent Activities',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            activityItem(
              icon: Icons.check_circle,
              color: Colors.green,
              title: "Attendance marked for today",
              time: "9:00 AM",
            ),
            activityItem(
              icon: Icons.check_box,
              color: Colors.blue,
              title: "Leave request approved",
              time: "Yesterday",
            ),
            activityItem(
              icon: Icons.event_available,
              color: Colors.purple,
              title: "Team meeting scheduled",
              time: "Yesterday",
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Submit tasks logic
                },
                icon: const Icon(Icons.send),
                label: const Text("Submit All Tasks"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatScreen()),
          );
        },
        child: const Icon(Icons.chat),
      ),
    );
  }

  Widget buildGridItem(BuildContext context, IconData icon, String label, Color color, VoidCallback? onTap) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.black),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget activityItem({
    required IconData icon,
    required Color color,
    required String title,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Text(
            time,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
