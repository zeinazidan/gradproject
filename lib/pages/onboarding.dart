import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'chatbot_onboarding.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final Map<String, bool> _uploadStatus = {
    'ID': false,
    'Medical Examination': false,
    'Bank Details': false,
    'Education Certificates': false,
  };

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUploadStatus();
  }

  Future<void> _loadUploadStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef =
    FirebaseFirestore.instance.collection('users').doc(user.uid);
    final snapshot = await docRef.get();

    if (snapshot.exists) {
      final data = snapshot.data()?['uploadedDocuments'] ?? {};
      setState(() {
        _uploadStatus.updateAll((key, _) => data[key] ?? false);
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateUploadStatus(String title, bool uploaded) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() {
      _uploadStatus[title] = uploaded;
    });

    final docRef =
    FirebaseFirestore.instance.collection('users').doc(user.uid);

    await docRef.set({
      'uploadedDocuments': _uploadStatus,
    }, SetOptions(merge: true));
  }

  bool get _allUploaded => !_uploadStatus.containsValue(false);

  @override
  Widget build(BuildContext context) {
    double progress =
        _uploadStatus.values.where((v) => v).length / _uploadStatus.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Rebota Onboarding'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Progress',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              color: Colors.blue,
            ),
            const SizedBox(height: 24),
            const Text('Required Documents',
                style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ..._uploadStatus.entries.map((entry) {
              return DocumentUploadTile(
                title: entry.key,
                uploaded: entry.value,
                onUploaded: (uploaded) =>
                    _updateUploadStatus(entry.key, uploaded),
              );
            }).toList(),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: _allUploaded
                    ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            "🎉 You have completed onboarding!")),
                  );
                }
                    : null,
                icon: const Icon(Icons.send),
                label: const Text("Submit All Documents"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ChatScreen()));
        },
        child: const Icon(Icons.chat),
      ),
    );
  }
}

class DocumentUploadTile extends StatefulWidget {
  final String title;
  final bool uploaded;
  final void Function(bool uploaded) onUploaded;

  const DocumentUploadTile({
    Key? key,
    required this.title,
    required this.uploaded,
    required this.onUploaded,
  }) : super(key: key);

  @override
  State<DocumentUploadTile> createState() => _DocumentUploadTileState();
}

class _DocumentUploadTileState extends State<DocumentUploadTile> {
  bool _isUploading = false;

  Future<void> uploadFile() async {
    try {
      final result = await FilePicker.platform.pickFiles();

      if (result == null) return;

      setState(() => _isUploading = true);

      final file = result.files.first;
      final fileName = file.name;
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) throw Exception("No user logged in");

      final ref = FirebaseStorage.instance
          .ref()
          .child('user_documents/${user.uid}/${widget.title}/$fileName');

      if (kIsWeb) {
        if (file.bytes == null) throw Exception("Empty file on web.");
        await ref.putData(file.bytes!);
      } else {
        final filePath = file.path!;
        await ref.putFile(File(filePath));
      }

      final downloadURL = await ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('documents')
          .doc(widget.title)
          .set({
        'title': widget.title,
        'url': downloadURL,
        'fileName': fileName,
        'uploadedAt': Timestamp.now(),
      });

      widget.onUploaded(true);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${widget.title} uploaded successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading ${widget.title}: $e')),
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.description),
        title: Text(widget.title),
        trailing: widget.uploaded
            ? const Text("Uploaded ✅", style: TextStyle(color: Colors.green))
            : ElevatedButton.icon(
          onPressed: _isUploading ? null : uploadFile,
          icon: _isUploading
              ? const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : const Icon(Icons.upload_file),
          label: Text(_isUploading ? "Uploading..." : "Upload"),
        ),
      ),
    );
  }
}
