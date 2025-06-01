import 'package:flutter/material.dart';
import 'chatbot_onboarding.dart'; // <<-- Correct import for your chatbot page!

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Rebota Onboarding'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Progress', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: 0.5,
              backgroundColor: Colors.grey[300],
              color: Colors.blue,
            ),
            const SizedBox(height: 24),
            const Text('Required Documents', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const DocumentUploadTile(title: 'ID'),
            const DocumentUploadTile(title: 'Medical Examination'),
            const DocumentUploadTile(title: 'Bank Details'),
            const DocumentUploadTile(title: 'Education Certificates'),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // submit logic
                },
                icon: const Icon(Icons.send),
                label: const Text("Submit All Documents"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatScreen()), // <<-- Opens your chatbot page
          );
        },
        child: const Icon(Icons.chat),
      ),
    );
  }
}

class DocumentUploadTile extends StatelessWidget {
  final String title;

  const DocumentUploadTile({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.description),
        title: Text(title),
        trailing: ElevatedButton.icon(
          onPressed: () {
            // Upload logic here
          },
          icon: const Icon(Icons.upload_file),
          label: const Text("Upload"),
        ),
      ),
    );
  }
}
