import 'dart:async';

import 'package:flutter/material.dart';

/// Boots the Flutter app and points it at [MyApp].
void main() {
  runApp(const MyApp());
}

/// Provides the global theme (Roboto everywhere, Metal Mania for the app bar)
/// and loads the single clicker screen.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData base = ThemeData(
      brightness: Brightness.dark,
      fontFamily: 'Roboto',
    );

    final TextTheme textTheme = base.textTheme
        .apply(
          bodyColor: Colors.yellowAccent,
          displayColor: Colors.yellowAccent,
        )
        .copyWith(
          displayLarge: base.textTheme.displayLarge?.copyWith(
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
            color: Colors.yellowAccent,
          ),
          headlineMedium: base.textTheme.headlineMedium?.copyWith(
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: base.textTheme.titleLarge?.copyWith(
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
          ),
        );

    return MaterialApp(
      title: '🔥 Ultimate Clicker 🔥',
      debugShowCheckedModeBanner: false,
      theme: base.copyWith(
        scaffoldBackgroundColor: Colors.black,
        textTheme: textTheme,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 111, 86, 86),
          brightness: Brightness.dark,
          primary: Colors.redAccent,
          secondary: Colors.yellowAccent,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          titleTextStyle: const TextStyle(
            fontFamily: 'MetalMania',
            color: Colors.white,
            fontSize: 32,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.black,
            textStyle: textTheme.headlineMedium?.copyWith(fontSize: 24),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
      home: const MyHomePage(title: '🔥 Ultimate Clicker 🔥'),
    );
  }
}

/// Single-screen game where players start a 10-second timer and mash the clicker
/// to beat their previous best.
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0; // Number of taps in the current round.
  int _topScore = 0; // Highest number of taps since the app launched.
  static const int _initialTimerSeconds = 10;
  int _remainingSeconds = _initialTimerSeconds;
  Timer? _timer;
  bool _isTimerActive = false; // True only while the countdown runs.

  void _incrementCounter() {
    if (_remainingSeconds == 0 || !_isTimerActive) {
      return;
    }
    setState(() {
      _counter++;
    });
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = _initialTimerSeconds;
      _counter = 0;
      _isTimerActive = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_remainingSeconds == 0) {
        timer.cancel();
        if (mounted) {
          setState(() {
            _isTimerActive = false;
          });
        }
        return;
      }
      setState(() {
        _remainingSeconds--;
        if (_remainingSeconds == 0 && _counter > _topScore) {
          _topScore = _counter;
          _isTimerActive = false;
        }
      });
    });
  }

  String get _formattedTime {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title, textAlign: TextAlign.center)),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Top Score: $_topScore',
                        key: const ValueKey('topScoreText'),
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(color: Colors.redAccent),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'When the timer starts, click the clicker as fast as possible.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.yellowAccent,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        '$_counter',
                        key: const ValueKey('counterText'),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displayLarge
                            ?.copyWith(fontSize: 96, color: Colors.redAccent),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Timer: $_formattedTime',
                        key: const ValueKey('timerText'),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(color: Colors.yellowAccent),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        key: const ValueKey('startTimerButton'),
                        onPressed: _startTimer,
                        child: const Text(
                          'Start 10 Second Timer',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        key: const ValueKey('clickerButton'),
                        onPressed: _isTimerActive && _remainingSeconds > 0
                            ? _incrementCounter
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellowAccent,
                          foregroundColor: Colors.black,
                          minimumSize: const Size(double.infinity, 72),
                          textStyle: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(color: Colors.black),
                        ),
                        child: const Text(
                          'Tap Clicker',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "Created by Spencer's Robot",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          letterSpacing: 1.2,
                          fontFamily: 'MetalMania',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
