import 'dart:convert';
import 'dart:math';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:groq_sdk/models/groq.dart';
import 'package:groq_sdk/models/groq_chat.dart';
import 'package:groq_sdk/models/groq_llm_model.dart';
import 'package:groq_sdk/models/groq_message.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../Generated/Assets/assets.dart';
import '../../../../../../Repos/local/secure_storage_helper.dart';
import '../../../../../Auth/sources/auth_datasource.dart';
import '../Services/chat_service.dart';

class HomeController {
  late void Function(void Function()) setState;

  Future<void> loadChatHistory() async {
    final userId = AuthDatasource.userMessage!.user!.uid;
    final jsonString = await SecureStorageHelper.readValueFromKey(
      key: 'chatHistory_$userId',
    );

    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        setState(() {
          chatHistory.addEntries(
            jsonList.map((json) {
              final session = ChatService.fromJson(json);
              return MapEntry(session.id, session);
            }),
          );
        });
      } catch (e) {
        print('Error loading chat history: $e');
      }
    }
  }

  final Groq _groq = Groq(dotenv.env['GROQ_API_KEY']!);

  String? _currentSessionId;
  bool isTyping = false;

  final Map<String, ChatService> chatHistory = {};
  final List<ChatMessage> messages = [];
  GroqChat? _currentChatSession;

  final ChatUser currentUser = ChatUser(
    id: "69420",
    firstName: AuthDatasource.userMessage?.user?.displayName ?? "Mekhemar",
    profileImage: AuthDatasource.userMessage?.user?.photoURL ?? "",
  );

  final ChatUser grokChatUser = ChatUser(
    id: "666",
    firstName: "Mekhemar",
    lastName: "Banha",
    profileImage: Assets.logoWhite,
  );

  final _uuid = Uuid();

  Future<void> getChatResponse({
    required ChatMessage message,
    required void Function(void Function()) setState,
  }) async {
    setState(() {
      messages.insert(0, message);
      isTyping = true;
    });

    try {
      if (_currentChatSession == null) {
        _currentChatSession = _groq.startNewChat(
          GroqModels.llama3_70b,
          settings: GroqChatSettings(temperature: 0.8, maxTokens: 512),
        );

        for (final msg in messages.reversed.skip(1)) {
          if (msg.user == currentUser) {
            await _currentChatSession!.sendMessage(
              msg.text,
              role: GroqMessageRole.user,
            );
          }
        }
      }

      final (chatResponse, _) = await _currentChatSession!.sendMessage(
        message.text,
      );

      for (var choice in chatResponse.choices) {
        if (choice.message.isNotEmpty) {
          setState(() {
            messages.insert(
              0,
              ChatMessage(
                user: grokChatUser,
                createdAt: DateTime.now(),
                text: choice.message.trim(),
              ),
            );
          });
        }
      }
      if (_currentSessionId == null) {
        await saveCurrentChatSession(clearMessages: false);
      }
    } catch (e) {
      print('Error during chat response: $e');
    } finally {
      setState(() => isTyping = false);
    }
  }

  bool _areMessagesEqual(List<ChatMessage> a, List<ChatMessage> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].text != b[i].text || a[i].user.id != b[i].user.id) {
        return false;
      }
    }
    return true;
  }

  Future<void> _persistChatHistory() async {
    final userId = AuthDatasource.userMessage!.user!.uid;
    final jsonList = chatHistory.values.map((s) => s.toJson()).toList();
    await SecureStorageHelper.writeValueToKey(
      key: 'chatHistory_$userId',
      value: jsonEncode(jsonList),
    );
  }

  Future<void> saveCurrentChatSession({bool clearMessages = true}) async {
    if (messages.isEmpty) return;

    String uniqueId = _currentSessionId ?? _uuid.v4();
    String summaryTitle = "New Chat";
    bool shouldGenerateTitle = true;

    if (_currentSessionId != null) {
      final existingSession = chatHistory[_currentSessionId]!;
      if (_areMessagesEqual(messages, existingSession.messages)) {
        summaryTitle = existingSession.title;
        shouldGenerateTitle = false;
      }
    }

    if (shouldGenerateTitle) {
      final chatSession = _groq.startNewChat(GroqModels.llama3_70b);
      final systemPrompt =
          "Generate a concise 3-6 word title capturing the main topic. "
          "Return only the title without quotes, colons, or explanations. "
          "Examples: 'Goalkeeper Strategies', 'Healthy Relationships', 'Career Advice'";

      final allMessages = messages.reversed
          .map((msg) => '${msg.user.firstName}: ${msg.text}')
          .join('\n');

      try {
        final (response, _) = await chatSession.sendMessage(
          '$systemPrompt\n\n$allMessages',
        );
        final rawTitle = response.choices.first.message.trim();

        summaryTitle =
            rawTitle
                .replaceAll(RegExp(r'^"|"$'), '')
                .replaceAll(
                  RegExp(r'^title:\s*', caseSensitive: false),
                  '',
                )
                .split('\n')[0]
                .substring(0, min(rawTitle.length, 35))
                .trim();

        final words = summaryTitle.split(' ');
        if (words.length > 6) {
          summaryTitle = words.sublist(0, 6).join(' ');
        }
      } catch (e) {
        print("Failed to summarize title: $e");
      }
    }

    setState(() {
      chatHistory[uniqueId] = ChatService(
        id: uniqueId,
        title: summaryTitle,
        messages: List.from(messages),
      );

      if (clearMessages) {
        messages.clear();
        _currentSessionId = null;
      } else {
        _currentSessionId = uniqueId;
      }
    });

    await _persistChatHistory();
  }

  Future<void> loadChatSession(ChatService session) async {
    if (messages.isNotEmpty && _currentSessionId == null) {
      await saveCurrentChatSession();
    }

    _currentChatSession = null;
    setState(() {
      messages
        ..clear()
        ..addAll(session.messages);
      _currentSessionId = session.id;
    });

    _currentChatSession = _groq.startNewChat(
      GroqModels.llama3_70b,
      settings: GroqChatSettings(temperature: 0.8, maxTokens: 512),
    );

    final historyPrompt = session.messages.reversed
        .map((msg) {
          final sender = msg.user.firstName;
          return "$sender: ${msg.text}";
        })
        .join('\n');

    try {
      await _currentChatSession!.sendMessage(
        "Our conversation history:\n$historyPrompt\nRespond appropriately:",
        role: GroqMessageRole.system,
      );
    } catch (e) {
      print("Failed to send system history prompt: $e");
    }

    await _persistChatHistory();
  }

  void deleteChatSession(String sessionId) async {
    setState(() {
      chatHistory.remove(sessionId);

      if (_currentSessionId == sessionId) {
        messages.clear();
        _currentSessionId = null;
      }
    });
    await _persistChatHistory();
  }

  // void startNewChat() {
  //   _currentChatSession = null;
  //   setState(() {
  //     messages.clear();
  //     _currentSessionId = null;
  //   });
  // }
}