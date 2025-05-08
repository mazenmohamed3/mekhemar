import 'package:dash_chat_2/dash_chat_2.dart';

class ChatModel {
  final String id;
  final String title;
  final List<ChatMessage> messages;

  ChatModel({
    required this.id,
    required this.title,
    required this.messages,
  });

  // Serialization
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'messages': messages.map(_chatMessageToMap).toList(),
  };

  // Deserialization
  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'] as String,
      title: json['title'] as String,
      messages: (json['messages'] as List<dynamic>)
          .map((msg) => _chatMessageFromMap(msg))
          .toList(),
    );
  }

  // Helpers for ChatMessage serialization
  static Map<String, dynamic> _chatMessageToMap(ChatMessage message) => {
    'text': message.text,
    'createdAt': message.createdAt.toIso8601String(),
    'user': _chatUserToMap(message.user),
  };

  static ChatMessage _chatMessageFromMap(Map<String, dynamic> map) {
    return ChatMessage(
      text: map['text'],
      createdAt: DateTime.parse(map['createdAt']),
      user: _chatUserFromMap(map['user']),
    );
  }

  static Map<String, dynamic> _chatUserToMap(ChatUser user) => {
    'id': user.id,
    'firstName': user.firstName,
    'lastName': user.lastName,
    'profileImage': user.profileImage,
  };

  static ChatUser _chatUserFromMap(Map<String, dynamic> map) {
    return ChatUser(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      profileImage: map['profileImage'],
    );
  }
}