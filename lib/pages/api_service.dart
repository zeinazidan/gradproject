// api_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> askHRBot(String question) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:8000/ask'), // Your API endpoint
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'question': question}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['answer'];  // Assuming the API returns a field "answer"
  } else {
    throw Exception('Failed to get answer: ${response.body}');
  }
}
