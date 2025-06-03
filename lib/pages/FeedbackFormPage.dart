import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  bool isAnonymous = false;

  Future<void> _submitFeedback() async {
    final user = FirebaseAuth.instance.currentUser;
    final feedbackData = {
      'jobSatisfaction': jobSatisfaction.round(),
      'workEnvironment': workEnvironment.round(),
      'managerSupport': managerSupport.round(),
      'additionalComments': commentController.text.trim(),
      'timestamp': Timestamp.now(),
      'email': isAnonymous ? 'Anonymous' : (user?.email ?? 'Anonymous'),
    };

    try {
      await FirebaseFirestore.instance.collection('feedback').add(feedbackData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Feedback submitted successfully!')),
      );

      // Reset the form
      setState(() {
        jobSatisfaction = 5;
        workEnvironment = 5;
        managerSupport = 5;
        commentController.clear();
        isAnonymous = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Feedback Form'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            padding: const EdgeInsets.all(24.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Monthly Employee Feedback',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Please share your thoughts about this month',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 32),
                    feedbackSlider('Job Satisfaction', jobSatisfaction, (value) {
                      setState(() {
                        jobSatisfaction = value;
                      });
                    }),
                    const SizedBox(height: 24),
                    feedbackSlider('Work Environment', workEnvironment, (value) {
                      setState(() {
                        workEnvironment = value;
                      });
                    }),
                    const SizedBox(height: 24),
                    feedbackSlider('Manager Support', managerSupport, (value) {
                      setState(() {
                        managerSupport = value;
                      });
                    }),
                    const SizedBox(height: 32),
                    const Text(
                      'Additional Comments',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: commentController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Share your thoughts...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CheckboxListTile(
                      title: const Text('Submit anonymously'),
                      value: isAnonymous,
                      onChanged: (value) {
                        setState(() {
                          isAnonymous = value ?? false;
                        });
                      },
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: ElevatedButton(
                        onPressed: _submitFeedback,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(200, 40),
                        ),
                        child: const Text('Submit Feedback'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget feedbackSlider(String title, double value, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                value.round().toString(),
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
          ),
          child: Slider(
            value: value,
            min: 1,
            max: 10,
            divisions: 9,
            label: value.round().toString(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
