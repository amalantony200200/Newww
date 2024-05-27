import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
class ExtendsMemberScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  late BuildContext cnt;
  final MemberDetails memberDetails;
  List<DateTime> startDate = [];
  List<DateTime> endDate = [];
  String printStartDate = "";
  String printEndDate = "";

  ExtendsMemberScreen({super.key, required this.memberDetails});

  @override
  Widget build(BuildContext context) {
    cnt = context;
    String printStartDate = "";
    String printEndDate = "";
    String noOfDays = "";
    final listOfExtendsStart = memberDetails.memberExtendsStart;
    final listOfExtendsEnd = memberDetails.memberExtendsEnd;
    if (listOfExtendsStart.isNotEmpty) {
      for (int i = 0; i < listOfExtendsStart.length; i++) {
        startDate.add(listOfExtendsStart[i]);
        endDate.add(listOfExtendsEnd[i]);
        printStartDate = "${printStartDate + DateFormat('MMM d').format(listOfExtendsStart[i]).toString()}\n";
        printEndDate = "${printEndDate + DateFormat('MMM d').format(listOfExtendsEnd[i]).toString()}\n";
        noOfDays = "${noOfDays + (int.parse(listOfExtendsEnd[i].difference(listOfExtendsStart[i]).inDays.toString()) + 1).toString()}\n";
      }
    }
    return Scaffold(
      appBar: appBar(),
      body: ChangeNotifierProvider<AddScreenProvider>(
        create: (context) => AddScreenProvider(
            dateRange: DateTimeRange(
                start: memberDetails.memberValidFrom,
                end: memberDetails.memberValidTill),
            foodTime: memberDetails.memberFoodTime,
            extendsDateRage: DateTimeRange(start: DateTime.now(), end: DateTime.now().add(const Duration(days: 0)))),
        child: Container(
          padding: const EdgeInsets.all(16),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Consumer<AddScreenProvider>(builder: (context, provider, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            extendsPageText("Id: ${memberDetails.memberId}"),
                            SizedBox(height: 5),
                            extendsPageText("Name: ${memberDetails.memberName}"),
                            SizedBox(height: 5),
                            extendsPageText("Mobile Number: ${memberDetails.memberNumber}"),
                            SizedBox(height: 5),
                            extendsPageText("Paid Amount: ${memberDetails.memberPaidAmount}"),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    if (startDate.isNotEmpty) ...[
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  extendsPageText("From"),
                                  Text(printStartDate),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  extendsPageText("Ends"),
                                  Text(printEndDate),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  extendsPageText("Days"),
                                  Text(noOfDays),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                    Text(
                      "Current Validity: ${DateFormat('MMM d').format(provider.dateRange.start)} to ${DateFormat('MMM d').format(provider.dateRange.end)}",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        extendsPageText("Select Extends Dates: "),
                        ElevatedButton.icon(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(BUTTON_COLOR)),
                          onPressed: () async {
                            await dateRangeButtonCalender(provider);
                          },
                          icon: Icon(Icons.calendar_month_sharp),
                          label: Text(
                            DateFormat('d/M/y').format(provider.extendsDateRage.end),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Extend Details:\n\tFrom: ${DateFormat('MMM d').format(provider.extendsDateRage.start)}\n\tTo: ${DateFormat('MMM d').format(provider.extendsDateRage.end)}\n\tDays: ${(int.parse(provider.extendsDateRage.end.difference(provider.extendsDateRage.start).inDays.toString()) + 1).toString()}",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                        child: ElevatedButton.icon(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(BUTTON_COLOR),
                          ),
                          onPressed: () async {
                            await updateButton(provider);
                          },
                          label: const Text(
                            "Extend",
                            style: TextStyle(color: Colors.white),
                          ),
                          icon: const Icon(Icons.add, color: Colors.white),
                        ),
                      ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> dateRangeButtonCalender(AddScreenProvider provider) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final newDate = DateTime.now();
    final initialDateRage = provider.extendsDateRage;
    final lastDate = newDate.add(const Duration(days: 365));
    final pickedDate = await showDateRangePicker(
      context: cnt,
      firstDate: newDate.subtract(const Duration(days: 30)),
      initialDateRange: initialDateRage,
      lastDate: lastDate,
      currentDate: newDate,
    );
    if (pickedDate != null) {
      final dateRange = pickedDate;
      final numberOfDays = pickedDate.duration.inDays;
      provider.setExtendsDate(dateRange);
      final totalUpto = memberDetails.memberValidTill.add(Duration(days: numberOfDays + 1));
      provider.setDate(DateTimeRange(start: memberDetails.memberValidFrom, end: totalUpto));
    }
  }

  Future<void> updateButton(AddScreenProvider provider) async {
    if (_formKey.currentState!.validate()) {
      startDate.add(provider.extendsDateRage.start);
      endDate.add(provider.extendsDateRage.end);
      MemberDetails memberDetails = MemberDetails(
        memberId: this.memberDetails.memberId,
        memberName: this.memberDetails.memberName,
        memberNumber: this.memberDetails.memberNumber,
        memberPaidAmount: this.memberDetails.memberPaidAmount,
        memberFoodTime: this.memberDetails.memberFoodTime,
        memberValidFrom: provider.dateRange.start,
        memberValidTill: provider.dateRange.end,
        memberExtendsStart: startDate,
        memberExtendsEnd: endDate,
      );
      GetDatabaseData getDatabaseData = GetDatabaseData();
      bool isValidMemberId = await getDatabaseData.checkIfDocExists(memberDetails.memberId);
      if (!isValidMemberId) {
        if (!cnt.mounted) return;
        ShowSnackBar(context: cnt, message: "Member ID is not available");
      } else {
        InsertIntoDatabase insertIntoDatabase = InsertIntoDatabase();
        bool isCreated = await insertIntoDatabase.updateMemberDetails(memberDetails: memberDetails);
        if (isCreated) {
          if (!cnt.mounted) return;
          ShowSnackBar(context: cnt, message: "Successfully updated");
          GenerateReceipt obj = GenerateReceipt();
          final receipt = await obj.receipt(memberDetails);
          SendReceipt sendReceipt = SendReceipt();
          final bool message = await sendReceipt.sendReceipt(receipt);
          if (!cnt.mounted) return;
          if (message) {
            Navigator.pushReplacement(cnt, MaterialPageRoute(builder: (context) => HomeScreen()));
            ShowSnackBar(context: cnt, message: "Successfully sent");
            await getDatabaseData.getAllMembersDocs();
          } else {
            ShowSnackBar(context: cnt, message: "Something went wrong. Receipt doesn't send");
          }
        } else {
          if (!cnt.mounted) return;
          ShowSnackBar(context: cnt, message: "Something went wrong. Data doesn't stored in database");
        }
      }
    }
  }

  AppBar appBar() {
    return AppBar(
      title: Text('Extend Member'),
      backgroundColor: BUTTON_COLOR,
    );
  }

  // Text extendsPageText(String text) {
  //   return Text(
  //     text,
  //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //   );
  // }

  void ShowSnackBar({required BuildContext context, required String message}) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
// ignore: must_be_immutable
// class ExtendsMemberScreen extends StatelessWidget {
//   final _formKey = GlobalKey<FormState>();
//   late BuildContext cnt;
//   final MemberDetails memberDetails;
//   List<DateTime> startDate=[];
//   List<DateTime> endDate=[];
//   String printStartDate = "";
//   String printEndDate = "";
//   ExtendsMemberScreen({super.key, required this.memberDetails});

//   @override
//   Widget build(BuildContext context) {
//     cnt = context;
//     String printStartDate = "";
//     String printEndDate = "";
//     String noOfDays = "";
//     final listOfExtendsStart = memberDetails.memberExtendsStart;
//     final listOfExtendsEnd = memberDetails.memberExtendsEnd;
//     if(listOfExtendsStart.isNotEmpty){
//       for(int i=0;i<listOfExtendsStart.length;i++){
//         startDate.add(listOfExtendsStart[i]);
//         endDate.add(listOfExtendsEnd[i]);
//         printStartDate="${printStartDate+DateFormat('MMM d').format(listOfExtendsStart[i]).toString()}\n";
//         printEndDate="${printEndDate+DateFormat('MMM d').format(listOfExtendsEnd[i]).toString()}\n";
        
//         noOfDays ="${noOfDays + (int.parse(listOfExtendsEnd[i].difference(listOfExtendsStart[i]).inDays.toString())+1).toString()}\n";
//       }
//     }
//     return Scaffold(
//       appBar: appBar(),
//       body: ChangeNotifierProvider<AddScreenProvider>(
//         create: (context) => AddScreenProvider(
//             dateRange: DateTimeRange(
//                 start: memberDetails.memberValidFrom,
//                 end: memberDetails.memberValidTill),
//             foodTime: memberDetails.memberFoodTime,extendsDateRage: DateTimeRange(start: DateTime.now(), end: DateTime.now().add(const Duration(days: 0)))),
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
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       width: MediaQuery.of(context).size.width,
//                       child: Text(
//                         "Extend Mess Validity",
//                         textAlign: TextAlign.center,
//                         style: GoogleFonts.sofiaSansCondensed(
//                           color: HEADING_TEXT_COLOR,
//                           fontSize: HEADING_TEXT_FONT_SIZE,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     TEXT_INPUT_FIELD_SIZEDBOX,
//                     extendsPageText("Id: ${memberDetails.memberId}"),
//                     const SizedBox(
//                       height: 5,
//                     ),
//                     extendsPageText("Name: ${memberDetails.memberName}"),
//                     const SizedBox(
//                       height: 5,
//                     ),
//                     extendsPageText(
//                         "Mobile Number: ${memberDetails.memberNumber}"),
//                     const SizedBox(
//                       height: 5,
//                     ),
//                     extendsPageText(
//                         "Paid Amount: ${memberDetails.memberPaidAmount}"),
//                     const SizedBox(
//                       height: 5,
//                     ),
//                     (startDate.isEmpty)?const SizedBox():Container(
//                       child: Row(
//                         children: [
//                           Column(
//                             children: [
//                               extendsPageText("From"),
//                               Text(printStartDate),
//                             ],
                            
//                           ),
//                           SizedBox(width: 30),
//                           Column(
//                             children: [
//                               extendsPageText("Ends"),
//                               Text(printEndDate),
//                             ],
//                           ),
//                           SizedBox(width: 30),
//                           Column(
//                             children: [
//                               extendsPageText("Days"),
//                               Text(noOfDays),
//                             ],
//                           ),
//                         ],),
//                     ),
//                     Text(
//                       "From: ${DateFormat('MMM d').format(provider.dateRange.start)}        To: ${DateFormat('MMM d').format(provider.dateRange.end)}",
//                       style: const TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20),
//                     ),
//                     const SizedBox(
//                       height: 5,
//                     ),
//                     Row(
//                       children: [
//                         extendsPageText("Select Extends Dates:  "),
//                         ElevatedButton.icon(
//                           style: ButtonStyle(
//                               backgroundColor:
//                                   MaterialStateProperty.all(BUTTON_COLOR)),
//                           onPressed: () async {
//                             await dateRangeButtonCalender(provider);
//                           },
//                           label: Text(
//                             DateFormat('d/M/y').format(provider.extendsDateRage.end),
//                             style: const TextStyle(color: Colors.white),
//                           ),
//                           icon: const Icon(Icons.calendar_month_sharp),
//                         ),
//                       ],
//                     ),
//                     TEXT_INPUT_FIELD_SIZEDBOX,
//                     Text(
//                         "Extend Details:\n\t\t\t\tFrom: ${DateFormat('MMM d').format(provider.extendsDateRage.start)}\n\t\t\t\tTo: ${DateFormat('MMM d').format(provider.extendsDateRage.end)}\n\t\t\t\tDays: ${(int.parse(provider.extendsDateRage.end.difference(provider.extendsDateRage.start).inDays.toString())+1).toString()}",
//                         style: const TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 20)),
//                     const SizedBox(
//                       height: 8,
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

//   Future<void> dateRangeButtonCalender(AddScreenProvider provider) async {
//     FocusManager.instance.primaryFocus?.unfocus();
//     final newDate = DateTime.now();
//     final initialDateRage = provider.extendsDateRage;
//     final lastDate = newDate.add(const Duration(days: 365));
//     final pickedDate = await showDateRangePicker(
//       context: cnt,
//       firstDate: newDate.subtract(const Duration(days: 30)),
//       initialDateRange: initialDateRage,
//       lastDate: lastDate,
//       currentDate: newDate,
//     );
//     final dateRange = pickedDate as DateTimeRange;
//     final numberOfDays = pickedDate.duration.inDays;
//     provider.setExtendsDate(dateRange);
//     final totalUpto = memberDetails.memberValidTill.add(Duration(days: numberOfDays+1));
//     provider.setDate(DateTimeRange(start: memberDetails.memberValidFrom, end: totalUpto));
//   }

//   Future<void> updateButton(AddScreenProvider provider) async {
//     if (_formKey.currentState!.validate()) {
//       //ShowSnackBar(context: context, message: "Processing...");
//       //print(provider.foodTime);
//       startDate.add(provider.extendsDateRage.start);
//       endDate.add(provider.extendsDateRage.end);
//       MemberDetails memberDetails = MemberDetails(
//         memberId: this.memberDetails.memberId,
//         memberName: this.memberDetails.memberName,
//         memberNumber: this.memberDetails.memberNumber,
//         memberPaidAmount: this.memberDetails.memberPaidAmount,
//         memberFoodTime: this.memberDetails.memberFoodTime,
//         memberValidFrom: provider.dateRange.start,
//         memberValidTill: provider.dateRange.end,
//         memberExtendsStart: startDate,
//         memberExtendsEnd: endDate
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
