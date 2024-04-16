import 'dart:io';

import 'package:flutter/material.dart';
import 'package:malabar_mess_app/model/member_details.dart';
import 'package:malabar_mess_app/modules/ebill/generate_receipt.dart';
import 'package:malabar_mess_app/modules/ebill/send_receipt.dart';
import 'package:malabar_mess_app/repo/get_database_data.dart';
import 'package:malabar_mess_app/repo/insert_into_database.dart';
import 'package:malabar_mess_app/screen/home_screen.dart';
import 'package:malabar_mess_app/widget/app_bar.dart';
import 'package:malabar_mess_app/widget/snackbar.dart';

class AddNewMemberScreen extends StatelessWidget {
  AddNewMemberScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _memberIdField = TextEditingController();
  final TextEditingController _memberNameField = TextEditingController();
  final TextEditingController _memberNumberField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(),
      //backgroundColor: Colors.blueGrey[200],
      body: Form(
        key: _formKey,
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              //width: size.width * 0.85,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //SizedBox(height: size.height * 0.005),
                    TextFormField(
                      controller: _memberIdField,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Enter member ID",
                        labelText: "Member Id",
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    ),
                    Image.file(File("/data/user/0/com.example.malabar_mess_app/app_flutter/amal.png")),
                    SizedBox(height: size.height * 0.06),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                //ShowSnackBar(context: context, message: "Processing...");
                                MemberDetails memberDetails = MemberDetails(
                                    memberId: _memberIdField.text,
                                    memberName: "Amal Antony",
                                    memberNumber: "9072292940",
                                    memberPaidAmount: "4000",
                                    memberFoodTime: "111",
                                    memberValidFrom: DateTime.now(),
                                    memberValidTill: DateTime.now().add(const Duration(days: 30)),
                                    memberExtends: {"totalNumberOfExtends":"0"}
                                );
                                GetDatabaseData getDatabaseData =
                                    GetDatabaseData();

                                    await getDatabaseData.getAllMembersDocs();

                                bool isValidMemberId = await getDatabaseData
                                    .checkIfDocExists(memberDetails.memberId);
                                if (isValidMemberId) {
                                  if (!context.mounted) return;
                                  ShowSnackBar(
                                      context: context,
                                      message: "Member ID already availabe");
                                } else {
                                  InsertIntoDatabase insertIntoDatabase =
                                      InsertIntoDatabase();
                                  bool isCreated =
                                      await insertIntoDatabase.addMemberDetails(
                                          memberDetails: memberDetails);
                                  if(isCreated){
                                    if(!context.mounted) return;
                                    ShowSnackBar(context: context, message: "Successfully added");
                                    GenerateReceipt obj = GenerateReceipt();
                                    final receipt = await obj.receipt(memberDetails);
                                    SendReceipt sendReceipt = SendReceipt();
                                    final bool message = await sendReceipt.sendReceipt(receipt);
                                    if(!context.mounted) return;
                                    if(message == true){
                                      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => HomeScreen()));
                                      ShowSnackBar(context: context, message: "Successfully sent");
                                    }else{
                                      ShowSnackBar(context: context, message: "Something went wrong. Reciept doesn't send");
                                    }
                                  }else{
                                    if(!context.mounted) return;
                                    ShowSnackBar(context: context, message: "Something went wrong. Data dosen't stored in database");
                                  }
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 15)),
                            child: const Text(
                              "Add Member",
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
}
