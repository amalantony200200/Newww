import 'dart:async';

import 'package:flutter/material.dart';
import 'package:malabar_mess_app/screen/check_passcode_screen.dart';
import 'package:malabar_mess_app/screen/search_screen.dart';
import 'package:malabar_mess_app/widget/app_bar.dart';
import 'package:malabar_mess_app/classes/internet_error_snackbar.dart';
import 'package:malabar_mess_app/widget/snackbar.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final String message = "Internet connection required";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Column(
        children: [
          MaterialButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchScreen()));
            },
            child: Text("Search Button"),
          ),
          MaterialButton(
              onPressed: () => print("dsaf"), child: Text("Count Button")),
          MaterialButton(
            onPressed: () async {
              functionalButtons(context: context, page: SearchScreen(),title:"Enter passcode");
            },
            child: Text("Add Member Button"),
          ),
          MaterialButton(
              onPressed: () => print("dsaf"), child: Text("update Button")),
        ],
      ),
    );
  }

  Future<void> functionalButtons({required context, required page, required title}) async {
    bool checkInternet = await InternetConnectionCheck.internetCheck();
    if (!context.mounted) return;
    if (checkInternet == true) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PasscodeScreen(
                    title: title,
                    passwordEnteredCallback: _onPasscodeEntered,
                    shouldTriggerVerification: _verificationNotifier.stream,
                    afterPasscodeCorrect: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => page));
                    },
                  )));
    } else {
      ShowSnackBar(context: context, message: message);
    }
  }

  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();

  _onPasscodeEntered(String enteredPasscode) {
    bool isValid = '1234' == enteredPasscode;
    _verificationNotifier.add(isValid);
  }
}
