import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
// Import the correct AI plugin classes
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:sample_latest/features/generative_ai/presentation/provider/gemini_provider.dart';

class GeminiChatScreen extends StatelessWidget {
  const GeminiChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<GeminiChatProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Chat(
        messages: chatProvider.messages,
        onSendPressed: chatProvider.handleSendPressed,
        user: chatProvider.user,
        showUserAvatars: true,
        showUserNames: true,
        listBottomWidget: Wrap(
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.attach_file))
          ],
        ),
        scrollPhysics: AlwaysScrollableScrollPhysics(),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // FloatingActionButton(
          //   onPressed: () => chatProvider.handleImageUpload(ImageSource.camera),
          //   child: Icon(Icons.camera),
          // ),
          // SizedBox(height: 10),
          // FloatingActionButton(
          //   onPressed: () => chatProvider.handleImageUpload(ImageSource.gallery),
          //   child: Icon(Icons.image),
          // ),
        ],
      ),
    );
  }
}
