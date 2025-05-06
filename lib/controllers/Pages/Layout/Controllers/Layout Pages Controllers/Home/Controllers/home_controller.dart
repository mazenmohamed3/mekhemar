import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:groq_sdk/models/groq.dart';
import 'package:groq_sdk/models/groq_chat.dart';
import 'package:groq_sdk/models/groq_llm_model.dart';
import 'package:groq_sdk/models/groq_message.dart';
import 'package:mekhemar/views/components/Snack%20Bar/failed_snackbar.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../Generated/Assets/assets.dart';
import '../../../../../../Repos/local/secure_storage_helper.dart';
import '../Services/chat_service.dart';
import '../Services/voice_service.dart';

class HomeController {
  HomeController({required this.voiceService});

  // == STATE AND CONTROLLERS ==
  late void Function(void Function()) setState;

  final Groq _groq = Groq(dotenv.env['GROQ_API_KEY']!);
  final _uuid = Uuid();

  GroqChat? _currentChatSession;
  VoiceService voiceService;
  User? user;

  // == SESSION & CHAT DATA ==
  String? _currentSessionId;
  bool isTyping = false;
  DateTime? recordingStartTime;

  bool get isRecording => voiceService.isRecording;

  set isRecording(bool value) {
    voiceService.isRecording = value;
    setState(() {}); // automatically trigger rebuild if needed
  }

  List<ChatMessage> messages = [];
  Map<String, ChatService> chatHistory = {};

  final ChatUser grokChatUser = ChatUser(
    id: "666",
    firstName: "Mekhemar",
    lastName: "Banha",
    profileImage: Assets.logoWhite,
  );

  ChatUser currentUser = ChatUser(
  id: "69420",
  firstName: "Mekhemar",
  profileImage: "",
  );

  void initState(void Function(void Function()) setState) async {
    this.setState = setState;
    user = FirebaseAuth.instance.currentUser;
    messages = [];
    chatHistory = {};
    print("===============================> ${user?.displayName}");
    currentUser = ChatUser(
      id: "69420",
      firstName: user?.displayName ?? "Mekhemar",
      profileImage: user?.photoURL ?? "",
    );
    await loadChatHistory();
  }

  // == VOICE LOGIC ==
  Future<void> toggleVoiceRecording(BuildContext context) async {
    try {
      if (!isRecording) {
        isRecording = true;
        setState(() {
          recordingStartTime = DateTime.now();
        });
        await voiceService.startListening();
      } else {
        await voiceService.stopListening();
        setState(() {
          isRecording = false;
          recordingStartTime = null;
        });

        final transcribedText = voiceService.wordsSpoken.trim();
        if (transcribedText.isEmpty || voiceService.confidence < 0.4) {
          throw Exception('Could not understand speech clearly.');
        }

        await getChatResponse(
          message: ChatMessage(
            user: currentUser,
            createdAt: DateTime.now(),
            text: transcribedText,
          ),
          setState: setState,
        );
      }
    } catch (e) {
      print('Speech error: $e');
      setState(() {
        isRecording = false;
        recordingStartTime = null;
      });

      if (!context.mounted) return;
      showFailedSnackBar(context, title: e.toString());
    }
  }

  // == CHAT & HISTORY LOGIC ==
  Future<void> loadChatHistory() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    String? jsonString = await SecureStorageHelper.readValueFromKey(
      key: 'chatHistory_$userId',
    );

    // If the data is not found in secure storage, fetch it from Firestore
    if (jsonString == null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('chat_histories')
            .doc(userId)
            .get();

        if (doc.exists && doc.data()?['data'] != null) {
          final dataField = doc.data()?['data'];

          if (dataField is List) {
            // Convert Firestore data to ChatService objects
            List<ChatService> services = dataField.map((entry) {
              final map = Map<String, dynamic>.from(entry);
              return ChatService.fromJson(map);
            }).toList();

            // Optionally, map to a chatHistory map for easy access later
            chatHistory = {
              for (final service in services) service.id: service,
            };

            // Flatten all messages from all services
            final allMessages = services.expand((s) => s.messages).toList();

            // Save chat history and all messages to secure storage
            await SecureStorageHelper.writeValueToKey(
              key: 'chatHistory_$userId',
              value: jsonEncode(
                chatHistory.values.map((e) => e.toJson()).toList(),
              ),
            );

            await SecureStorageHelper.writeValueToKey(
              key: 'chatMessages_$userId',
              value: jsonEncode(
                allMessages.map((m) => m.toJson()).toList(),
              ),
            );

            // Debug logs
            print("===============================> saving chat history: ${chatHistory.values.map((e) => e.title)}");
            print("===============================> saving chat messages: ${allMessages.length}");
            print('===============================> Fetched and saved chat history from Firestore for chatHistory_$userId.');

            // Now, update the UI by calling setState after fetching from Firestore
            setState(() {
              // Add entries to chatHistory (trigger UI update)
              chatHistory.addEntries(
                services.map((service) {
                  return MapEntry(service.id, service);
                }),
              );
            });
          } else {
            print('===============================> No valid "data" field in Firestore document for $userId.');
          }
        } else {
          print('===============================> No chat history found in Firestore for $userId.');
        }
      } catch (e) {
        print('===============================> Error fetching chat history from Firestore: $e');
      }
    }

    // If we found the chat history in secure storage, load it into the local variable
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
        print('Error decoding chat history: $e');
      }
    }
  }

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
            setState(() => isTyping = false);
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
                .replaceAll(RegExp(r'^title:\s*', caseSensitive: false), '')
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
        .map((msg) => "${msg.user.firstName}: ${msg.text}")
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
    final userId = user!.uid;

    setState(() {
      chatHistory.remove(sessionId);

      if (_currentSessionId == sessionId) {
        messages.clear();
        _currentSessionId = null;
      }
    });

    // First persist to local storage
    //await _persistChatHistory();
    await _deleteSessionFromSecureStorage(userId, sessionId);

    try {
      final docRef = FirebaseFirestore.instance
          .collection('chat_histories')
          .doc(userId);
      final snapshot = await docRef.get();

      if (snapshot.exists) {
        final data = snapshot.data();
        final List<dynamic> sessions = data?['data'] ?? [];

        // Remove session with matching ID
        sessions.removeWhere((session) => session['id'] == sessionId);

        // If the list is empty, remove the 'data' field completely or handle accordingly
        if (sessions.isEmpty) {
          await docRef.update({
            'data': FieldValue.delete(),
            'updatedAt': FieldValue.serverTimestamp(),
          });
        } else {
          // Otherwise, update the document with the remaining sessions
          await docRef.set({
            'data': sessions,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
      }
    } catch (e) {
      print("Error deleting chat session from Firestore: $e");
    }
  }

  Future<void> _deleteSessionFromSecureStorage(
    String userId,
    String sessionId,
  ) async {
    try {
      // Retrieve the current chat history from secure storage
      String? storedChatHistory = await SecureStorageHelper.readValueFromKey(
        key: "chatHistory_$userId",
      );

      if (storedChatHistory != null) {
        // Decode the stored chat history (assuming it's a JSON list of sessions)
        List<dynamic> chatHistoryList = List.from(
          jsonDecode(storedChatHistory),
        );

        // Remove the session with the matching sessionId
        chatHistoryList.removeWhere((session) => session['id'] == sessionId);

        // Store the updated chat history back to secure storage
        await SecureStorageHelper.writeValueToKey(
          key: "chatHistory_$userId",
          value: jsonEncode(chatHistoryList),
        );
      }
    } catch (e) {
      print("Error deleting session from secure storage: $e");
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
    final userId = user!.uid;
    final jsonList = chatHistory.values.map((s) => s.toJson()).toList();

    try {
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('chat_histories').doc(userId).set({
        'data': jsonList,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error saving chat history to Firestore: $e');
    }
  }
}
