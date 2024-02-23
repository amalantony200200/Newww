library passcode_screen;

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:malabar_mess_app/screen/count_screen.dart';
import 'package:malabar_mess_app/screen/create_passcode_screen.dart';
import 'package:malabar_mess_app/screen/home_screen.dart';
import 'package:malabar_mess_app/screen/search_screen.dart';
import 'package:malabar_mess_app/widget/circle.dart';
import 'package:malabar_mess_app/widget/keyboard.dart';
import 'package:malabar_mess_app/classes/shake_curve.dart';


typedef PasswordEnteredCallback = void Function(String text);
typedef IsValidCallback = void Function();
typedef CancelCallback = void Function();

class PasscodeScreen extends StatefulWidget {
  final String title;
  final int passwordDigits = 4;
  final PasswordEnteredCallback passwordEnteredCallback;
  
  final Stream<bool> shouldTriggerVerification;
  final Function afterPasscodeCorrect;
  final CircleUIConfig circleUIConfig;
  final KeyboardUIConfig keyboardUIConfig;

  //isValidCallback will be invoked after passcode screen will pop.
  final IsValidCallback? isValidCallback;
  final CancelCallback? cancelCallback;
  final Color? backgroundColor;
  final Widget? bottomWidget;
  final List<String>? digits;

  // ignore: prefer_const_constructors_in_immutables
  PasscodeScreen({
    Key? key,
    required this.title,
    required this.passwordEnteredCallback,
    required this.shouldTriggerVerification,
    required this.afterPasscodeCorrect,
    this.isValidCallback,
    CircleUIConfig? circleUIConfig,
    KeyboardUIConfig? keyboardUIConfig,
    this.bottomWidget,
    this.backgroundColor,
    this.cancelCallback,
    this.digits,
  })  : circleUIConfig = circleUIConfig ?? const CircleUIConfig(),
        keyboardUIConfig = keyboardUIConfig ?? const KeyboardUIConfig(),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _PasscodeScreenState();
}

class _PasscodeScreenState extends State<PasscodeScreen>
    with SingleTickerProviderStateMixin {
  late StreamSubscription<bool> streamSubscription;
  String enteredPasscode = '';
  late AnimationController controller;
  late Animation<double> animation;

  @override
  initState() {
    super.initState();
    streamSubscription = widget.shouldTriggerVerification
        .listen((isValid) => _showValidation(isValid));
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    final Animation curve =
        CurvedAnimation(parent: controller, curve: ShakeCurve());
    animation = Tween(begin: 0.0, end: 10.0).animate(curve as Animation<double>)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            enteredPasscode = '';
            controller.value = 0;
          });
        }
      })
      ..addListener(() {
        setState(() {
          // the animation object’s value is the changed state
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor ?? Colors.black.withOpacity(0.8),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            return orientation == Orientation.portrait
                ? _buildPortraitPasscodeScreen()
                : _buildLandscapePasscodeScreen();
          },
        ),
      ),
    );
  }

  _buildPortraitPasscodeScreen() => Stack(
        children: [
          Positioned(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //widget.title,
                  Text(widget.title,style: const TextStyle(color: Colors.white)),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildCircles(),
                    ),
                  ),
                  _buildKeyboard(),
                  widget.bottomWidget ?? Container()
                ],
              ),
            ),
          ),
          Positioned(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: _buildForgotButton(),
            ),
          ),
          Positioned(
            child: Align(
              alignment: Alignment.bottomRight,
              child: _buildDeleteButton(),
            ),
          ),
        ],
      );

  _buildLandscapePasscodeScreen() => Stack(
        children: [
          Positioned(
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Stack(
                    children: <Widget>[
                      Positioned(
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(widget.title,style: const TextStyle(color: Colors.white)),
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                height: 40,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: _buildCircles(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      widget.bottomWidget != null
                          ? Positioned(
                              child: Align(
                                  alignment: Alignment.topCenter,
                                  child: widget.bottomWidget),
                            )
                          : Container()
                    ],
                  ),
                  _buildKeyboard(),
                ],
              ),
            ),
          ),
          Positioned(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: _buildForgotButton(),
            ),
          ),
          Positioned(
            child: Align(
              alignment: Alignment.bottomRight,
              child: _buildDeleteButton(),
            ),
          )
        ],
      );

  _buildKeyboard() => Keyboard(
    onKeyboardTap: _onKeyboardButtonPressed,
    keyboardUIConfig: widget.keyboardUIConfig,
    digits: widget.digits,
  );

  List<Widget> _buildCircles() {
    var list = <Widget>[];
    var config = widget.circleUIConfig;
    var extraSize = animation.value;
    for (int i = 0; i < widget.passwordDigits; i++) {
      list.add(
        Container(
          margin: const EdgeInsets.all(8),
          child: Circle(
            filled: i < enteredPasscode.length,
            circleUIConfig: config,
            extraSize: extraSize,
          ),
        ),
      );
    }
    return list;
  }

  _onDeleteCancelButtonPressed() {
    if (enteredPasscode.isNotEmpty) {
      setState(() {
        enteredPasscode =
            enteredPasscode.substring(0, enteredPasscode.length - 1);
      });
    } else {
      if (widget.cancelCallback != null) {
        widget.cancelCallback!();
      }
    }
  }

  _onKeyboardButtonPressed(String text) {
    if (text == Keyboard.deleteButton) {
      _onDeleteCancelButtonPressed();
      return;
    }
    setState(() {
      if (enteredPasscode.length < widget.passwordDigits) {
        enteredPasscode += text;
        if (enteredPasscode.length == widget.passwordDigits) {
          widget.passwordEnteredCallback(enteredPasscode);
        }
      }
    });
  }

  @override
  didUpdateWidget(PasscodeScreen old) {
    super.didUpdateWidget(old);
    // in case the stream instance changed, subscribe to the new one
    if (widget.shouldTriggerVerification != old.shouldTriggerVerification) {
      streamSubscription.cancel();
      streamSubscription = widget.shouldTriggerVerification
          .listen((isValid) => _showValidation(isValid));
    }
  }

  @override
  dispose() {
    controller.dispose();
    streamSubscription.cancel();
    super.dispose();
  }

  _showValidation(bool isValid) {
    if (isValid) {
      Navigator.maybePop(context).then((pop) => _validationCallback());
      //Navigator.push(context, MaterialPageRoute(builder: (context) => CountScreen(),));
    } else {
      controller.forward();
    }
  }

  _validationCallback() {
    if (widget.isValidCallback != null) {
      widget.isValidCallback!();
    } else {
      widget.afterPasscodeCorrect();
    }
  }

  Widget _buildForgotButton() {
    return CupertinoButton(
      onPressed: _onForgotButtonPressed,
      child: Container(
        margin: widget.keyboardUIConfig.digitInnerMargin,
        child: const Text("Forgot"),
      ),
    );
  }
  _onForgotButtonPressed() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => CreatePasscodeScreen()));
  }

  Widget _buildDeleteButton() {
    return CupertinoButton(
      onPressed: _onDeleteCancelButtonPressed,
      child: Container(
        margin: widget.keyboardUIConfig.digitInnerMargin,
        child: enteredPasscode.isEmpty
            ? const Text("Cancel")
            : const Text("Delete"),
      ),
    );
  }
}
