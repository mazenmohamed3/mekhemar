import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:groq_sdk/models/groq.dart';
import 'package:groq_sdk/models/groq_chat.dart';
import 'package:groq_sdk/models/groq_llm_model.dart';
import 'package:groq_sdk/models/groq_message.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../../models/Home/chat_model.dart';
import '../../../../../../../models/Home/home_model.dart';
import '../../../../../../../views/components/Snack Bar/failed_snackbar.dart';
import '../../../../../../Generated/Assets/assets.dart';
import '../../../../../../Repos/local/secure_storage_helper.dart';
import '../../Profile/services/profile_update_service.dart';
import '../../Settings/Services/settings_update_service.dart';
import '../Services/voice_service.dart';

class HomeController {
  HomeController() {
    // Initialize model and chat session
    _uuid = Uuid();

    // Initialize chat users
    grokChatUser = ChatUser(
      id: "666",
      firstName: "Mekhemar",
      lastName: "Banha",
      profileImage: Assets.logoWhite,
    );

    // Subscribe to profile updates
    _profileNotifierService = ProfileUpdateService();
    _profileSubscription = _profileNotifierService.profileUpdates.listen(
      _handleProfileUpdate,
    );

    // Subscribe to settings updates
    _settingsNotifierService = SettingsUpdateService();
    _settingsSubscription = _settingsNotifierService.settingsUpdates.listen(
      _handleSettingsUpdate,
    );
  }

  // == STATE AND CONTROLLERS ==
  late void Function(void Function()) setState;
  late HomeModel _model;

  final Groq _groq = Groq(dotenv.env['GROQ_API_KEY']!);
  late final Uuid _uuid;
  late final ChatUser grokChatUser;
  GroqChat? _currentChatSession;
  // VoiceService voiceService;
  User? user;

  // Settings
  double _temperature = 0.5;
  String _selectedModel = GroqModels.llama3_70b;

  // Profile notification system
  late final ProfileUpdateService _profileNotifierService;
  late final StreamSubscription _profileSubscription;

  // Settings notification system
  late final SettingsUpdateService _settingsNotifierService;
  late final StreamSubscription _settingsSubscription;

  // == GETTERS AND SETTERS FOR MODEL DATA ==
  List<ChatMessage> get messages => _model.messages;

  Map<String, ChatModel> get chatHistory => _model.chatHistory;

  bool get isTyping => _model.isTyping;

  // bool get isRecording => voiceService.isRecording;

  String? get currentSessionId => _model.currentSessionId;

  DateTime? get recordingStartTime => _model.recordingStartTime;

  ChatUser get currentUser => _model.currentUser!;

  double get temperature => _temperature;

  String get selectedModel => _selectedModel;

  // set isRecording(bool value) {
  //   voiceService.isRecording = value;
  //   _model.setRecording(value);
  //   setState(() {}); // automatically trigger rebuild if needed
  // }

  void initState(void Function(void Function()) setState) async {
    this.setState = setState;
    user = FirebaseAuth.instance.currentUser;
    _model = HomeModel();
    // Initialize current user in model
    _model.currentUser = ChatUser(
      id: "69420",
      firstName: user?.displayName ?? "Mekhemar",
      profileImage: user?.photoURL ?? "",
    );

    // Initialize chat session
    _initializeNewChatSession();

    print("===============================> ${user?.displayName}");
    await loadChatHistory();
  }

  // Handle profile updates
  void _handleProfileUpdate(ProfileUpdateEvent event) {
    // Only process events for the current user
    if (user?.uid != event.userId) return;

    if (event.photoUrl != null) {
      // Update current user's profile image
      setState(() {
        _model.currentUser = ChatUser(
          id: _model.currentUser!.id,
          firstName: _model.currentUser!.firstName,
          lastName: _model.currentUser!.lastName,
          profileImage: event.photoUrl!,
        );
      });

      // Update profile image in all chat messages
      _updateUserInChatHistory(event.photoUrl!);
    }

    // Handle other profile updates if needed
    if (event.displayName != null) {
      // Update display name if needed
      setState(() {
        _model.currentUser = ChatUser(
          id: _model.currentUser!.id,
          firstName: event.displayName!,
          lastName: _model.currentUser!.lastName,
          profileImage: _model.currentUser!.profileImage,
        );
      });
    }
  }

  // Handle settings updates
  void _handleSettingsUpdate(SettingsUpdateEvent event) async {
    final settings = event.settings;

    if (event.updateType case SettingsUpdateType.temperature) {
      _temperature = settings.temperature;
      if (_currentChatSession != null && currentSessionId != null) {
        await loadChatSession(chatHistory[currentSessionId]!);
      }
    } else if (event.updateType case SettingsUpdateType.model) {
      _selectedModel = settings.selectedModel;
      if (_currentChatSession != null && currentSessionId != null) {
        await loadChatSession(chatHistory[currentSessionId]!);
      }
    } else if (event.updateType case SettingsUpdateType.all) {
      _temperature = settings.temperature;
      _selectedModel = settings.selectedModel;
      if (_currentChatSession != null && currentSessionId != null) {
        await loadChatSession(chatHistory[currentSessionId]!);
      }
    }
  }

  // Update user profile in all chat messages
  void _updateUserInChatHistory(String newPhotoUrl) {
    setState(() {
      // Update current messages
      for (int i = 0; i < messages.length; i++) {
        final message = messages[i];
        if (message.user.id == currentUser.id) {
          messages[i] = ChatMessage(
            user: ChatUser(
              id: message.user.id,
              firstName: message.user.firstName,
              lastName: message.user.lastName,
              profileImage: newPhotoUrl,
            ),
            createdAt: message.createdAt,
            text: message.text,
          );
        }
      }

      // Update all chat history sessions
      chatHistory.forEach((sessionId, chatModel) {
        final updatedMessages =
            chatModel.messages.map((message) {
              if (message.user.id == currentUser.id) {
                return ChatMessage(
                  user: ChatUser(
                    id: message.user.id,
                    firstName: message.user.firstName,
                    lastName: message.user.lastName,
                    profileImage: newPhotoUrl,
                  ),
                  createdAt: message.createdAt,
                  text: message.text,
                );
              }
              return message;
            }).toList();

        _model.updateChatService(
          ChatModel(
            id: chatModel.id,
            title: chatModel.title,
            messages: updatedMessages,
          ),
        );
      });
    });

    // Persist updated chat history
    _persistChatHistory();
  }

  void _initializeNewChatSession() {
    print("====================> model is: $selectedModel");
    _currentChatSession = _groq.startNewChat(
      _selectedModel, // Use the selected model from settings
      settings: GroqChatSettings(
        temperature: _temperature,
        maxTokens: 512,
      ), // Use temperature from settings
    );

    // Send system prompt
    final message = "initialPrompt".tr();
    _currentChatSession!.sendMessage(message, role: GroqMessageRole.system);
  }

  void scrollToBottom(ScrollController controller) {
    if (controller.hasClients) {
      controller.animateTo(
        controller.position.minScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // == VOICE LOGIC ==
  // Future<void> toggleVoiceRecording(BuildContext context) async {
  //   try {
  //     if (!isRecording) {
  //       isRecording = true;
  //       setState(() {
  //         _model.recordingStartTime = DateTime.now();
  //       });
  //       await voiceService.startListening();
  //     } else {
  //       await voiceService.stopListening();
  //       isRecording = false;
  //
  //       final transcribedText = voiceService.wordsSpoken.trim();
  //       if (transcribedText.isEmpty || voiceService.confidence < 0.4) {
  //         throw 'Could not understand speech clearly.';
  //       }
  //
  //       await getChatResponse(
  //         message: ChatMessage(
  //           user: currentUser,
  //           createdAt: DateTime.now(),
  //           text: transcribedText,
  //         ),
  //         setState: setState,
  //       );
  //     }
  //   } catch (e) {
  //     print('Speech error: $e');
  //     isRecording = false;
  //
  //     if (!context.mounted) return;
  //     print('error is =========================> ${e.toString()}');
  //     showFailedSnackBar(context, title: e.toString());
  //   }
  // }

  // == CHAT & HISTORY LOGIC ==
  Future<void> loadChatHistory() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    String? jsonString = await SecureStorageHelper.readValueFromKey(
      key: 'chatHistory_$userId',
    );

    // If the data is not found in secure storage, fetch it from Firestore
    if (jsonString == null) {
      try {
        final doc =
            await FirebaseFirestore.instance
                .collection('chat_histories')
                .doc(userId)
                .get();

        if (doc.exists && doc.data()?['data'] != null) {
          final dataField = doc.data()?['data'];

          if (dataField is List) {
            // Convert Firestore data to ChatService objects
            List<ChatModel> services =
                dataField.map((entry) {
                  final map = Map<String, dynamic>.from(entry);
                  return ChatModel.fromJson(map);
                }).toList();

            // Optionally, map to a chatHistory map for easy access later
            Map<String, ChatModel> historyCopy = {
              for (final service in services) service.id: service,
            };

            // Flatten all messages from all services
            final allMessages = services.expand((s) => s.messages).toList();

            // Save chat history and all messages to secure storage
            await SecureStorageHelper.writeValueToKey(
              key: 'chatHistory_$userId',
              value: jsonEncode(
                historyCopy.values.map((e) => e.toJson()).toList(),
              ),
            );

            await SecureStorageHelper.writeValueToKey(
              key: 'chatMessages_$userId',
              value: jsonEncode(allMessages.map((m) => m.toJson()).toList()),
            );

            // Debug logs
            print(
              "===============================> saving chat history: ${historyCopy.values.map((e) => e.title)}",
            );
            print(
              "===============================> saving chat messages: ${allMessages.length}",
            );
            print(
              '===============================> Fetched and saved chat history from Firestore for chatHistory_$userId.',
            );

            // Now, update the UI by calling setState after fetching from Firestore
            setState(() {
              // Add entries to chatHistory via model (trigger UI update)
              for (final service in services) {
                _model.addChatService(service);
              }
            });
          } else {
            print(
              '===============================> No valid "data" field in Firestore document for $userId.',
            );
          }
        } else {
          print(
            '===============================> No chat history found in Firestore for $userId.',
          );
        }
      } catch (e) {
        print(
          '===============================> Error fetching chat history from Firestore: $e',
        );
      }
    }

    // If we found the chat history in secure storage, load it into the local variable
    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        setState(() {
          for (var json in jsonList) {
            final session = ChatModel.fromJson(json);
            _model.addChatService(session);
          }
        });
      } catch (e) {
        print('Error decoding chat history: $e');
      }
    }

    // Ensure all loaded chat messages have the most current profile image
    if (user?.photoURL != null) {
      _updateUserInChatHistory(user!.photoURL!);
    }

    // Reverse the order of messages when displaying them, if necessary
    _model.messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    setState(() {}); // Trigger a rebuild to update the UI
  }

  Future<void> getChatResponse({
    required ChatMessage message,
    required void Function(void Function()) setState,
  }) async {
    setState(() {
      _model.addMessage(message);
      _model.setTyping(true);
    });

    try {
      if (_currentChatSession == null) {
        _initializeNewChatSession();

        // Add history messages to the new chat session
        for (final msg in messages.reversed.skip(1)) {
          if (msg.user.id == currentUser.id) {
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
            _model.setTyping(false);
            _model.addMessage(
              ChatMessage(
                user: grokChatUser,
                createdAt: DateTime.now(),
                text: choice.message.trim(),
              ),
            );
          });
        }
      }

      await saveCurrentChatSession(clearMessages: false);
    } catch (e) {
      print('Error during chat response: $e');
    } finally {
      setState(() => _model.setTyping(false));
    }
  }

  Future<void> saveCurrentChatSession({bool clearMessages = true}) async {
    if (messages.isEmpty) return;

    String uniqueId = currentSessionId ?? _uuid.v4();
    String summaryTitle = "New Chat";
    bool shouldGenerateTitle = true;

    if (currentSessionId != null) {
      final existingSession = chatHistory[currentSessionId]!;
      if (_areMessagesEqual(messages, existingSession.messages)) {
        summaryTitle = existingSession.title;
        shouldGenerateTitle = false;
      }
    }

    if (shouldGenerateTitle) {
      final chatSession = _groq.startNewChat(_selectedModel);
      final message = "initialPrompt".tr();
      chatSession.sendMessage(message, role: GroqMessageRole.system);
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
      final newService = ChatModel(
        id: uniqueId,
        title: summaryTitle,
        messages: List.from(messages),
      );
      _model.addChatService(newService);

      if (clearMessages) {
        _model.resetSession();
      } else {
        _model.currentSessionId = uniqueId;
      }
    });

    await _persistChatHistory();
  }

  Future<void> loadChatSession(ChatModel session) async {
    if (messages.isNotEmpty && currentSessionId == null) {
      await saveCurrentChatSession();
    }

    _currentChatSession = null;
    setState(() {
      _model.resetSession();
      for (var message in session.messages.reversed) {
        _model.addMessage(message);
      }
      _model.currentSessionId = session.id;
    });

    _initializeNewChatSession();

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
      _model.deleteChatService(sessionId);

      if (currentSessionId == sessionId) {
        _model.resetSession();
      }
    });

    // First persist to local storage
    await _persistChatHistory();

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

    await SecureStorageHelper.writeValueToKey(
      key: "chatHistory_$userId",
      value: jsonEncode(jsonList),
    );

    try {
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('chat_histories').doc(userId).update({
        'data': jsonList,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error saving chat history to Firestore: $e');
    }
  }

  // Clean up resources
  void dispose() {
    _profileSubscription.cancel();
    _settingsSubscription.cancel();
  }
}
