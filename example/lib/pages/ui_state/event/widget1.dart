import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:state/logic.dart';
import 'package:state/event.dart';
import 'package:state/state_widget.dart';

class Widegt1 extends StatelessWidget {
  const Widegt1({super.key});

  @override
  Widget build(BuildContext context) {
    return StateWidget(
      logic: Widget1Logic.new,
      builder: (logic) {
        return Container(
            height: 200,
            padding: const EdgeInsets.all(20),
            color: Colors.red,
            child: Column(
              children: [
                FilledButton(
                    onPressed: logic.onSendPressed,
                    child: const Text("Widegt1Event")),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: SingleChildScrollView(
                        child: Text("收到:${logic.state.msg}")))
              ],
            ));
      },
    );
  }
}

class _State {
  String msg = "";
}

class Widget1Logic extends Logic<Widget1Logic, _State> with LogicEventMixIn {
  Widget1Logic(super.context);
  @override
  void onInit() {
    super.onInit();
    state = _State();
    setInteresting(['Widget2Event']);
  }

  @override
  void onEvent(LogicEvent event) {
    state.msg += "\n${event.name}";
    update();
  }

  void onSendPressed() {
    publish('Widget1Event'.event());
  }
}
