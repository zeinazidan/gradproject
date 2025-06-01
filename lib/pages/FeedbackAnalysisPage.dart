import 'package:flutter/material.dart';

void main() {
  runApp(FeedbackAnalysisApp());
}

class FeedbackAnalysisApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feedback Analysis',
      debugShowCheckedModeBanner: false,
      home: FeedbackAnalysisPage(),
    );
  }
}

class FeedbackAnalysisPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // ✅ Now it goes back to previous screen
          },
        ),
        title: Text('Feedback Analysis', style: TextStyle(color: Colors.black)),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('Export', style: TextStyle(color: Colors.blue)),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopStats(),
            SizedBox(height: 20),
            _buildSentimentAnalysis(),
            SizedBox(height: 20),
            _buildKeyInsights(),
            SizedBox(height: 20),
            _buildRecentComments(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopStats() {
    return Row(
      children: [
        Expanded(
          child: _statCard("Job Satisfaction", "8.5/10", "+5%", Colors.green),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _statCard("Response Rate", "92%", "+12%", Colors.blue),
        ),
      ],
    );
  }

  Widget _statCard(String title, String value, String change, Color changeColor) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.grey, fontSize: 14)),
          SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text(change, style: TextStyle(color: changeColor)),
        ],
      ),
    );
  }

  Widget _buildSentimentAnalysis() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sentiment Analysis', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          _sentimentBar("Positive", 65, Colors.green),
          SizedBox(height: 10),
          _sentimentBar("Neutral", 25, Colors.amber),
          SizedBox(height: 10),
          _sentimentBar("Negative", 10, Colors.red),
        ],
      ),
    );
  }

  Widget _sentimentBar(String label, int percent, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: 4),
        LinearProgressIndicator(
          value: percent / 100,
          backgroundColor: Colors.grey.shade300,
          color: color,
          minHeight: 8,
        ),
      ],
    );
  }

  Widget _buildKeyInsights() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Key Insights', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          _insightTile(Icons.work, Colors.green, "Work Environment", "85% of employees are satisfied with the current work environment"),
          SizedBox(height: 16),
          _insightTile(Icons.warning, Colors.amber, "Manager Support", "Need for improved communication between managers and team members"),
          SizedBox(height: 16),
          _insightTile(Icons.lightbulb, Colors.blue, "Growth Opportunities", "70% express interest in more professional development programs"),
        ],
      ),
    );
  }

  Widget _insightTile(IconData icon, Color color, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text(subtitle, style: TextStyle(color: Colors.grey)),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildRecentComments() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Comments', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          _commentTile('"The new flexible work policy has greatly improved my work-life balance."', "Anonymous • 2 days ago"),
          SizedBox(height: 16),
          _commentTile('"Would love to see more team building activities and social events."', "Anonymous • 3 days ago"),
        ],
      ),
    );
  }

  Widget _commentTile(String comment, String authorInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(comment, style: TextStyle(fontStyle: FontStyle.italic)),
        SizedBox(height: 8),
        Text(authorInfo, style: TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}
