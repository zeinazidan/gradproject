import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String? userImage;

  const SettingsPage({
    super.key,
    required this.userName,
    required this.userEmail,
    this.userImage,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: widget.userImage != null
                    ? NetworkImage(widget.userImage!)
                    : const AssetImage('assets/profile.jpg') as ImageProvider,
              ),
              title: Text(
                widget.userName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(widget.userEmail),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ACCOUNT SETTINGS',
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  _buildSettingsItem(icon: Icons.lock, text: 'Change Password'),
                  _buildSettingsItem(
                      icon: Icons.notifications, text: 'Notifications'),
                  _buildSettingsItem(
                    icon: Icons.language,
                    text: 'Language',
                    trailing: const Text('English',
                        style: TextStyle(color: Colors.grey)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('MORE',
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  _buildSettingsItem(icon: Icons.info_outline, text: 'About'),
                  _buildSettingsItem(
                      icon: Icons.privacy_tip_outlined, text: 'Privacy Policy'),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.red,
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  // Add your logout function here
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
      {required IconData icon, required String text, Widget? trailing}) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(text),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // Add your action here
      },
    );
  }
}