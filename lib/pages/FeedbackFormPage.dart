import 'package:flutter/material.dart';

class FeedbackFormPage extends StatefulWidget {
  const FeedbackFormPage({Key? key}) : super(key: key);

  @override
  State<FeedbackFormPage> createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage> {
  double jobSatisfaction = 5;
  double workEnvironment = 5;
  double managerSupport = 5;
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Feedback Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Please share your thoughts about this month',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            feedbackSlider('Job Satisfaction', jobSatisfaction, (value) {
              setState(() {
                jobSatisfaction = value;
              });
            }),
            feedbackSlider('Work Environment', workEnvironment, (value) {
              setState(() {
                workEnvironment = value;
              });
            }),
            feedbackSlider('Manager Support', managerSupport, (value) {
              setState(() {
                managerSupport = value;
              });
            }),
            const SizedBox(height: 24),
            TextField(
              controller: commentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Share your thoughts...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Feedback submitted successfully!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Submit Feedback'),
            ),
          ],
        ),
      ),
    );
  }

  Widget feedbackSlider(String title, double value, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$title (1-10)', style: const TextStyle(fontWeight: FontWeight.bold)),
        Slider(
          value: value,
          min: 1,
          max: 10,
          divisions: 9,
          label: value.round().toString(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
