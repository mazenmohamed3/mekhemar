import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class VoiceService {
  final SpeechToText _speechToText = SpeechToText();

  bool isRecording = false;
  bool speechEnabled = false;
  String wordsSpoken = '';
  double confidence = 0.0;

  Future<void> _init() async {
    speechEnabled = await _speechToText.initialize(
      finalTimeout: const Duration(minutes: 1),
    );
  }

  Future<void> startListening() async {
    if (!speechEnabled) {
      await _init();
    }

    isRecording = true;
    wordsSpoken = '';
    confidence = 0.0;

    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(minutes: 1),
      pauseFor: const Duration(seconds: 3),
    );
  }

  Future<void> stopListening() async {
    if (!isRecording) return;

    await _speechToText.stop();
    isRecording = false;
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    wordsSpoken = result.recognizedWords;
    confidence = result.confidence;
  }
}