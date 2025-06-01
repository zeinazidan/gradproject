import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<_Message> _messages = [
    const _Message(
      text: 'Hi! How can I help you today? I can assist you with policies, HR records, or calendar-related questions.',
      isBot: true,
    ),
    const _Message(
      text: "What's the policy for sick leave?",
      isBot: false,
    ),
    const _Message(
      text: 'According to our policy, employees are entitled to 10 paid sick days per year. Would you like me to share more details about the sick leave policy?',
      isBot: true,
    ),
  ];

  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_Message(text: text, isBot: false));
    });

    _controller.clear();

    // Bot auto-reply
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _messages.add(const _Message(
          text: "Thank you for your message! I'll get back to you shortly.",
          isBot: true,
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue,
            child: Icon(Icons.smart_toy, color: Colors.white),
          ),
          title: Text(
            'Rebota\nHR Assistant',
            style: TextStyle(fontSize: 16),
          ),
          subtitle: Text(
            'Online',
            style: TextStyle(color: Colors.green, fontSize: 12),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return message.isBot
                    ? BotMessage(text: message.text)
                    : UserMessage(text: message.text);
              },
            ),
          ),
          MessageInput(
            controller: _controller,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}

class _Message {
  final String text;
  final bool isBot;

  const _Message({required this.text, required this.isBot});
}

class BotMessage extends StatelessWidget {
  final String text;
  const BotMessage({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 15),
      ),
    );
  }
}

class UserMessage extends StatelessWidget {
  final String text;
  const UserMessage({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.shade700,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
    );
  }
}

class MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const MessageInput({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Type your message...',
                border: InputBorder.none,
              ),
              onSubmitted: (_) => onSend(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: onSend,
          ),
        ],
      ),
    );
  }
}
