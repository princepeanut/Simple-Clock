import 'package:flutter/material.dart';
import 'dart:async';
import 'package:octal_clock/octal_clock.dart';

void main() => runApp(new MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Test",
      home: new ClockPage(),
    );
  }
}

class ClockPage extends StatefulWidget {
  ClockPage({Key key}) : super(key: key);

  ClockState createState() => new ClockState();
}

class ClockState extends State<ClockPage> {
  Timer _timer; // tracks our periodic updates
  OctalDateTime _time; // tracks our current octal time

  @override
  void initState() {
    super.initState();
    // We start at the current time
    _time = new OctalDateTime.now();

    // We want to update 4 times per second
    // so we can display millisecond values as well
    const duration = const Duration(
        milliseconds: OctalDuration.MILLISECONDS_PER_SECOND ~/ 4);
    // Our periodic timer for when to update our time
    _timer = new Timer.periodic(duration, _updateTime);
  }

  @override
  void dispose() {
    // Make sure to cancel the timer when we dispose the view
    _timer.cancel();
    super.dispose();
  }

  void _updateTime(Timer _) {
    // Update our state with the new time and force a redraw
    setState(() {
      _time = new OctalDateTime.now();
    });
  }
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    // 0-padding for hours/minutes/seconds
    String twoDigits(int d) {
      if (d < 10) return '0$d';
      return d.toString();
    }

    // 0-padding for milliseconds
    String threeDigits(int d) {
      if (d < 10) return '00$d';
      if (d < 100) return '0$d';
      return d.toString();
    }

    // Helper to make pretty time
    String formatTime(date) {
      return '${twoDigits(date.hour)}:${twoDigits(date.minute)}:${twoDigits(
          date.second)}';
    }

    // Things we are going to display
    final String time = formatTime(_time);

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Clock'),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(time, style: themeData.textTheme.display1),
          ],
        ),
      ),
    );
  }
}
