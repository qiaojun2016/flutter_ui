import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'widegt2.dart';
import 'widget1.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
      child: Center(
        child: Row(children: [Expanded(child: Widegt1()), Expanded(
          child: Widegt2(),
        )]),
      ),
    ),
    );

  }
}
