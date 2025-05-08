import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../../Repos/local/secure_storage_helper.dart';
import '../../../Router/app_page.dart';

class OnboardingController {
  String displayedText = "";
  int _textIndex = 0;
  bool showButtons = false;
  bool showCursor = true; // Cursor blinking state

  final String _welcomeText = "welcomeText".tr();
  final String _languagePrompt = "languagePrompt".tr();

  Timer? _typingTimer;
  Timer? _cursorTimer;

  late void Function(void Function()) setCursorState;
  late void Function(void Function()) setTextState;
  late void Function(void Function()) setShowButtonsState;

  // Function to make the cursor blink after the typing is complete
  void _startCursorBlinking() {
    _cursorTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setCursorState(() {
        showCursor =
        !showCursor; // Rebuild the cursor state using setCursorState
      });
    });
  }

  void init() {
    _startTypingWelcome();
    _startCursorBlinking();
  }

  // Function to start typing the welcome text
  void _startTypingWelcome() {
    _typingTimer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
      if (_textIndex < _welcomeText.length) {
        setTextState(() {
          displayedText += _welcomeText[_textIndex];
          _textIndex++;
        });
      } else {
        timer.cancel();
        Future.delayed(const Duration(seconds: 2), _startDeleting);
      }
    });
  }

  // Function to delete the typed text
  void _startDeleting() {
    _typingTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (displayedText.isNotEmpty) {
        setTextState(() {
          displayedText = displayedText.substring(
            0,
            displayedText.length - 1,
          );
        });
      } else {
        timer.cancel();
        _startTypingLanguagePrompt();
      }
    });
  }

  // Function to type the "Please choose your language" text with underscore at the end
  void _startTypingLanguagePrompt() {
    _textIndex = 0;
    _typingTimer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
      if (_textIndex < _languagePrompt.length) {
        setTextState(() {
          displayedText += _languagePrompt[_textIndex];
          _textIndex++;
        });
      } else {
        timer.cancel();
        setShowButtonsState(() {
          showButtons = true;
        });
      }
    });
  }

  void onEnglishPressed(BuildContext context) async {
    await SecureStorageHelper.writeValueToKey(
      key: 'isFirstTime',
      value: 'false',
    );
    if(!context.mounted) return;
    context.setLocale(Locale('en'));
    context.go(AppPage.login);
  }

  void onArabicPressed(BuildContext context) async {
    await SecureStorageHelper.writeValueToKey(
      key: 'isFirstTime',
      value: 'false',
    );
    if(!context.mounted) return;
    context.setLocale(Locale('ar'));
    context.go(AppPage.login);
  }

  void dispose() {
    _typingTimer?.cancel();
    _cursorTimer?.cancel();
  }
}