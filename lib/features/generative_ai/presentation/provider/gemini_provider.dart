// import 'package:flutter/material.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:image_picker/image_picker.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';
//
// class GeminiChatProvider extends ChangeNotifier {
//   final List<types.Message> _messages = [];
//      types.User _user = types.User(id: 'user-id');
//   final ImagePicker _picker = ImagePicker();
//
//   final model = GenerativeModel(
//       model: 'gemini-1.5-flash-latest',
//       apiKey: 'AIzaSyCJp4lTmTxWcXzg9sWT6bHjREEujlnafAE',
//       generationConfig: GenerationConfig(temperature: 0, maxOutputTokens: 100));
//
//   List<types.Message> get messages => _messages;
//   types.User get user => _user;
//
//   void handleSendPressed(types.PartialText message) async {
//     final textMessage = types.TextMessage(
//       author: _user,
//       createdAt: DateTime.now().millisecondsSinceEpoch,
//       id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
//       text: message.text,
//     );
//
//     _messages.insert(0,
//         textMessage); // Insert at the beginning for latest message at the bottom
//     notifyListeners();
//
//     // Generate AI response using Google Generative AI
//     final response = await generateAIResponse(message.text);
//     final aiMessage = types.TextMessage(
//       author: const types.User(id: 'ai-id'),
//       createdAt: DateTime.now().millisecondsSinceEpoch,
//       id: 'msg-${DateTime.now().millisecondsSinceEpoch + 1}',
//       text: response,
//     );
//
//     _messages.insert(0,
//         aiMessage); // Insert at the beginning for latest message at the bottom
//     notifyListeners();
//   }
//
//   Future<String> generateAIResponse(String userInput) async {
//     final content = [Content.text(userInput)];
//     final response = await model.generateContent(content);
//
//     return response.text ?? 'No Reponse'; // Placeholder response
//   }
//
//   void handleImageUpload(ImageSource source) async {
//     final pickedFile = await _picker.pickImage(source: source);
//
//     if (pickedFile != null) {
//       final imageMessage = types.ImageMessage(
//         author: _user,
//         createdAt: DateTime.now().millisecondsSinceEpoch,
//         id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
//         name: pickedFile.name,
//         size: await pickedFile.length(),
//         uri: pickedFile.path,
//       );
//
//       _messages.insert(0,
//           imageMessage); // Insert at the beginning for latest message at the bottom
//       notifyListeners();
//     }
//   }
// }
