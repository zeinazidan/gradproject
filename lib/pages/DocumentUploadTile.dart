import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' if (dart.library.html) 'dart:html';

class DocumentUploadTile extends StatefulWidget {
  final String title;
  final VoidCallback onUploadSuccess;

  const DocumentUploadTile({
    Key? key,
    required this.title,
    required this.onUploadSuccess,
  }) : super(key: key);

  @override
  State<DocumentUploadTile> createState() => _DocumentUploadTileState();
}

class _DocumentUploadTileState extends State<DocumentUploadTile> {
  bool isUploaded = false;
  bool isUploading = false;

  Future<void> uploadFile(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles();

      if (result == null) return;

      setState(() {
        isUploading = true;
      });

      final file = result.files.first;
      final fileName = file.name;
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) throw Exception("No user logged in");

      final ref = FirebaseStorage.instance
          .ref()
          .child('user_documents/${user.uid}/${widget.title}/$fileName');

      if (kIsWeb) {
        if (file.bytes == null) throw Exception("File is empty.");
        await ref.putData(file.bytes!);
      } else {
        final filePath = file.path!;
        await ref.putFile(File(filePath));
      }

      await ref.getDownloadURL();

      setState(() {
        isUploaded = true;
        isUploading = false;
      });

      widget.onUploadSuccess();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${widget.title} uploaded successfully!')),
      );
    } catch (e) {
      setState(() {
        isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading ${widget.title}: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.description),
        title: Text(widget.title),
        trailing: isUploaded
            ? const Text("Uploaded ✅", style: TextStyle(color: Colors.green))
            : ElevatedButton.icon(
          onPressed: isUploading ? null : () => uploadFile(context),
          icon: isUploading
              ? const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : const Icon(Icons.upload_file),
          label: Text(isUploading ? "Uploading..." : "Upload"),
        ),
      ),
    );
  }
}
