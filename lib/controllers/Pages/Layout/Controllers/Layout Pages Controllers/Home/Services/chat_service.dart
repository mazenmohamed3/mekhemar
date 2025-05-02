import 'package:dash_chat_2/dash_chat_2.dart';

class ChatService {
  final String id;
  final String title;
  final List<ChatMessage> messages;

  ChatService({required this.id, required this.title, required this.messages});

  // Serialization method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'messages': messages.map((msg) => _chatMessageToMap(msg)).toList(),
    };
  }

  // Deserialization factory
  factory ChatService.fromJson(Map<String, dynamic> json) {
    return ChatService(
      id: json['id'],
      title: json['title'],
      messages:
      (json['messages'] as List)
          .map((msg) => _chatMessageFromMap(msg))
          .toList(),
    );
  }
}

// Add these helper functions in your _HomeScreenState class
Map<String, dynamic> _chatMessageToMap(ChatMessage message) {
  return {
    'text': message.text,
    'createdAt': message.createdAt.toIso8601String(),
    'user': _chatUserToMap(message.user),
  };
}

ChatMessage _chatMessageFromMap(Map<String, dynamic> map) {
  return ChatMessage(
    text: map['text'],
    createdAt: DateTime.parse(map['createdAt']),
    user: _chatUserFromMap(map['user']),
  );
}

Map<String, dynamic> _chatUserToMap(ChatUser user) {
  return {
    'id': user.id,
    'firstName': user.firstName,
    'lastName': user.lastName,
    'profileImage': user.profileImage,
  };
}

ChatUser _chatUserFromMap(Map<String, dynamic> map) {
  return ChatUser(
    id: map['id'],
    firstName: map['firstName'],
    lastName: map['lastName'],
    profileImage: map['profileImage'],
  );
}