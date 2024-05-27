import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:malabar_mess_app/controller/add_controller.dart';
import 'package:malabar_mess_app/controller/get_database_controller.dart';
import 'package:malabar_mess_app/model/member_details.dart';
import 'package:malabar_mess_app/repo/get_database_data.dart';
import 'package:malabar_mess_app/repo/insert_into_database.dart';
import 'package:malabar_mess_app/widget/app_bar.dart';
import 'package:malabar_mess_app/widget/check_box.dart';
import 'package:malabar_mess_app/widget/small_heading.dart';
import 'package:provider/provider.dart';
class AttendanceScreen extends StatelessWidget {
  AttendanceScreen({super.key});
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    GetDatabaseData obj = GetDatabaseData();
    obj.getAttendance(DateFormat('MMM d').format(DateTime.now()).toString());
    return ChangeNotifierProvider<GetDatabaseController>(
      create: (context) => GetDatabaseController(),
      child: Scaffold(
        appBar: appBar(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<GetDatabaseController>(
              builder: (context, provider, child) {
            return Column(
              children: [
                TextFormField(
                  controller: _searchField,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: "Search member ID or Name",
                    labelText: "Member",
                    //prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {
                    displayList(value, provider);
                  },
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      String foodTime = (GetDatabaseController.attendance[
                                  provider.sortedMemberDetails[index].memberId] ==
                              null)
                          ? "000"
                          : GetDatabaseController.attendance[
                              provider.sortedMemberDetails[index].memberId]!;
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 4,
                        child: ListTile(
                          onTap: () {},
                          tileColor: const Color.fromARGB(255, 207, 220, 245),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          title: smallHeading(
                            str:
                                "${provider.sortedMemberDetails[index].memberId}   ${provider.sortedMemberDetails[index].memberName}",
                          ),
                          subtitle: ChangeNotifierProvider<AddScreenProvider>(
                            create: (context) => AddScreenProvider(
                                dateRange: DateTimeRange(
                                    start: DateTime.now(), end: DateTime.now()),
                                extendsDateRage: DateTimeRange(
                                    start: DateTime.now(),
                                    end: DateTime.now()),
                                foodTime: foodTime),
                            child: Consumer<AddScreenProvider>(
                                builder: (context, provider1, child) {
                              return Row(
                                children: [
                                  checkBox(
                                      "B",
                                      '1' == provider1.foodTime[0]
                                          ? true
                                          : false, (value) {
                                    foodTimeShift(0, provider1);
                                  }),
                                  const SizedBox(width: 10),
                                  checkBox(
                                      "L",
                                      '1' == provider1.foodTime[1]
                                          ? true
                                          : false, (value) {
                                    foodTimeShift(1, provider1);
                                  }),
                                  const SizedBox(width: 10),
                                  checkBox(
                                      "D",
                                      '1' == provider1.foodTime[2]
                                          ? true
                                          : false, (value) {
                                    foodTimeShift(2, provider1);
                                  }),
                                  const SizedBox(width: 10),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                      primary: Colors.blue,
                                    ),
                                    child: const Text(
                                      "Add",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () async {
                                      InsertIntoDatabase obj =
                                          InsertIntoDatabase();
                                      obj.addAttendance(
                                          provider.sortedMemberDetails[index]
                                              .memberId,
                                          provider1);
                                    },
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                      );
                    },
                    itemCount: provider.sortedMemberDetails.length,
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  void displayList(String value, GetDatabaseController provider) {
    List<MemberDetails> membersList = [];
    final allList = provider.memberDetails;
    if (value.isNum) {
      for (int i = 0; i < allList.length; i++) {
        if (value == allList[i].memberId) {
          membersList.add(allList[i]);
        }
      }
    } else {
      for (int i = 0; i < allList.length; i++) {
        if (allList[i].memberName
            .toLowerCase()
            .contains(value.toLowerCase())) {
          membersList.add(allList[i]);
        }
      }
    }
    provider.setSortedMemberDetails(membersList);
  }

  void foodTimeShift(int position, AddScreenProvider provider) {
    String char0 = provider.foodTime[0];
    String char1 = provider.foodTime[1];
    String char2 = provider.foodTime[2];

    if (position == 0) {
      (char0 == '1') ? char0 = '0' : char0 = '1';
    } else if (position == 1) {
      (char1 == '1') ? char1 = '0' : char1 = '1';
    } else if (position == 2) {
      (char2 == '1') ? char2 = '0' : char2 = '1';
    }
    provider.setFoodTime(char0 + char1 + char2);
  }

  AppBar appBar() {
    return AppBar(
      title: Text('Attendance'),
      backgroundColor: Colors.blue,
    );
  }
}
// class AttendanceScreen extends StatelessWidget {
//   AttendanceScreen({super.key});
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _searchField = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     GetDatabaseData obj = GetDatabaseData();
//     obj.getAttendance(DateFormat('MMM d').format(DateTime.now()).toString());
//     return ChangeNotifierProvider<GetDatabaseController>(
//       create: (context) => GetDatabaseController(),
//       child: Scaffold(
//         appBar: appBar(),
//         body: Consumer<GetDatabaseController>(
//             builder: (context, provider, child) {
//           int inc = 0;
//           return Column(children: [
//             TextFormField(
//               controller: _searchField,
//               keyboardType: TextInputType.visiblePassword,
//               textInputAction: TextInputAction.search,
//               decoration: InputDecoration(
//                 hintText: "Search member ID or Name",
//                 labelText: "Member",
//                 isDense: true,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               onChanged: (value) {
//                 displayList(value, provider);
//               },
//               onTapOutside: (event) {
//                 FocusManager.instance.primaryFocus?.unfocus();
//               },
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemBuilder: (BuildContext context, int index) {
//                   String foodTime = (GetDatabaseController.attendance[
//                               provider.sortedMemberDetails[index].memberId] ==
//                           null)
//                       ? "000"
//                       : GetDatabaseController.attendance[
//                           provider.sortedMemberDetails[index].memberId]!;
//                   return Container(
//                     margin: const EdgeInsets.only(top: 8),
//                     child: ListTile(
//                       onTap: () {},
//                       tileColor: const Color.fromARGB(255, 207, 220, 245),
//                       shape: RoundedRectangleBorder(
//                         side: const BorderSide(width: 2),
//                         borderRadius: BorderRadius.circular(20), //<-- SEE HERE
//                       ),
//                       title: smallHeading(
//                           str:
//                               "${provider.sortedMemberDetails[index].memberId}   ${provider.sortedMemberDetails[index].memberName}"),
//                       subtitle: ChangeNotifierProvider<AddScreenProvider>(
//                         create: (context) => AddScreenProvider(
//                             dateRange: DateTimeRange(
//                                 start: DateTime.now(), end: DateTime.now()),
//                             extendsDateRage: DateTimeRange(
//                                 start: DateTime.now(), end: DateTime.now()),
//                             foodTime: foodTime!),
//                         child: Consumer<AddScreenProvider>(
//                             builder: (context, provider1, child) {
//                           return Row(
//                             children: [
//                               checkBox("B",
//                                   '1' == provider1.foodTime[0] ? true : false,
//                                   (value) {
//                                 foodTimeShift(0, provider1);
//                               }),
//                               const SizedBox(
//                                 width: 10,
//                               ),
//                               checkBox("L",
//                                   '1' == provider1.foodTime[1] ? true : false,
//                                   (value) {
//                                 foodTimeShift(1, provider1);
//                               }),
//                               const SizedBox(
//                                 width: 10,
//                               ),
//                               checkBox("D",
//                                   '1' == provider1.foodTime[2] ? true : false,
//                                   (value) {
//                                 foodTimeShift(2, provider1);
//                               }),
//                               const SizedBox(
//                                 width: 10,
//                               ),
//                               ElevatedButton(
//                                 child: const Text("Add",style: TextStyle(color: Colors.white),),
//                                 onPressed: () async{
//                                   InsertIntoDatabase obj = InsertIntoDatabase();
//                                   obj.addAttendance(provider.sortedMemberDetails[index].memberId,provider1);
//                               }),
//                             ],
//                           );
//                         }),
//                       ),
//                       //trailing: list[index].memberDateRange.end.isBefore(DateTime.now())?:
//                     ),
//                   );
//                 },
//                 itemCount: provider.sortedMemberDetails.length,
//               ),
//             ),
//           ]);
//         }),
//       ),
//     );
//   }

//   void displayList(String value, GetDatabaseController provider) {
//     List<MemberDetails> membersList = [];
//     final allList = provider.memberDetails;
//     if (value.isNum) {
//       for (int i = 0; i < allList.length; i++) {
//         if (value == allList[i].memberId) {
//           membersList.add(allList[i]);
//         }
//       }
//     } else {
//       for (int i = 0; i < allList.length; i++) {
//         if (allList[i].memberName.toLowerCase().contains(value.toLowerCase())) {
//           membersList.add(allList[i]);
//         }
//       }
//     }
//     provider.setSortedMemberDetails(membersList);
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
// }
