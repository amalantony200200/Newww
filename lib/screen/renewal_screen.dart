import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:malabar_mess_app/constant.dart';
import 'package:malabar_mess_app/controller/get_database_controller.dart';
import 'package:malabar_mess_app/model/member_details.dart';
import 'package:malabar_mess_app/modules/ebill/generate_receipt.dart';
import 'package:malabar_mess_app/modules/ebill/send_receipt.dart';
import 'package:malabar_mess_app/repo/get_database_data.dart';
import 'package:malabar_mess_app/repo/insert_into_database.dart';
import 'package:malabar_mess_app/controller/add_controller.dart';
import 'package:malabar_mess_app/screen/home_screen.dart';
import 'package:malabar_mess_app/widget/app_bar.dart';
import 'package:malabar_mess_app/widget/check_box.dart';
import 'package:malabar_mess_app/widget/elevated_button.dart';
import 'package:malabar_mess_app/widget/heading_text.dart';
import 'package:malabar_mess_app/widget/snackbar.dart';
import 'package:malabar_mess_app/widget/text_form_field.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class RenewalMemberScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  late BuildContext cnt;
  late TextEditingController _idController;
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _amountController;
  final MemberDetails memberDetails;

  RenewalMemberScreen({super.key, required this.memberDetails}) {
    _idController = TextEditingController(text: memberDetails.memberId);
    _nameController = TextEditingController(text: memberDetails.memberName);
    _phoneController = TextEditingController(text: memberDetails.memberNumber);
    _amountController = TextEditingController(text: memberDetails.memberPaidAmount);
  }

  @override
  Widget build(BuildContext context) {
    cnt = context;
    return Scaffold(
      appBar: appBar(),
      body: ChangeNotifierProvider<AddScreenProvider>(
        create: (context) => AddScreenProvider(
          dateRange: DateTimeRange(
            start: memberDetails.memberValidFrom,
            end: memberDetails.memberValidTill,
          ),
          foodTime: memberDetails.memberFoodTime,
          extendsDateRage: DateTimeRange(
            start: memberDetails.memberValidFrom,
            end: memberDetails.memberValidTill,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Consumer<AddScreenProvider>(
                builder: (context, provider, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      headingText("Renewal Member"),
                      TEXT_INPUT_FIELD_SIZEDBOX,
                      textFormField(
                        _idController,
                        TEXT_INPUT_FIELD_ID,
                        TextInputType.number,
                        (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a valid ID';
                          }
                          return null;
                        },
                      ),
                      TEXT_INPUT_FIELD_SIZEDBOX,
                      textFormField(
                        _nameController,
                        TEXT_INPUT_FIELD_NAME,
                        TextInputType.name,
                        (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                      TEXT_INPUT_FIELD_SIZEDBOX,
                      textFormField(
                        _phoneController,
                        TEXT_INPUT_FIELD_MOBILE_NUMBER,
                        TextInputType.phone,
                        (value) {
                          if (value == null || value.isEmpty || value.length != 10) {
                            return 'Please enter a valid mobile number';
                          }
                          return null;
                        },
                      ),
                      TEXT_INPUT_FIELD_SIZEDBOX,
                      textFormField(
                        _amountController,
                        TEXT_INPUT_FIELD_AMOUNT,
                        TextInputType.number,
                        (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an amount';
                          }
                          return null;
                        },
                      ),
                      TEXT_INPUT_FIELD_SIZEDBOX,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton.icon(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(BUTTON_COLOR),
                            ),
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              provider.setParticularrDate(14);
                            },
                            label: const Text(
                              "15 days",
                              style: TextStyle(color: Colors.white),
                            ),
                            icon: const Icon(Icons.calendar_today, color: Colors.white),
                          ),
                          ElevatedButton.icon(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(BUTTON_COLOR),
                            ),
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              provider.setParticularrDate(29);
                            },
                            label: const Text(
                              "30 days",
                              style: TextStyle(color: Colors.white),
                            ),
                            icon: const Icon(Icons.calendar_today, color: Colors.white),
                          ),
                          ElevatedButton.icon(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(BUTTON_COLOR),
                            ),
                            onPressed: () async {
                              await dateRangeButtonCalender(provider);
                            },
                            label: Text(
                              DateFormat('d/M/y').format(provider.dateRange.end),
                              style: const TextStyle(color: Colors.white),
                            ),
                            icon: const Icon(Icons.calendar_month_sharp, color: Colors.white),
                          ),
                        ],
                      ),
                      TEXT_INPUT_FIELD_SIZEDBOX,
                      Text(
                        "From: ${DateFormat('MMM d').format(provider.dateRange.start)} To: ${DateFormat('MMM d').format(provider.dateRange.end)}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      TEXT_INPUT_FIELD_SIZEDBOX,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          checkBox(
                            "Breakfast",
                            provider.foodTime[0] == '1',
                            (bool value) {
                              foodTimeShift(0, provider);
                            },
                          ),
                          checkBox(
                            "Lunch",
                            provider.foodTime[1] == '1',
                            (bool value) {
                              foodTimeShift(1, provider);
                            },
                          ),
                          checkBox(
                            "Dinner",
                            provider.foodTime[2] == '1',
                            (bool value) {
                              foodTimeShift(2, provider);
                            },
                          ),
                        ],
                      ),
                      TEXT_INPUT_FIELD_SIZEDBOX,
                      Center(
                        child: ElevatedButton.icon(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(BUTTON_COLOR),
                          ),
                          onPressed: () async {
                            await updateButton(provider);
                          },
                          label: const Text(
                            "Update",
                            style: TextStyle(color: Colors.white),
                          ),
                          icon: const Icon(Icons.update, color: Colors.white),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void foodTimeShift(int position, AddScreenProvider provider) {
    String char0 = provider.foodTime[0];
    String char1 = provider.foodTime[1];
    String char2 = provider.foodTime[2];

    if (position == 0) {
      char0 = char0 == '1' ? '0' : '1';
    } else if (position == 1) {
      char1 = char1 == '1' ? '0' : '1';
    } else if (position == 2) {
      char2 = char2 == '1' ? '0' : '1';
    }
    provider.setFoodTime(char0 + char1 + char2);
  }

  Future<void> dateRangeButtonCalender(AddScreenProvider provider) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final newDate = DateTime.now();
    final initialDateRange = provider.dateRange;
    final lastDate = newDate.add(const Duration(days: 365));
    final pickedDate = await showDateRangePicker(
      context: cnt,
      firstDate: newDate.subtract(const Duration(days: 30)),
      initialDateRange: initialDateRange,
      lastDate: lastDate,
      currentDate: newDate,
    );
    if (pickedDate != null) {
      provider.setDate(pickedDate);
    }
  }

  Future<void> updateButton(AddScreenProvider provider) async {
    if (_formKey.currentState!.validate()) {
      MemberDetails memberDetails = MemberDetails(
        memberId: _idController.text,
        memberName: _nameController.text,
        memberNumber: _phoneController.text,
        memberPaidAmount: _amountController.text,
        memberFoodTime: provider.foodTime,
        memberValidFrom: provider.dateRange.start,
        memberValidTill: provider.dateRange.end,
        memberExtendsStart: [],
        memberExtendsEnd: [],
      );

      GetDatabaseData getDatabaseData = GetDatabaseData();
      bool isValidMemberId = await getDatabaseData.checkIfDocExists(memberDetails.memberId);

      if (!isValidMemberId) {
        ShowSnackBar(context: cnt, message: "Member ID is not available");
      } else {
        InsertIntoDatabase insertIntoDatabase = InsertIntoDatabase();
        bool isUpdated = await insertIntoDatabase.updateMemberDetails(memberDetails: memberDetails);

        if (isUpdated) {
          ShowSnackBar(context: cnt, message: "Successfully updated");
          GenerateReceipt generateReceipt = GenerateReceipt();
          final receipt = await generateReceipt.receipt(memberDetails);
          SendReceipt sendReceipt = SendReceipt();
          final bool message = await sendReceipt.sendReceipt(receipt);

          if (message) {
            if (cnt.mounted) {
              Navigator.pushReplacement(
                cnt,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
              ShowSnackBar(context: cnt, message: "Successfully sent");
            }
          } else {
            ShowSnackBar(context: cnt, message: "Something went wrong. Receipt not sent");
          }
        } else {
          ShowSnackBar(context: cnt, message: "Something went wrong. Data not stored in database");
        }
      }
    }
  }
}

// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:malabar_mess_app/constant.dart';
// import 'package:malabar_mess_app/controller/get_database_controller.dart';
// import 'package:malabar_mess_app/model/member_details.dart';
// import 'package:malabar_mess_app/modules/ebill/generate_receipt.dart';
// import 'package:malabar_mess_app/modules/ebill/send_receipt.dart';
// import 'package:malabar_mess_app/repo/get_database_data.dart';
// import 'package:malabar_mess_app/repo/insert_into_database.dart';
// import 'package:malabar_mess_app/controller/add_controller.dart';
// import 'package:malabar_mess_app/screen/home_screen.dart';
// import 'package:malabar_mess_app/widget/app_bar.dart';
// import 'package:malabar_mess_app/widget/check_box.dart';
// import 'package:malabar_mess_app/widget/elevated_button.dart';
// import 'package:malabar_mess_app/widget/heading_text.dart';
// import 'package:malabar_mess_app/widget/snackbar.dart';
// import 'package:malabar_mess_app/widget/text_form_field.dart';
// import 'package:provider/provider.dart';

// // ignore: must_be_immutable
// class RenewalMemberScreen extends StatelessWidget {
//   final _formKey = GlobalKey<FormState>();
//   late BuildContext cnt;
//   late TextEditingController _idController = TextEditingController();
//   late TextEditingController _nameController = TextEditingController();
//   late TextEditingController _phoneController = TextEditingController();
//   late TextEditingController _amountController = TextEditingController();
//   final MemberDetails memberDetails;

//   RenewalMemberScreen({super.key, required this.memberDetails}) {
//     _idController = TextEditingController(text: memberDetails.memberId);
//     _nameController = TextEditingController(text: memberDetails.memberName);
//     _phoneController = TextEditingController(text: memberDetails.memberNumber);
//     _amountController =
//         TextEditingController(text: memberDetails.memberPaidAmount);
//   }

//   @override
//   Widget build(BuildContext context) {
//     cnt = context;
//     return Scaffold(
//       appBar: appBar(),
//       body: ChangeNotifierProvider<AddScreenProvider>(
//         create: (context) => AddScreenProvider(dateRange: DateTimeRange(
//                     start: memberDetails.memberValidFrom,
//                     end: memberDetails.memberValidTill),foodTime: memberDetails.memberFoodTime,extendsDateRage: DateTimeRange(
//                     start: memberDetails.memberValidFrom,
//                     end: memberDetails.memberValidTill)),
//         child: Container(
//           padding: const EdgeInsets.all(10),
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height,
//           child: Form(
//             key: _formKey,
//             child: SingleChildScrollView(
//               child: Consumer<AddScreenProvider>(
//                   builder: (context, provider, child) {
//                 return Column(
//                   children: [
//                     headingText("Renewal Member"),
//                     TEXT_INPUT_FIELD_SIZEDBOX,
//                     textFormField(_idController, TEXT_INPUT_FIELD_ID,
//                         TextInputType.number),
//                     TEXT_INPUT_FIELD_SIZEDBOX,
//                     textFormField(_nameController, TEXT_INPUT_FIELD_NAME,
//                         TextInputType.name),
//                     TEXT_INPUT_FIELD_SIZEDBOX,
//                     textFormField(_phoneController,
//                         TEXT_INPUT_FIELD_MOBILE_NUMBER, TextInputType.phone),
//                     TEXT_INPUT_FIELD_SIZEDBOX,
//                     textFormField(_amountController, TEXT_INPUT_FIELD_AMOUNT,
//                         TextInputType.number),
//                     TEXT_INPUT_FIELD_SIZEDBOX,
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         ElevatedButton.icon(
//                           style: ButtonStyle(
//                               backgroundColor:
//                                   MaterialStateProperty.all(BUTTON_COLOR)),
//                           onPressed: () async {
//                             FocusManager.instance.primaryFocus?.unfocus();
//                             provider.setParticularrDate(14);
//                           },
//                           label: const Text(
//                             "days",
//                             style: TextStyle(color: Colors.white),
//                           ),
//                           icon: const Text(
//                             "15",
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                         ElevatedButton.icon(
//                           style: ButtonStyle(
//                               backgroundColor:
//                                   MaterialStateProperty.all(BUTTON_COLOR)),
//                           onPressed: () async {
//                             FocusManager.instance.primaryFocus?.unfocus();
//                             provider.setParticularrDate(29);
//                           },
//                           label: const Text(
//                             "days",
//                             style: TextStyle(color: Colors.white),
//                           ),
//                           icon: const Text(
//                             "30",
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                         ElevatedButton.icon(
//                           style: ButtonStyle(
//                               backgroundColor:
//                                   MaterialStateProperty.all(BUTTON_COLOR)),
//                           onPressed: () async {
//                             await dateRangeButtonCalender(provider);
//                           },
//                           label: Text(
//                             DateFormat('d/M/y').format(provider.dateRange.end),
//                             style: const TextStyle(color: Colors.white),
//                           ),
//                           icon: const Icon(Icons.calendar_month_sharp),
//                         ),
//                       ],
//                     ),
//                     TEXT_INPUT_FIELD_SIZEDBOX,
//                     Text(
//                         "From: ${DateFormat('MMM d').format(provider.dateRange.start)}        To: ${DateFormat('MMM d').format(provider.dateRange.end)}",
//                         style: const TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 20)),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         checkBox("Break Fast",
//                             provider.foodTime[0] == '1' ? true : false,
//                             (bool b) {
//                           foodTimeShift(0, provider);
//                         }),
//                         checkBox(
//                             "Lunch", provider.foodTime[1] == '1' ? true : false,
//                             (bool b) {
//                           foodTimeShift(1, provider);
//                         }),
//                         checkBox("Dinner",
//                             provider.foodTime[2] == '1' ? true : false,
//                             (bool b) {
//                           foodTimeShift(2, provider);
//                         }),
//                       ],
//                     ),
//                     TEXT_INPUT_FIELD_SIZEDBOX,
//                     ElevatedButton.icon(
//                       style: ButtonStyle(
//                           backgroundColor:
//                               MaterialStateProperty.all(BUTTON_COLOR)),
//                       onPressed: () async {
//                         await updateButton(provider);
//                       },
//                       label: const Text(
//                         "Update",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                       icon: const Icon(Icons.add),
//                     ),
//                   ],
//                 );
//               }),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void foodTimeShift(int position, AddScreenProvider provider) {
//     String char0 = provider.foodTime[0];
//     String char1 = provider.foodTime[1];
//     String char2 = provider.foodTime[2];

//     if (position == 0) {
//       (char0 == '1') ? char0 = '0' : char0 = '1';
//     } else if (position == 1) {
//       (char1 == '1') ? char1 = '0' : char1 = '1';
//     } else if (position == 2) {
//       (char2 == '1') ? char2 = '0' : char2 = '1';
//     }
//     provider.setFoodTime(char0 + char1 + char2);
//   }

//   Future<void> dateRangeButtonCalender(AddScreenProvider provider) async {
//     FocusManager.instance.primaryFocus?.unfocus();
//     final newDate = DateTime.now();
//     final initialDateRage = provider.dateRange;
//     final lastDate = newDate.add(const Duration(days: 365));
//     final pickedDate = await showDateRangePicker(
//       context: cnt,
//       firstDate: newDate.subtract(const Duration(days: 30)),
//       initialDateRange: initialDateRage,
//       lastDate: lastDate,
//       currentDate: newDate,
//     );
//     final dateRange = pickedDate as DateTimeRange;
//     provider.setDate(dateRange);
//   }

//   Future<void> updateButton(AddScreenProvider provider) async {
//     if (_formKey.currentState!.validate()) {
//       //ShowSnackBar(context: context, message: "Processing...");
//       //print(provider.foodTime);
//       MemberDetails memberDetails = MemberDetails(
//         memberId: (int.parse(_idController.text).toString()),
//         memberName: _nameController.text,
//         memberNumber: _phoneController.text,
//         memberPaidAmount: _amountController.text,
//         memberFoodTime: provider.foodTime,
//         memberValidFrom: provider.dateRange.start,
//         memberValidTill: provider.dateRange.end,
//         memberExtendsStart: [],
//         memberExtendsEnd: []
//       );
//       GetDatabaseData getDatabaseData = GetDatabaseData();
//       //await getDatabaseData.getAllMembersDocs();
//       bool isValidMemberId =
//           await getDatabaseData.checkIfDocExists(memberDetails.memberId);
//       //bool isValidMobileNumber = getDatabaseData.checkIfPhoneExists(memberDetails.memberNumber);
//       if (!isValidMemberId) {
//         if (!cnt.mounted) return;
//         ShowSnackBar(context: cnt, message: "Member ID is not availabe");
//       } else {
//         InsertIntoDatabase insertIntoDatabase = InsertIntoDatabase();
//         bool isCreated = await insertIntoDatabase.updateMemberDetails(
//             memberDetails: memberDetails);
//         if (isCreated) {
//           if (!cnt.mounted) return;
//           ShowSnackBar(context: cnt, message: "Successfully updated");
//           GenerateReceipt obj = GenerateReceipt();
//           final receipt = await obj.receipt(memberDetails);
//           SendReceipt sendReceipt = SendReceipt();
//           final bool message = await sendReceipt.sendReceipt(receipt);
//           if (!cnt.mounted) return;
//           if (message == true) {
//             Navigator.pushReplacement(
//                 cnt, MaterialPageRoute(builder: (context) => HomeScreen()));
//             ShowSnackBar(context: cnt, message: "Successfully sent");
//             await getDatabaseData.getAllMembersDocs();
//           } else {
//             ShowSnackBar(
//                 context: cnt,
//                 message: "Something went wrong. Reciept doesn't send");
//           }
//         } else {
//           if (!cnt.mounted) return;
//           ShowSnackBar(
//               context: cnt,
//               message: "Something went wrong. Data dosen't stored in database");
//         }
//       }
//     }
//   }
// }
