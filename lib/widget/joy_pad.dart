import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

///
/// Created by iceKylin on 2021/6/9
///
/// 游戏手柄UI

/// joy pad按键
class JoyPadKey {
  final String description;

  const JoyPadKey(this.description);

  @override
  String toString() {
    return "${this.runtimeType}($description)";
  }
}

/// 方向键
class DirectionPadKey extends JoyPadKey {
  const DirectionPadKey._(String description) : super(description);

  static const DirectionPadKey Left = DirectionPadKey._("Left");
  static const DirectionPadKey Top = DirectionPadKey._("Top");
  static const DirectionPadKey Right = DirectionPadKey._("Right");
  static const DirectionPadKey Bottom = DirectionPadKey._("Bottom");

  static const List<DirectionPadKey> values = [Left, Top, Right, Bottom];
}

/// 控制键
class ControlPadKey extends JoyPadKey {
  const ControlPadKey._(String description) : super(description);

  static const ControlPadKey Start = ControlPadKey._("S / P");
  static const ControlPadKey Select = ControlPadKey._("SELECT");
  static const ControlPadKey Exit = ControlPadKey._("EXIT");
  static const ControlPadKey Reset = ControlPadKey._("RESET");

  static const List<ControlPadKey> values = [Start, Select, Exit, Reset];
}

/// 动作键
class ActionPadKey extends JoyPadKey {
  const ActionPadKey._(String description) : super(description);

  static const ActionPadKey A1 = ActionPadKey._("A1");
  static const ActionPadKey A2 = ActionPadKey._("A2");
  static const ActionPadKey B1 = ActionPadKey._("B1");
  static const ActionPadKey B2 = ActionPadKey._("B2");
  static const ActionPadKey AB1 = ActionPadKey._("AB1");
  static const ActionPadKey AB2 = ActionPadKey._("AB2");

  static const List<ActionPadKey> values = [A1, A2, B1, B2, AB1, AB2];
}

/// 点击动作
enum PadTapAction { Press, Release, Click, LongPress, LongPressEnd }

/// 按键点击事件
typedef JoyPadTap = void Function(JoyPadKey, PadTapAction);

/// JoyPad UI
class JoyPad extends StatelessWidget {
  final Widget game;
  final JoyPadTap padTap;

  const JoyPad({required this.game, required this.padTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Center(child: game),
          Align(
            alignment: Alignment.topCenter,
            child: ControlPad(controlPadTap: padTap),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            // child: DirectionPad(directionPadTap: padTap),
            child: DirectionJoyStick(padTap: padTap),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: ActionPad(actionPadTap: padTap),
          ),
        ],
      ),
    );
  }
}

/// 方向键（上下左右）
class DirectionPad extends StatelessWidget {
  final JoyPadTap directionPadTap;

  const DirectionPad({required this.directionPadTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 200,
        height: 200,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(200),
          color: Colors.grey.withOpacity(0.4),
        ),
        child: Stack(
          children: DirectionPadKey.values.map((e) => DirectionPadButton(e, padTap: directionPadTap)).toList(),
        ));
  }
}

class DirectionPadButton extends StatelessWidget {
  final DirectionPadKey directionPadKey;
  final JoyPadTap padTap;

  const DirectionPadButton(this.directionPadKey, {required this.padTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: _alignment,
      child: SizedBox(
        width: _size.width,
        height: _size.height,
        child: JoyPadButton(
          padKey: directionPadKey,
          padTap: padTap,
          borderRadius: BorderRadius.circular(10),
          child: RotatedBox(
            quarterTurns: _turn,
            child: Image.asset("assets/joypad/direction.png"),
          ),
        ),
      ),
    );
  }

  Alignment get _alignment {
    switch (directionPadKey) {
      case DirectionPadKey.Left:
        return Alignment.centerLeft;
      case DirectionPadKey.Right:
        return Alignment.centerRight;
      case DirectionPadKey.Top:
        return Alignment.topCenter;
      case DirectionPadKey.Bottom:
        return Alignment.bottomCenter;
      default:
        return Alignment.center;
    }
  }

  Size get _size {
    final double width = 90;
    final double height = 45;
    switch (directionPadKey) {
      case DirectionPadKey.Left:
      case DirectionPadKey.Right:
        return Size(width, height);
      case DirectionPadKey.Top:
      case DirectionPadKey.Bottom:
        return Size(height, width);
      default:
        return Size.zero;
    }
  }

  int get _turn {
    switch (directionPadKey) {
      case DirectionPadKey.Left:
        return 2;
      case DirectionPadKey.Right:
        return 0;
      case DirectionPadKey.Top:
        return 3;
      case DirectionPadKey.Bottom:
        return 1;
      default:
        return 0;
    }
  }
}

/// 控制键 （开始/暂停、选择、退出、重置）
class ControlPad extends StatelessWidget {
  final JoyPadTap controlPadTap;

  const ControlPad({required this.controlPadTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.all(20),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 180,
              child: Row(
                children: [
                  Expanded(
                    child: ControlPadButton(
                      ControlPadKey.Exit,
                      padTap: controlPadTap,
                      color: Colors.redAccent,
                      icon: Icons.arrow_back_ios,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ControlPadButton(
                      ControlPadKey.Reset,
                      padTap: controlPadTap,
                      color: Colors.green,
                      icon: Icons.refresh,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 180,
              child: Row(
                children: [
                  Expanded(
                    child: ControlPadButton(
                      ControlPadKey.Start,
                      padTap: controlPadTap,
                      color: Colors.redAccent,
                      icon: Icons.radio_button_off,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ControlPadButton(
                      ControlPadKey.Select,
                      padTap: controlPadTap,
                      color: Colors.blueAccent,
                      icon: Icons.change_history_rounded,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ControlPadButton extends StatelessWidget {
  final JoyPadTap padTap;
  final ControlPadKey padKey;
  final IconData? icon;
  final Color? color;

  const ControlPadButton(this.padKey, {required this.padTap, this.icon, this.color, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey.withOpacity(0.4)),
      child: JoyPadButton(
        padKey: padKey,
        padTap: padTap,
        singleClick: true,
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 18,
            ),
            Padding(
              padding: EdgeInsets.only(left: 5, top: 2),
              child: Text(
                padKey.description,
                style: TextStyle(color: color),
              ),
            ),
          ],
        )),
      ),
    );
  }
}

/// 操作键（A、B）
class ActionPad extends StatelessWidget {
  final JoyPadTap actionPadTap;

  const ActionPad({required this.actionPadTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 280,
      margin: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ActionPadButton(
                ActionPadKey.A1,
                padTap: actionPadTap,
                backgroundColor: Colors.purpleAccent,
              ),
              ActionPadButton(
                ActionPadKey.B1,
                padTap: actionPadTap,
                backgroundColor: Colors.green,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ActionPadButton(
                ActionPadKey.A2,
                padTap: actionPadTap,
                backgroundColor: Colors.purpleAccent,
              ),
              ActionPadButton(
                ActionPadKey.B2,
                padTap: actionPadTap,
                backgroundColor: Colors.green,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ActionPadButton(
                ActionPadKey.AB1,
                padTap: actionPadTap,
                backgroundColor: Colors.blueAccent,
              ),
              ActionPadButton(
                ActionPadKey.AB2,
                padTap: actionPadTap,
                backgroundColor: Colors.blueAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ActionPadButton extends StatelessWidget {
  final JoyPadTap padTap;
  final JoyPadKey padKey;
  final Color? backgroundColor;

  const ActionPadButton(this.padKey, {required this.padTap, Key? key, this.backgroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return JoyPadButton(
      singleClick: _singleClick,
      padTap: padTap,
      padKey: padKey,
      borderRadius: BorderRadius.circular(80),
      child: Container(
        width: 80,
        height: 80,
        child: Center(
          child: CircleAvatar(
            backgroundColor: backgroundColor,
            radius: 32,
            child: Text(padKey.description),
          ),
        ),
      ),
    );
  }

  bool get _singleClick => padKey.description.endsWith("1");
}

/// 按键包装
class JoyPadButton extends StatelessWidget {
  final bool singleClick;
  final bool longPress;
  final JoyPadTap padTap;
  final JoyPadKey padKey;
  final Widget? child;
  final BorderRadius? borderRadius;

  const JoyPadButton({
    Key? key,
    required this.padKey,
    required this.padTap,
    this.child,
    this.borderRadius,
    this.singleClick = false,
    this.longPress = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressEnd: (details) {
        padTap(padKey, PadTapAction.LongPressEnd);
      },
      onLongPress: () {
        padTap(padKey, PadTapAction.LongPress);
      },
      child: InkWell(
        borderRadius: borderRadius,
        onTap: () {
          if (singleClick) {
            padTap(padKey, PadTapAction.Click);
          } else {
            padTap(padKey, PadTapAction.Release);
          }
        },
        onTapDown: (details) {
          if (!singleClick) {
            padTap(padKey, PadTapAction.Press);
          }
        },
        onTapCancel: () {
          if (!singleClick) {
            padTap(padKey, PadTapAction.Release);
          }
        },
        child: child,
      ),
    );
  }
}

/// 方向键摇杆
class DirectionJoyStick extends StatefulWidget {
  final JoyPadTap padTap;

  const DirectionJoyStick({required this.padTap, Key? key}) : super(key: key);

  @override
  _DirectionJoyStickState createState() => _DirectionJoyStickState();
}

class _DirectionJoyStickState extends State<DirectionJoyStick> {
  Offset delta = Offset.zero;
  final Map<DirectionPadKey, bool> _tempList = {
    DirectionPadKey.Left: false,
    DirectionPadKey.Top: false,
    DirectionPadKey.Right: false,
    DirectionPadKey.Bottom: false,
  };

  final double bgSize = 120;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: bgSize,
      height: bgSize,
      margin: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(bgSize / 2)),
        child: GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.6),
              borderRadius: BorderRadius.circular(bgSize / 2),
            ),
            child: Center(
              child: Transform.translate(
                offset: delta,
                child: SizedBox(
                  width: bgSize / 2,
                  height: bgSize / 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xccffffff),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
          ),
          onPanDown: (d) => _calculateDelta(d.localPosition),
          onPanUpdate: (d) => _calculateDelta(d.localPosition),
          onPanEnd: (d) => _updateDelta(Offset.zero),
        ),
      ),
    );
  }

  void _calculateDelta(Offset offset) {
    Offset newD = offset - Offset(bgSize / 2, bgSize / 2);
    _updateDelta(Offset.fromDirection(newD.direction, min(bgSize / 4, newD.distance)));
  }

  void _updateDelta(Offset offset) {
    final Map<DirectionPadKey, bool> tempList = {
      DirectionPadKey.Left: false,
      DirectionPadKey.Top: false,
      DirectionPadKey.Right: false,
      DirectionPadKey.Bottom: false,
    };
    final t = tan(bgSize / 4 * pi / 180);
    if (offset != Offset.zero) {
      final dx = offset.dx.abs();
      final dy = offset.dy.abs();
      if (dx > dy) {
        if (dy > dx * t) {
          tempList[offset.dx.isNegative ? DirectionPadKey.Left : DirectionPadKey.Right] = true;
          tempList[offset.dy.isNegative ? DirectionPadKey.Top : DirectionPadKey.Bottom] = true;
        } else {
          tempList[offset.dx.isNegative ? DirectionPadKey.Left : DirectionPadKey.Right] = true;
        }
      } else {
        if (dx > dy * t) {
          tempList[offset.dx.isNegative ? DirectionPadKey.Left : DirectionPadKey.Right] = true;
          tempList[offset.dy.isNegative ? DirectionPadKey.Top : DirectionPadKey.Bottom] = true;
        } else {
          tempList[offset.dy.isNegative ? DirectionPadKey.Top : DirectionPadKey.Bottom] = true;
        }
      }
    }
    _tempList.entries.forEach((element) {
      if (!element.value && tempList[element.key]!) {
        widget.padTap(element.key, PadTapAction.LongPress);
      } else if (element.value && !tempList[element.key]!) {
        widget.padTap(element.key, PadTapAction.LongPressEnd);
      }
      _tempList[element.key] = tempList[element.key]!;
    });
    setState(() {
      delta = offset;
    });
  }
}
