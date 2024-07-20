import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ile do wyjścia z kołchozu',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Ile do wyjścia z kołchozu'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum WorkState { beforeWork, atWork, afterWork, noWork }

class _MyHomePageState extends State<MyHomePage> {
  bool lol = false;
  String currentDayOfTheWeek() {
    initializeDateFormatting();
    final DateFormat dateFormat = DateFormat.EEEE('pl_PL');

    // Get the current date and time
    final DateTime now = DateTime.now();

    // Format the current date to get the day of the week in Polish
    final String dayOfWeek = dateFormat.format(now);

    // Use these lines for testing
    // return "poniedziałek";
    // return "sobota";
    return dayOfWeek;
  }

// it's used for mocking
  DateTime getNow() {
    var now = DateTime.now();
    return now;
    // return DateTime(now.year, now.month, now.day, 11, 0, 0);
  }

  bool isWorkday() {
    var day = currentDayOfTheWeek();
    var isWeekend = day == "sobota" || day == "niedziela";
    return !isWeekend;
  }

  WorkState getWorkState() {
    if (!isWorkday()) return WorkState.noWork;

    // Get the current date and time
    final DateTime now = getNow();

    // Create DateTime objects for 8:00 AM and 4:00 PM of the current day
    final DateTime eightAM = DateTime(now.year, now.month, now.day, 8, 0, 0);
    final DateTime fourPM = DateTime(now.year, now.month, now.day, 16, 0, 0);

    // Check the time and print the appropriate message
    if (now.isBefore(eightAM)) {
      return WorkState.beforeWork;
    } else if (now.isAfter(fourPM)) {
      return WorkState.afterWork;
    } else {
      return WorkState.atWork;
    }
  }

  String calcTimeUntil(int hour) {
    // Get the current date and time
    final DateTime now = getNow();

    final DateTime targetTime =
        DateTime(now.year, now.month, now.day, hour, 0, 0);

    // Calculate the difference between the current time and 16:00
    Duration difference = targetTime.difference(now);

    // If the target time is in the past, set the target time to 16:00 of the next day
    if (difference.isNegative) {
      final DateTime nextDayTargetTime =
          targetTime.add(const Duration(days: 1));
      difference = nextDayTargetTime.difference(now);
    }

    // Format the remaining time
    final int hours = difference.inHours;
    final int minutes = difference.inMinutes.remainder(60);
    final int seconds = difference.inSeconds.remainder(60);

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String calcTimeUntilWork() {
    return calcTimeUntil(8);
  }

  String calcTimeUntilEndOfWork() {
    return calcTimeUntil(16);
  }

  @override
  Widget build(BuildContext context) {
    var day = currentDayOfTheWeek();
    var workState = getWorkState();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Dzisiaj jest $day, ${getNow().toLocal()}"),
            if (workState == WorkState.noWork)
              const Text("Nie ma Cię dzisiaj w kołchozie :D"),
            if (workState == WorkState.atWork)
              Text(
                  "Do wyjścia z kołchozu pozostało ${calcTimeUntilEndOfWork()}"),
            if (workState == WorkState.beforeWork)
              Text("Do wejścia do kołchozu pozostało ${calcTimeUntilWork()}"),
            if (workState == WorkState.afterWork)
              const Text("Już nie jesteś w kołchozie :)"),
            TextButton(
                onPressed: () {
                  setState(() {
                    lol = !lol;
                  });
                },
                child: const Text("Odśwież"))
          ],
        ),
      ),
    );
  }
}
