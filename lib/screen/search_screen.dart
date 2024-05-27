import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:malabar_mess_app/screen/extends_member_screen.dart';
import 'package:malabar_mess_app/screen/renewal_screen.dart';
import 'package:provider/provider.dart';
import 'package:malabar_mess_app/controller/get_database_controller.dart';
import 'package:malabar_mess_app/model/member_details.dart';
import 'package:malabar_mess_app/widget/app_bar.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});
  final TextEditingController _searchFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GetDatabaseController>(
      create: (_) => GetDatabaseController(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Search Members'),
          backgroundColor: Colors.teal,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Consumer<GetDatabaseController>(
              builder: (context, provider, child) {
            return Column(
              children: [
                TextFormField(
                  controller: _searchFieldController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: "Search member ID or Name",
                    labelText: "Member",
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {
                    displayList(provider, value);
                  },
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                ),
                SizedBox(height: 16),
                Expanded(
                  child: provider.sortedMemberDetails.isEmpty
                      ? const Center(child: Text('No members found'))
                      : ListView.builder(
                          itemCount: provider.sortedMemberDetails.length,
                          itemBuilder: (context, index) {
                            return MemberCard(
                              member: provider.sortedMemberDetails[index],
                              onRenewalPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => RenewalMemberScreen(memberDetails: provider.sortedMemberDetails[index])),
                                );
                              },
                              onExtendPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ExtendsMemberScreen(memberDetails: provider.sortedMemberDetails[index])),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  void displayList(GetDatabaseController provider, String value) {
    List<MemberDetails> membersList = [];
    final allList = GetDatabaseController.memberDetailsStatic;

    if (double.tryParse(value) != null) {
      membersList =
          allList.where((member) => member.memberId == value).toList();
    } else {
      membersList = allList
          .where((member) =>
              member.memberName.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }

    provider.setSortedMemberDetails(membersList);
  }
}

class MemberCard extends StatelessWidget {
  final MemberDetails member;
  final VoidCallback onRenewalPressed;
  final VoidCallback onExtendPressed;

  const MemberCard({
    Key? key,
    required this.member,
    required this.onRenewalPressed,
    required this.onExtendPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate days left
    DateTime now = DateTime.now();
    int daysLeft = member.memberValidTill.difference(now).inDays;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 8,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.lightGreenAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      member.memberName,
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    'ID: ${member.memberId}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        'Validity Upto: ${DateFormat('MMM d').format(member.memberValidTill)}',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.timer, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        '$daysLeft Days left',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.restaurant_menu, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Food Time: ${member.memberFoodTime[0] == '1' ? "Breakfast" : ""} ${member.memberFoodTime[1] == '1' ? "Lunch" : ""} ${member.memberFoodTime[2] == '1' ? "Dinner" : ""}',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: onRenewalPressed,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text('Renewal'),
                  ),
                  ElevatedButton(
                    onPressed: onExtendPressed,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text('Extend'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:malabar_mess_app/controller/get_database_controller.dart';
// import 'package:malabar_mess_app/model/member_details.dart';
// import 'package:malabar_mess_app/widget/app_bar.dart';
// import 'package:provider/provider.dart';

// class SearchScreen extends StatelessWidget {
//   SearchScreen({super.key});
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _searchField = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider<GetDatabaseController>(
//       create: (context) => GetDatabaseController(),
//       child: Scaffold(
//         appBar: appBar(),
//         body: Column(
//           children: [
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
//                 displayList(value);
//               },
//               onTapOutside: (event) {
//                 FocusManager.instance.primaryFocus?.unfocus();
//               },
//             ),
//             Consumer<GetDatabaseController>(
//                 builder: (context, provider, child) {
//               int inc = 0;
//               return Expanded(
//                 child: ListView.builder(
//                   itemCount: (provider.sortedMemberDetails.length + 1) ~/ 2,
//                   itemBuilder: (context, index) {
//                     return Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Card(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10.0),
//                           ),
//                           elevation: 5,
//                           child: Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Column(
//                               mainAxisSize: MainAxisSize.max,
//                               children: <Widget>[
//                                 Text(
//                                   provider
//                               .sortedMemberDetails[index + inc].memberName,
//                                   style: const TextStyle(
//                                     fontSize: 24.0,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 SizedBox(height: 10),
//                                 Text(
//                                   "ID${provider
//                               .sortedMemberDetails[index + inc].memberId}",
//                                   style: TextStyle(
//                                     fontSize: 16.0,
//                                     color: Colors.grey[700],
//                                   ),
//                                 ),
//                                 SizedBox(height: 5),
//                                 Text(
//                                   'Days Left: 5',
//                                   style: TextStyle(
//                                     fontSize: 16.0,
//                                     color: Colors.grey[700],
//                                   ),
//                                 ),
//                                 SizedBox(height: 5),
//                                 Text(
//                                   'Food Time: ${provider
//                               .sortedMemberDetails[index + inc].memberFoodTime}',
//                                   style: TextStyle(
//                                     fontSize: 16.0,
//                                     color: Colors.grey[700],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Card(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10.0),
//                           ),
//                           elevation: 5,
//                           child: Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Column(
//                               mainAxisSize: MainAxisSize.max,
//                               children: <Widget>[
//                                 Text(
//                                   provider
//                               .sortedMemberDetails[index + (++inc)].memberName,
//                                   style: const TextStyle(
//                                     fontSize: 24.0,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 10),
//                                 Text(
//                                   'ID: ${provider
//                               .sortedMemberDetails[index + inc].memberId}',
//                                   style: TextStyle(
//                                     fontSize: 16.0,
//                                     color: Colors.grey[700],
//                                   ),
//                                 ),
//                                 const SizedBox(height: 5),
//                                 Text(
//                                   'Days Left: 5',
//                                   style: TextStyle(
//                                     fontSize: 16.0,
//                                     color: Colors.grey[700],
//                                   ),
//                                 ),
//                                 const SizedBox(height: 5),
//                                 Text(
//                                   'Food Time: ${provider
//                               .sortedMemberDetails[index + inc].memberFoodTime}',
//                                   style: TextStyle(
//                                     fontSize: 16.0,
//                                     color: Colors.grey[700],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               );
//             }),
//           ],
//         ),
//       ),
//     );
//   }

//   void displayList(String value) {
//     List<MemberDetails> membersList = [];
//     GetDatabaseController provider = GetDatabaseController();
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
// }
