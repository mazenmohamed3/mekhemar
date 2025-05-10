import 'package:dash_chat_2/dash_chat_2.dart';
import 'chat_model.dart';

class HomeModel {
  ChatUser? currentUser;
  String? currentSessionId;
  bool isTyping = false;
  bool isRecording = false;
  DateTime? recordingStartTime;
  List<ChatMessage> messages = [];
  Map<String, ChatModel> chatHistory = {};

  HomeModel({
    this.currentUser,
    this.currentSessionId,
    this.isTyping = false,
    this.isRecording = false,
    this.recordingStartTime,
    List<ChatMessage>? messages,
    Map<String, ChatModel>? chatHistory,
  })  : messages = messages ?? [],
        chatHistory = chatHistory ?? {};

  void resetSession() {
    currentSessionId = null;
    messages.clear();
  }

  void addMessage(ChatMessage message) {
    messages.insert(0, message);
  }

  void setTyping(bool value) {
    isTyping = value;
  }

  void setRecording(bool value) {
    isRecording = value;
    if (!value) recordingStartTime = null;
  }

  void addChatService(ChatModel service) {
    chatHistory[service.id] = service;
  }

  void updateChatService(ChatModel service) {
    chatHistory[service.id] = service;
  }

  void deleteChatService(String sessionId) {
    chatHistory.remove(sessionId);
  }
}