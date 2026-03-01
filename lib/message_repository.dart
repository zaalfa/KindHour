import 'dart:convert';
import 'package:flutter/services.dart';

class MessageRepository {
  static Future<Map<String, List<String>>> loadMessages() async {
    final String jsonString = await rootBundle.loadString(
      'assets/messages.json',
    );
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    return jsonMap.map((key, value) => MapEntry(key, List<String>.from(value)));
  }
}
