import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FeedbackAnalysisPage extends StatelessWidget {
  const FeedbackAnalysisPage({super.key});

  Future<Map<String, dynamic>> _fetchFeedbackData() async {
    final snapshot = await FirebaseFirestore.instance.collection('feedback').get();

    double totalJobSatisfaction = 0;
    double totalManagerSupport = 0;
    double totalWorkEnvironment = 0;
    List<Map<String, dynamic>> comments = [];

    for (var doc in snapshot.docs) {
      final data = doc.data();
      totalJobSatisfaction += (data['jobSatisfaction'] ?? 0).toDouble();
      totalManagerSupport += (data['managerSupport'] ?? 0).toDouble();
      totalWorkEnvironment += (data['workEnvironment'] ?? 0).toDouble();

      if (data['additionalComments'] != null && (data['additionalComments'] as String).trim().isNotEmpty) {
        comments.add({
          'comment': data['additionalComments'],
          'email': data['email'] ?? 'Anonymous',
          'timestamp': (data['timestamp'] as Timestamp).toDate(),
        });
      }
    }

    int count = snapshot.docs.length;
    return {
      'avgJobSatisfaction': count > 0 ? totalJobSatisfaction / count : 0,
      'avgManagerSupport': count > 0 ? totalManagerSupport / count : 0,
      'avgWorkEnvironment': count > 0 ? totalWorkEnvironment / count : 0,
      'comments': comments,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feedback Analysis')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchFeedbackData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData) return const Center(child: Text('No feedback data found.'));

          final data = snapshot.data!;
          final comments = data['comments'] as List<Map<String, dynamic>>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFeedbackTile('Job Satisfaction', data['avgJobSatisfaction']),
                _buildFeedbackTile('Manager Support', data['avgManagerSupport']),
                _buildFeedbackTile('Work Environment', data['avgWorkEnvironment']),
                const SizedBox(height: 20),
                const Text('Recent Comments', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ...comments.map((commentData) {
                  final comment = commentData['comment'];
                  final email = commentData['email'];
                  final timestamp = commentData['timestamp'] as DateTime;
                  final formattedTime = DateFormat.yMMMEd().add_jm().format(timestamp);
                  return Card(
                    color: const Color(0xFFF5F6FA),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('"$comment"', style: const TextStyle(fontStyle: FontStyle.italic)),
                          const SizedBox(height: 6),
                          Text(
                            '${email.isEmpty ? 'Anonymous' : email} • $formattedTime',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeedbackTile(String title, double score) {
    return Card(
      color: const Color(0xFFF5F6FA),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text('${score.toStringAsFixed(1)} / 10', style: const TextStyle(color: Colors.blue)),
      ),
    );
  }
}
