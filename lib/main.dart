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
  bool _isMonochrome = false;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadMessage();
  }

  Future<void> _loadMessage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString('kind_hour_theme') ?? 'pastel';

    // DEBUG - hapus setelah confirmed working
    final debugPrefs = await SharedPreferences.getInstance();
    print('DEBUG all keys: ${debugPrefs.getKeys()}');

    final timeBlock = TimeClassifier.classify(DateTime.now());
    final allMessages = await MessageRepository.loadMessages();
    final message = await MessageSelector.getMessage(
      timeBlock: timeBlock,
      messages: allMessages[timeBlock]!,
    );

    // Push to widget
    await HomeWidget.saveWidgetData<String>('kind_hour_message', message);
    await HomeWidget.saveWidgetData<String>('kind_hour_theme', savedTheme);
    await HomeWidget.saveWidgetData<String>('saved_time_block', timeBlock);
    await HomeWidget.updateWidget(androidName: 'KindHourWidgetProvider');

    setState(() {
      _message = message;
      _timeBlock = timeBlock;
      _isMonochrome = savedTheme == 'monochrome';
      _loaded = true;
    });
  }

  Future<void> _toggleTheme() async {
    final newIsMonochrome = !_isMonochrome;
    final newTheme = newIsMonochrome ? 'monochrome' : 'pastel';

    // Save theme preference
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('kind_hour_theme', newTheme);

    // Push new theme to widget
    await HomeWidget.saveWidgetData<String>('kind_hour_theme', newTheme);
    await HomeWidget.updateWidget(androidName: 'KindHourWidgetProvider');

    setState(() {
      _isMonochrome = newIsMonochrome;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _isMonochrome
        ? ThemeConfig.getMonochromeBackground(_timeBlock)
        : ThemeConfig.getPastelBackground(_timeBlock);
    final textColor = ThemeConfig.getTextColor(_timeBlock, _isMonochrome);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            // Message
            Padding(
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
                  : CircularProgressIndicator(color: textColor),
            ),

            const Spacer(),

            // Theme toggle button
            Padding(
              padding: const EdgeInsets.only(bottom: 48.0),
              child: GestureDetector(
                onTap: _toggleTheme,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: textColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: textColor.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _isMonochrome ? '🌑  Monochrome' : '🌸  Pastel',
                        style: TextStyle(
                          fontSize: 14,
                          color: textColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '→ Switch',
                        style: TextStyle(
                          fontSize: 14,
                          color: textColor.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
