import 'package:flutter/material.dart';
import 'package:malabar_mess_app/classes/shared_preference.dart';
import 'package:malabar_mess_app/model/get_database_data.dart';
import 'package:malabar_mess_app/screen/home_screen.dart';
import 'package:malabar_mess_app/widget/app_bar.dart';
import 'package:malabar_mess_app/widget/snackbar.dart';

class CreatePasscodeScreen extends StatelessWidget {
  CreatePasscodeScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _messUniquePasscode = TextEditingController();
  final TextEditingController _messPasscode = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(),
      backgroundColor: Colors.blueGrey[200],
      body: Form(
        key: _formKey,
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: size.width * 0.85,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Center(
                      child: Text(
                        "Create passcode",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.05),
                    TextFormField(
                      validator: (value) {
                        return (validatePasscode(passcode: value))
                            ? null
                            : "Wrong unique passcode";
                      },
                      controller: _messUniquePasscode,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Mess unique passcode",
                        labelText: "Mess unique passcode",
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    TextFormField(
                      validator: (value) {
                        return (validatePasscode(passcode: value))
                            ? null
                            : "Enter 4 digit passcode";
                      },
                      controller: _messPasscode,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Enter new passcode",
                        labelText: "New passcode",
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.06),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await createButton(context: context);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 15)),
                            child: const Text(
                              "Create",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool validatePasscode({required passcode}) {
    return (passcode.length == 4 &&
            !(passcode.contains(RegExp(r'[A-Z]')) ||
                passcode.contains(RegExp(r'[a-z]'))))
        ? true
        : false;
  }

  Future<void> createButton({required context}) async {
    if (_formKey.currentState!.validate()) {
      GetDatabaseData obj = GetDatabaseData();
      int messPasscode = await obj.getMessUniquePasscode();
      int passcode = int.parse(_messUniquePasscode.text);
      if (!context.mounted) return;
      if (messPasscode == passcode) {
        SharedPreferenceClass obj = SharedPreferenceClass();
        bool isCreate = await obj.setSharedPreference(passcode: int.parse(_messPasscode.text));
        if (!context.mounted) return;
        if (isCreate) {
          ShowSnackBar(context: context, message: "Passcode created");
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen()));
        } else {
          ShowSnackBar(context: context, message: "Something went wrong");
        }
      } else {
        ShowSnackBar(context: context, message: " Wrong mess unique passcode");
      }
    }
  }
}
