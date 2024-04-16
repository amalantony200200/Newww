import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_file_saver/flutter_file_saver.dart';
import 'package:malabar_mess_app/classes/shared_preference.dart';
import 'package:malabar_mess_app/modules/ebill/generate_receipt.dart';
import 'package:malabar_mess_app/screen/add_new_member_screen.dart';
import 'package:malabar_mess_app/modules/passcode/screen/check_passcode_screen.dart';
import 'package:malabar_mess_app/screen/search_screen.dart';
import 'package:malabar_mess_app/widget/app_bar.dart';
import 'package:malabar_mess_app/classes/internet_error_snackbar.dart';
import 'package:malabar_mess_app/widget/snackbar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:whatsapp_share/whatsapp_share.dart';

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
              onPressed: () async {
                
              },
              child: Text("Count Button")),
          MaterialButton(
            onPressed: () async {
              functionalButtons(
                  context: context,
                  page: AddNewMemberScreen(),
                  title: "Enter passcode");
            },
            child: Text("Add Member Button"),
          ),
          MaterialButton(
              onPressed: () => print("dsaf"), child: Text("update Button")),
        ],
      ),
    );
  }

  Future<void> functionalButtons(
      {required context, required page, required title}) async {
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
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => page));
                    },
                  )));
    } else {
      ShowSnackBar(context: context, message: message);
    }
  }

  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();

  _onPasscodeEntered(String enteredPasscode) async {
    SharedPreferenceClass obj = SharedPreferenceClass();
    int passcode = await obj.getSharedPreference();
    bool isValid = passcode == int.parse(enteredPasscode);
    _verificationNotifier.add(isValid);
  }
}
