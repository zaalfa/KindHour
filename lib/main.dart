import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:home_widget/home_widget.dart';
import 'package:workmanager/workmanager.dart';
import 'time_classifier.dart';
import 'message_repository.dart';
import 'message_selector.dart';
import 'theme_config.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final prefs = await SharedPreferences.getInstance();
    final message =
        prefs.getString('saved_message') ?? 'You\'re doing great 🌸';
    await HomeWidget.saveWidgetData<String>('kind_hour_message', message);
    await HomeWidget.updateWidget(androidName: 'KindHourWidgetProvider');
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Workmanager().initialize(callbackDispatcher);
  await Workmanager().registerPeriodicTask(
    'kindhour-widget-refresh',
    'widgetRefresh',
    frequency: const Duration(hours: 1),
  );
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
  String _timeBlock = 'morning';
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
    await HomeWidget.saveWidgetData<String>('kind_hour_message', message);
    await HomeWidget.updateWidget(androidName: 'KindHourWidgetProvider');

    setState(() {
      _message = message;
      _timeBlock = timeBlock;
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = ThemeConfig.getPastelBackground(_timeBlock);
    final textColor = ThemeConfig.getTextColor(_timeBlock, false);

    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: _loaded
              ? Text(
                  _message,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    color: textColor,
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
