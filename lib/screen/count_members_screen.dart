import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:malabar_mess_app/controller/get_database_controller.dart';
import 'package:malabar_mess_app/model/member_details.dart';


// ignore: must_be_immutable
class CountMemberScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  late BuildContext cnt;
  final ValueNotifier<DateTime> _selectedDate = ValueNotifier<DateTime>(DateTime.now());
  ValueNotifier<int> breakfast = ValueNotifier(0);
  ValueNotifier<int> lunch = ValueNotifier(0);
  ValueNotifier<int> dinner = ValueNotifier(0);
  ValueNotifier<int> totalBreakfast = ValueNotifier(0);
  ValueNotifier<int> totalLunch = ValueNotifier(0);
  ValueNotifier<int> totalDinner = ValueNotifier(0);

  CountMemberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    cnt = context;
    _selectedDate.value = DateTime.now();
    countFood();
    return Scaffold(
      appBar: appBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Daily Attendance",
                    style: GoogleFonts.sofiaSansCondensed(
                      color: Colors.blueAccent,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ValueListenableBuilder<DateTime>(
                      valueListenable: _selectedDate,
                      builder: (context, value, child) {
                        return Text(
                          DateFormat('MMM d').format(value),
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () async {
                        await _selectDate(context);
                        countFood();
                      },
                      child: const Text('Select Date'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildAttendanceCard("Breakfast", breakfast, totalBreakfast),
                _buildAttendanceCard("Lunch", lunch, totalLunch),
                _buildAttendanceCard("Dinner", dinner, totalDinner),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceCard(String meal, ValueNotifier<int> count, ValueNotifier<int> totalCount) {
    return ValueListenableBuilder<int>(
      valueListenable: count,
      builder: (context, value, child) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 4,
          child: ListTile(
            title: Text(
              meal,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Text("Count: $value, Extends: ${totalCount.value - value}"),
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      _selectedDate.value = picked;
      _selectedDate.notifyListeners();
    }
  }

  void countFood() {
    int breakFast = 0, lunch = 0, dinner = 0;
    int totalBreakfast = 0, totalLunch = 0, totalDinner = 0;
    final List<MemberDetails> memberDetails = GetDatabaseController.memberDetailsStatic;
    final date = _selectedDate.value;
    for (var member in memberDetails) {
      bool isMemberActive = member.memberValidFrom.isBefore(date) && member.memberValidTill.isAfter(date);
      bool isMemberExtended = member.memberExtendsStart.any((start) => date.isAfter(start)) &&
                              member.memberExtendsEnd.any((end) => date.isBefore(end));

      if (isMemberActive && !isMemberExtended) {
        final foodTime = member.memberFoodTime;
        if (foodTime[0] == '1') breakFast++;
        if (foodTime[1] == '1') lunch++;
        if (foodTime[2] == '1') dinner++;
      }

      if (isMemberActive) {
        final foodTime = member.memberFoodTime;
        if (foodTime[0] == '1') totalBreakfast++;
        if (foodTime[1] == '1') totalLunch++;
        if (foodTime[2] == '1') totalDinner++;
      }
    }
    breakfast.value = breakFast;
    this.lunch.value = lunch;
    this.dinner.value = dinner;
    this.totalBreakfast.value = totalBreakfast;
    this.totalLunch.value = totalLunch;
    this.totalDinner.value = totalDinner;
    this.lunch.notifyListeners();
  }

  AppBar appBar() {
    return AppBar(
      title: Text('Count Members Attendance'),
      backgroundColor: Colors.blueAccent,
    );
  }
}
// // ignore: must_be_immutable
// class CountMemberScreen extends StatelessWidget {
//   final _formKey = GlobalKey<FormState>();
//   late BuildContext cnt;
//   final ValueNotifier<DateTime> _selectedDate =
//       ValueNotifier<DateTime>(DateTime.now());
//   ValueNotifier<int> breakfast = ValueNotifier(0);
//   ValueNotifier<int> lunch = ValueNotifier(0);
//   ValueNotifier<int> dinner = ValueNotifier(0);
//   ValueNotifier<int> totalBreakfast= ValueNotifier(0);
//   ValueNotifier<int> totalLunch = ValueNotifier(0);
//   ValueNotifier<int> totalDinner = ValueNotifier(0);
//   CountMemberScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     cnt = context;
//     _selectedDate.value = DateTime.now();
//     countFood();
//     return Scaffold(
//       appBar: appBar(),
//       body: Container(
//         padding: const EdgeInsets.all(10),
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//               child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(
//                 width: MediaQuery.of(context).size.width,
//                 child: Text(
//                   "Daily Attendance",
//                   textAlign: TextAlign.center,
//                   style: GoogleFonts.sofiaSansCondensed(
//                     color: HEADING_TEXT_COLOR,
//                     fontSize: HEADING_TEXT_FONT_SIZE,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               TEXT_INPUT_FIELD_SIZEDBOX,
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   ValueListenableBuilder<DateTime>(
//                     valueListenable: _selectedDate,
//                     builder: (context, value, child) {
//                       return Text(
//                         DateFormat('MMM d').format(value),
//                         style: TextStyle(fontSize: 20),
//                       );
//                     },
//                   ),
//                   const SizedBox(width: 20),
//                   ElevatedButton(
//                     onPressed: () async{
//                       await _selectDate(context);
//                       countFood();
//                     },
//                     child: const Text('Select another date'),
//                   ),
//                 ],
//               ),
//               ValueListenableBuilder(
//                 valueListenable: breakfast,
//                 builder: (context, value, child) {
//                   return Text("BreakFast: $value No of extends: ${totalBreakfast.value- value}");
//                 },
//               ),
//               ValueListenableBuilder(
//                 valueListenable: lunch,
//                 builder: (context, value, child) {
//                   return Text("Lunch: $value No of extends: ${totalLunch.value - value}");
//                 },
//               ),
//               ValueListenableBuilder(
//                 valueListenable: dinner,
//                 builder: (context, value, child) {
//                   return Text("Dinner: $value No of extends: ${totalDinner.value - value}");
//                 },
//               ),
//               extendsPageText(""),
//               const SizedBox(
//                 height: 5,
//               ),
//             ],
//           )),
//         ),
//       ),
//     );
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate.value,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null) {
//       _selectedDate.value = picked;
//       _selectedDate.notifyListeners();
//     }
//   }

//   void countFood() {
//     int breakFast = 0, lunch = 0, dinner = 0;
//     int totalBreakfast =0,totalLunch =0, totalDinner =0;
//     final List<MemberDetails> memberDetails =
//         GetDatabaseController.memberDetailsStatic;
//     final date = _selectedDate.value;
//     for (int i = 0; i < memberDetails.length; i++) {
//       bool left = memberDetails[i].memberValidFrom.isBefore(date);
//       bool right = memberDetails[i].memberValidTill.isAfter(date);
//       bool extendsleft = false;
//       bool extendsright = false;
//       for (int j = 0; j < memberDetails[i].memberExtendsStart.length; j++) {
//         extendsleft = date.isAfter(memberDetails[i].memberExtendsStart[j]);
//         extendsright = date.isBefore(memberDetails[i].memberExtendsEnd[j]);
//         if (extendsright == true && extendsleft == true) {
//           break;
//         }
//       }
//       bool result =
//           (left && right && !extendsright && !extendsleft) ? true : false;
//       if (result == true) {
//         final foodTime = memberDetails[i].memberFoodTime;
//         if (foodTime[0] == '1') {
//           breakFast++;
//         }
//         if (foodTime[1] == '1') {
//           lunch++;
//         }
//         if (foodTime[2] == '1') {
//           dinner++;
//         }
//       }
//       bool totalCount =
//           (left && right) ? true : false;
//       if (totalCount == true) {
//         final foodTime = memberDetails[i].memberFoodTime;
//         if (foodTime[0] == '1') {
//           totalBreakfast++;
//         }
//         if (foodTime[1] == '1') {
//           totalLunch++;
//         }
//         if (foodTime[2] == '1') {
//           totalDinner++;
//         }
//       }
//     }
//     breakfast.value = breakFast;
//     this.lunch.value = lunch;
//     this.dinner.value = dinner;
//     this.totalBreakfast.value =totalBreakfast;
//     this.totalDinner.value = totalDinner;
//     this.totalLunch.value = totalLunch;
//     this.lunch.notifyListeners();
//   }
// }
