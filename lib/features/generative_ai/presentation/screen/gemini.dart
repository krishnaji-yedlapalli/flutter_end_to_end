import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:provider/provider.dart';
// Import the correct AI plugin classes
import 'package:sample_latest/features/generative_ai/presentation/provider/gemini_provider.dart';

class GeminiChatScreen extends StatelessWidget {
  const GeminiChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final chatProvider = Provider.of<GeminiChatProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: SizedBox(),
      // Chat(
      //   messages: chatProvider.messages,
      //   onSendPressed: chatProvider.handleSendPressed,
      //   user: chatProvider.user,
      //   showUserAvatars: true,
      //   showUserNames: true,
      //   listBottomWidget: Wrap(
      //     children: [
      //       IconButton(onPressed: () {}, icon: const Icon(Icons.attach_file))
      //     ],
      //   ),
      //   scrollPhysics: const AlwaysScrollableScrollPhysics(), currentUserId: '', resolveUser: (String id) {  }, chatController: null,
      // ),
      floatingActionButton: const Column(
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
