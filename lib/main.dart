import 'package:flutter/material.dart';
import 'time_classifier.dart';
import 'message_repository.dart';
import 'message_selector.dart';
import 'package:home_widget/home_widget.dart';

void main() {
  runApp(const KindHourApp());
}

class KindHourApp extends StatelessWidget {
  const KindHourApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: KindHourScreen(),
    );
  }
}

class KindHourScreen extends StatefulWidget {
  const KindHourScreen({super.key});

  @override
  State<KindHourScreen> createState() => _KindHourScreenState();
}

class _KindHourScreenState extends State<KindHourScreen> {
  String _message = '';
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadMessage();
  }

  Future<void> _loadMessage() async {
    final timeBlock = TimeClassifier.classify(DateTime.now());
    final allMessages = await MessageRepository.loadMessages();
    final message = await MessageSelector.getMessage(
      timeBlock: timeBlock,
      messages: allMessages[timeBlock]!,
    );
    // Push message to widget
    await HomeWidget.saveWidgetData<String>('kind_hour_message', message);
    await HomeWidget.updateWidget(androidName: 'KindHourWidgetProvider');

    setState(() {
      _message = message;
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: _loaded
              ? Text(
                  _message,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                )
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
