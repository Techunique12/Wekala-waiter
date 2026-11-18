import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wekala_waiter/core/extensions/build_context_extension.dart';
import 'package:wekala_waiter/core/extensions/date_time_extensions.dart';

class CurrentDateTimeWidget extends StatefulWidget {
  const CurrentDateTimeWidget({super.key});

  @override
  State<CurrentDateTimeWidget> createState() => _CurrentDateTimeWidgetState();
}

class _CurrentDateTimeWidgetState extends State<CurrentDateTimeWidget> {
  late DateTime _now;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _now = DateTime.now();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;

      setState(() {
        _now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(_now.formatDate, style: TextStyle(fontSize: context.smallFont)),
        ],
      ),
    );
  }
}
