import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class MessageSelector {
  static Future<String> getMessage({
    required String timeBlock,
    required List<String> messages,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final savedBlock = prefs.getString('saved_time_block');
    final savedMessage = prefs.getString('saved_message');

    // If we're in the same block and already have a message, return it
    if (savedBlock == timeBlock && savedMessage != null) {
      return savedMessage;
    }

    // New block — pick a new random message
    final random = Random();
    final selected = messages[random.nextInt(messages.length)];

    await prefs.setString('saved_time_block', timeBlock);
    await prefs.setString('saved_message', selected);

    return selected;
  }
}
