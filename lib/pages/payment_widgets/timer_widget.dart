import 'dart:async';

import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({
    Key? key,
    required this.start,
    this.textStyle,
  }) : super(key: key);

  final TextStyle? textStyle;
  final DateTime start;

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), updateTimer);
    super.initState();
  }

  void updateTimer(Timer timer) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Material widget for nicer animations
    return Material(
      color: Colors.transparent,
      child: Text(
        DateTime.now().difference(widget.start).toPrettyString(),
        maxLines: 2,
        style: widget.textStyle,
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}

extension DurationToString on Duration {
  static const _hoursInDays = 24;
  static const _minutesInHours = 60;
  static const _secondsInMinutes = 60;

  String toPrettyString({bool showSeconds = true}) {
    final days = inDays.toInt();
    final hours = (inHours % _hoursInDays).toInt();
    final minutes = (inMinutes % _minutesInHours).toInt();
    final seconds = (inSeconds % _secondsInMinutes);

    var prettyString = '';
    if (days > 0) {
      prettyString += '$days day';
      if (days > 1) {
        prettyString += 's';
      }
      prettyString += ', ';
    }

    if (hours >= 0) {
      if (hours < 10) {
        prettyString += '0';
      }
      prettyString += '$hours:';
    }
    if (minutes < 10) {
      prettyString += '0';
    }
    prettyString += '$minutes';
    if (showSeconds) {
      prettyString += ':';
      if (seconds < 10) {
        prettyString += '0';
      }
      prettyString += '$seconds';
    }
    return prettyString;
  }
}
