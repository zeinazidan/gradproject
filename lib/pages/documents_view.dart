import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class OnboardingDocumentsView extends StatelessWidget {
  const OnboardingDocumentsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Onboarding Documents")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, userSnapshot) {
          if (!userSnapshot.hasData) return const Center(child: CircularProgressIndicator());

          final userDocs = userSnapshot.data!.docs;

          return FutureBuilder<List<QueryDocumentSnapshot>>(
            future: _filterUsersWithDocuments(userDocs),
            builder: (context, filteredSnapshot) {
              if (!filteredSnapshot.hasData) return const Center(child: CircularProgressIndicator());

              final filteredUsers = filteredSnapshot.data!;

              if (filteredUsers.isEmpty) {
                return const Center(child: Text("No users with uploaded documents."));
              }

              return ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];
                  final data = user.data() as Map<String, dynamic>;
                  final email = data['email'] as String;
                  final username = email.split('@').first;
                  final uploadedDocs = data['uploadedDocuments'] as Map<String, dynamic>?;

                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(username),
                      subtitle: Text(uploadedDocs != null ? uploadedDocs.toString() : "No documents"),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DocumentListScreen(userId: user.id),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<List<QueryDocumentSnapshot>> _filterUsersWithDocuments(List<QueryDocumentSnapshot> users) async {
    List<QueryDocumentSnapshot> filtered = [];

    for (var user in users) {
      final data = user.data() as Map<String, dynamic>;
      final uploadedDocs = data['uploadedDocuments'] as Map<String, dynamic>?;

      if (uploadedDocs != null && uploadedDocs.values.any((value) => value == true)) {
        filtered.add(user);
      }
    }

    return filtered;
  }
}

class DocumentListScreen extends StatelessWidget {
  final String userId;

  const DocumentListScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Documents for $userId")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('documents')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("No documents uploaded"));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              return ListTile(
                title: Text(doc['title']),
                subtitle: Text(doc['fileName']),
                trailing: IconButton(
                  icon: const Icon(Icons.open_in_new),
                  onPressed: () {
                    final url = doc['url'];
                    launchUrl(Uri.parse(url));
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
