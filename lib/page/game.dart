import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nes/flutter_nes.dart';
import 'package:koala/widget/joy_pad.dart';

///
/// Created by iceKylin on 2021/6/10
///
class LocalGame extends StatefulWidget {
  final NesRom rom;

  const LocalGame({required this.rom, Key? key}) : super(key: key);

  @override
  _LocalGameState createState() => _LocalGameState();
}

class _LocalGameState extends State<LocalGame> {
  late FlutterNesController controller;
  Map<ActionPadKey, bool> _longPressFlag = {};

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    controller = FlutterNesController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: JoyPad(
          game: SizedBox(
            width: size.height / 240 * 256,
            child: Center(
              child: Transform.scale(
                scale: size.height / 240,
                child: FlutterNesWidget(rom: widget.rom, controller: controller),
              ),
            ),
          ),
          padTap: _onPadTap,
        ),
      ),
    );
  }

  void _onPadTap(JoyPadKey key, PadTapAction action) {
    if (key is ControlPadKey) {
      assert(action == PadTapAction.Click);
      _onControlPadTap(key);
    } else if (key is DirectionPadKey) {
      assert(action != PadTapAction.Click);
      _onDirectionPadTap(key, action);
    } else if (key is ActionPadKey) {
      _onActionPadTap(key, action);
    }
  }

  void _onControlPadTap(ControlPadKey key) {
    switch (key) {
      case ControlPadKey.Exit:
        Navigator.of(context).pop();
        break;
      case ControlPadKey.Reset:
        _clickNesButton(NesButton.Reset);
        break;
      case ControlPadKey.Start:
        _clickNesButton(NesButton.Start);
        break;
      case ControlPadKey.Select:
        _clickNesButton(NesButton.Select);
        break;
    }
  }

  void _onDirectionPadTap(DirectionPadKey key, PadTapAction action) async {
    switch (key) {
      case DirectionPadKey.Left:
        _pressOrReleaseNesButton(action, NesButton.Joypad1Left);
        break;
      case DirectionPadKey.Top:
        _pressOrReleaseNesButton(action, NesButton.Joypad1Up);
        break;
      case DirectionPadKey.Right:
        _pressOrReleaseNesButton(action, NesButton.Joypad1Right);
        break;
      case DirectionPadKey.Bottom:
        _pressOrReleaseNesButton(action, NesButton.Joypad1Down);
        break;
    }
  }

  void _onActionPadTap(ActionPadKey key, PadTapAction action) async {
    if (action == PadTapAction.Click) {
      switch (key) {
        case ActionPadKey.A1:
          _clickNesButton(NesButton.Joypad1A);
          break;
        case ActionPadKey.B1:
          _clickNesButton(NesButton.Joypad1B);
          break;
        case ActionPadKey.AB1:
          _clickNesButton(NesButton.Joypad1A);
          _clickNesButton(NesButton.Joypad1B);
          break;
      }
    } else if (action == PadTapAction.Press || action == PadTapAction.Release) {
      switch (key) {
        case ActionPadKey.A2:
          _pressOrReleaseNesButton(action, NesButton.Joypad1A);
          break;
        case ActionPadKey.B2:
          _pressOrReleaseNesButton(action, NesButton.Joypad1B);
          break;
        case ActionPadKey.AB2:
          _pressOrReleaseNesButton(action, NesButton.Joypad1A);
          _pressOrReleaseNesButton(action, NesButton.Joypad1B);
          break;
      }
    } else if (action == PadTapAction.LongPress) {
      _longPressFlag[key] = true;
      switch (key) {
        case ActionPadKey.A1:
          _circleClickNesButton(key, NesButton.Joypad1A);
          break;
        case ActionPadKey.B1:
          _circleClickNesButton(key, NesButton.Joypad1B);
          break;
        case ActionPadKey.AB1:
          _circleClickNesButton(key, NesButton.Joypad1A);
          _circleClickNesButton(key, NesButton.Joypad1B);
          break;
      }
    } else if (action == PadTapAction.LongPressEnd) {
      _longPressFlag[key] = false;
    }
  }

  /// 单击
  void _clickNesButton(NesButton button) async {
    await controller.pressButton(button);
    await Future.delayed(Duration(milliseconds: 16));
    await controller.releaseButton(button);
  }

  /// 循环
  void _circleClickNesButton(ActionPadKey key, NesButton button) async {
    while (_longPressFlag[key] ?? false) {
      await controller.pressButton(button);
      await Future.delayed(Duration(milliseconds: 16));
      await controller.releaseButton(button);
      await Future.delayed(Duration(milliseconds: 16));
    }
  }

  void _pressOrReleaseNesButton(PadTapAction action, NesButton button) async {
    if (action == PadTapAction.Press || action == PadTapAction.LongPress) {
      await controller.pressButton(button);
    } else if (action == PadTapAction.Release || action == PadTapAction.LongPressEnd) {
      await controller.releaseButton(button);
    }
  }
}
