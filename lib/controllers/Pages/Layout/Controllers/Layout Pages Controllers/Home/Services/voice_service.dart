import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class VoiceService {
  //TODO: make sure locale works
  final SpeechToText _speechToText = SpeechToText();

  bool isRecording = false;
  bool speechEnabled = false;
  String wordsSpoken = '';
  double confidence = 0.0;
  String selectedLocaleId = '';

  // Initialize speech recognition
  Future<void> _init() async {
    speechEnabled = await _speechToText.initialize(
      finalTimeout: const Duration(minutes: 1),
    );
  }

  // Get the list of available locales
  Future<List<LocaleName>> getAvailableLocales() async {
    return await _speechToText.locales();
  }

  // Set the selected language for recognition
  Future<void> selectLocale(String localeId) async {
    selectedLocaleId = localeId;
  }

  // Start listening with the selected locale from EasyLocalization
  Future<void> startListening(context) async {
    if (!speechEnabled) {
      await _init();
    }

    isRecording = true;
    wordsSpoken = '';
    confidence = 0.0;

    // Get the current locale from EasyLocalization
    final currentLocale = context.locale.toString(); // Gets the current locale as a string like 'en_US'

    // If no locale has been selected, use the current EasyLocalization locale
    if (selectedLocaleId.isEmpty) {
      final availableLocales = await getAvailableLocales();
      final locale = availableLocales.firstWhere(
            (locale) => locale.localeId.startsWith(currentLocale),
        orElse: () => availableLocales.first, // Fallback to the first available locale
      );
      selectedLocaleId = locale.localeId;
    }

    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(minutes: 1),
      pauseFor: const Duration(seconds: 3),
      localeId: selectedLocaleId,  // Use the selected localeId here
    );
  }

  // Stop listening
  Future<void> stopListening() async {
    if (!isRecording) return;

    await _speechToText.stop();
    isRecording = false;
  }

  // Handle speech result
  void _onSpeechResult(SpeechRecognitionResult result) {
    wordsSpoken = result.recognizedWords;
    confidence = result.confidence;
  }
}